import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:adtec_api/post_model.dart';
import 'dart:async';
import 'dart:convert';

// Bahagian untuk mendapatkan data daripada API
Future<List<Post>> fetchPost() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<Post>((json) => Post.fromMap(json)).toList();
  } else {
    throw Exception('Gagal dapatkan data API.');
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Post>> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Post API Fetch',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sample Post API Fetch'),
        ),
        body: FutureBuilder<List<Post>>(
            future: futurePost,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          children: [
                            Card(
                              color: Colors.indigo,
                              margin: EdgeInsets.all(20),
                              child: ListTile(
                                title: Text(
                                  '${snapshot.data![index].id}) ${snapshot.data![index].title}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                              width: 300,
                              child: Divider(
                                color: Colors.black54,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PostDetail(post: snapshot.data![index]),
                                  ),
                                );
                              },
                              child: Text('Lihat Kandungan Post'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

class PostDetail extends StatelessWidget {
  const PostDetail({Key? key, required this.post}) : super(key: key);

  // Declare data yang pegang value post
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Card(
                  color: Colors.indigo,
                  margin: EdgeInsets.all(20),
                  child: ListTile(
                    title: Text(
                      post.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                  width: 300,
                  child: Divider(
                    color: Colors.black54,
                  ),
                ),
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(20),
                  child: ListTile(
                    title: Text(
                      post.body,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
