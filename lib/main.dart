import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/music_player_screen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  AudioPlayer audioPlayer = AudioPlayer();
  PageController controller = PageController(
    initialPage: 0,
  );


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Rich'),
      debugShowCheckedModeBanner: false,
      home:  Scaffold(
        body: PageView(
          controller: controller,
          scrollDirection: Axis.vertical,
          children: [
            const HomeScreen(),
            MusicPlayerScreen(controller,audioPlayer)
          ],
        ),
      ),
    );
  }
}
