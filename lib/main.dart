import 'package:flutter/material.dart';
import 'package:blogs/views/home.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Blogs",
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home : Home(),
    );
  }
}
