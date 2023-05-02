import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player/constanct/my-text-style.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  late Size size;

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
                        height: 100,
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
                      ProgressBar(
                        progress: const Duration(milliseconds: 1000),
                        buffered: const Duration(milliseconds: 2000),
                        total: const Duration(milliseconds: 5000),
                        onSeek: (duration) {},
                        thumbColor: Colors.white,
                        progressBarColor: Colors.red,
                        baseBarColor: Colors.grey,
                        thumbGlowColor: Colors.redAccent.withOpacity(0.25),
                        timeLabelTextStyle: const TextStyle(fontSize: 15),
                      ),
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
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.redAccent.withOpacity(0.8),
                                      const Color(0xcc722520),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter),
                                borderRadius: BorderRadius.circular(50)),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
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
