import 'package:flutter/material.dart';
import 'package:music_player/controllers/page_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.controller, this._pageManager ,{Key? key}) : super(key: key);

  final PageController controller;
  final  PageManager _pageManager;


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
              builder: (context, List<AudioMetaData> song, child) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: song.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      child: ListTile(
                        tileColor: Colors.grey.shade200,
                        title: Text(song[index].artist),
                        subtitle: Text(song[index].title),
                        leading: CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage(song[index].imageAddress),
                        ),
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
                  trailing: const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
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
