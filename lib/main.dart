import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/controllers/page_manager.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/music_player_screen.dart';
import 'package:music_player/services/service_locator.dart';

void main() async {
  await setupInitService();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  PageController controller = PageController(
    initialPage: 0,
  );

  PageManager get pageManager => PageManager();

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
             HomeScreen(controller,pageManager),
            MusicPlayerScreen(controller,pageManager)
          ],
        ),
      ),
    );
  }
}
