import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/controllers/page_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.controller, this._pageManager, {Key? key})
      : super(key: key);

  final PageController controller;
  final PageManager _pageManager;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 60,
            width: double.infinity,
            color: Colors.grey,
            child: const Center(
              child: Text(
                'Play List',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _pageManager.playListNotifier,
              builder: (context, List<MediaItem> song, child) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: song.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      child: ListTile(
                        tileColor: Colors.grey.shade200,
                        title: Text(song[index].artist ?? ''),
                        subtitle: Text(song[index].title),
                        // leading: CircleAvatar(
                        //   radius: 45,
                        //   backgroundImage: AssetImage(
                        //     song[index].imageAddress,
                        //   ),
                        // ),
                        onTap: () {
                          controller.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                          _pageManager.playFromPlayList(index);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _pageManager.currentSongDetailNotifier,
            builder: (context, AudioMetaData audio, _) {
              return Container(
                color: Colors.grey.shade300,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(audio.imageAddress),
                  ),
                  title: Text(audio.artist),
                  subtitle: Text(audio.title),
                  trailing: ValueListenableBuilder(
                    valueListenable: _pageManager.buttonNotifier,
                    builder: (context, ButtonState value, _) {
                      switch (value) {
                        case ButtonState.loading:
                          return const SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.black),
                            ),
                          );
                        case ButtonState.playing:
                          return IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: _pageManager.pause,
                            icon: const Icon(
                              Icons.pause_circle_outline_rounded,
                              color: Colors.black,
                              size: 40,
                            ),
                          );
                        case ButtonState.paused:
                          return IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: _pageManager.play,
                            icon: const Icon(
                              Icons.play_circle_outline_rounded,
                              color: Colors.black,
                              size: 40,
                            ),
                          );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
