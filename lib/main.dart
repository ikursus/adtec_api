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
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Card(
                            child: Text('${snapshot.data![index].title}'),
                          ),
                          SizedBox(height: 15),
                          Text('${snapshot.data![index].body}')
                        ],
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
