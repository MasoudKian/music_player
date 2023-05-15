import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/controllers/page_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this._audioPlayer, {Key? key}) : super(key: key);

  final AudioPlayer _audioPlayer;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageManager _pageManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageManager = PageManager(widget._audioPlayer);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ValueListenableBuilder(
            valueListenable: _pageManager.playListNotifier,
            builder: (context, List<String> value, child) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      value[index],
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}
