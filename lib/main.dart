import 'package:flutter/material.dart';
import 'package:music_player/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(fontFamily: 'Rich'),
      debugShowCheckedModeBanner: false,
      home:  HomeScreen(),
    );
  }
}

