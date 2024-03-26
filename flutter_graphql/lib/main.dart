import 'package:flutter/material.dart';
import 'blog_row.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World',
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Hygraph Blog",
          ),
        ),
        body: ListView(
          children: const [
            BlogRow(
              title: 'Blog 1',
              excerpt: 'Blog 1 excerpt',
              coverURL: 'https://picsum.photos/200',
            ),
            BlogRow(
              title: 'Blog 2',
              excerpt: 'Blog 2 excerpt',
              coverURL: 'https://picsum.photos/200',
            ),
            BlogRow(
              title: 'Blog 3',
              excerpt: 'Blog 3 excerpt',
              coverURL: 'https://picsum.photos/200',
            ),
          ],
        ),
      ),
    );
  }
}
