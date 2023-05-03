import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player/constanct/my-text-style.dart';

import '../controllers/page_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageManager _pageManager;

  late Size size;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageManager = PageManager();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: Image.asset(
              'assets/images/headdeep.jpg',
              fit: BoxFit.cover,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 2),
            child: Container(
              color: Colors.black38.withOpacity(0.6),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height:10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const Text(
                              'Now Playing',
                              style: headStyle,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3000),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.25),
                              spreadRadius: 1,
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 200,
                          backgroundColor: Colors.black38,
                          child: CircleAvatar(
                            radius: 185,
                            backgroundImage:
                                AssetImage('assets/images/headdeep.jpg'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Deep House',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white)),
                              SizedBox(height: 10),
                              Text('Relaxing Work',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white38))
                            ],
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.favorite,
                            size: 35,
                            color: Colors.white38,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder<ProgressBarState>(
                          valueListenable: _pageManager.progressNotifier,
                          builder: (context, value, _) {
                            return ProgressBar(
                              progress: value.current,
                              buffered: value.buffered,
                              total: value.total,
                              onSeek: (duration) {},
                              thumbColor: Colors.white,
                              progressBarColor: Colors.red,
                              baseBarColor: Colors.grey,
                              thumbGlowColor:
                                  Colors.redAccent.withOpacity(0.25),
                              timeLabelTextStyle: const TextStyle(fontSize: 15),
                            );
                          }),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.repeat,
                            color: Colors.white,
                            size: 35,
                          ),
                          const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: 35,
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.redAccent.withOpacity(0.8),
                                      const Color(0xcc722520),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter),
                                borderRadius: BorderRadius.circular(50)),
                            child: ValueListenableBuilder<ButtonState>(
                              valueListenable: _pageManager.buttonNotifier,
                              builder: (context, ButtonState value, _) {
                                switch (value) {
                                  case ButtonState.loading:
                                    return const CircularProgressIndicator();
                                  case ButtonState.playing:
                                    return IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: _pageManager.pause,
                                      icon: const Icon(
                                        Icons.pause,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    );
                                  case ButtonState.paused:
                                    return IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: _pageManager.play,
                                      icon: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    );
                                }
                              },
                            ),
                          ),
                          const Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 35,
                          ),
                          const Icon(
                            Icons.volume_down_alt,
                            color: Colors.white,
                            size: 35,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
