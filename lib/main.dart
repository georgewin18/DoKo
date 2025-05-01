import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(DokoApp());
}

class DokoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< Updated upstream
<<<<<<< HEAD
      title: 'bebek',
=======
      title: 'Udang',
>>>>>>> 4b738649bb9b9e731143108ff06d3ba40952169b
=======
      title: 'Doko',
      debugShowCheckedModeBanner: false,
>>>>>>> Stashed changes
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(),
    );
  }
}
