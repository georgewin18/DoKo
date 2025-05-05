import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(DokoApp());
}

class DokoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doko',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(),
    );
  }
}
