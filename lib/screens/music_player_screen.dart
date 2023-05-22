import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player/constanct/my-text-style.dart';
import '../controllers/page_manager.dart';

class MusicPlayerScreen extends StatelessWidget {
  MusicPlayerScreen(this.controller, this._pageManager, {Key? key})
      : super(key: key);

  final PageController controller;
  final PageManager _pageManager;

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          height: size.height,
          width: size.width,
          child: ValueListenableBuilder(
            valueListenable: _pageManager.currentSongDetailNotifier,
            builder: (context, AudioMetaData value, child) {
              String image = value.imageAddress;
              return Image.asset(
                image,
                fit: BoxFit.cover,
              );
            },
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
                            onPressed: () {
                              controller.animateToPage(0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            },
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
                      child: CircleAvatar(
                        radius: 200,
                        backgroundColor: Colors.black38,
                        child: ValueListenableBuilder(
                          valueListenable:
                              _pageManager.currentSongDetailNotifier,
                          builder: (context, AudioMetaData value, child) {
                            String image = value.imageAddress;
                            return CircleAvatar(
                              radius: 185,
                              backgroundImage: AssetImage(image),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable:
                              _pageManager.currentSongDetailNotifier,
                          builder: (context, AudioMetaData value, child) {
                            String title = value.title;
                            String artist = value.artist;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  artist,
                                  style: const TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  title,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white38),
                                ),
                              ],
                            );
                          },
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
                            thumbColor: Colors.white,
                            progressBarColor: Colors.red,
                            baseBarColor: Colors.grey,
                            bufferedBarColor: Colors.white,
                            thumbGlowColor: Colors.redAccent.withOpacity(0.25),
                            timeLabelTextStyle: const TextStyle(fontSize: 15),
                            onSeek: _pageManager.seek,
                            // onSeek: (position) {
                            //   _pageManager.seek(position);
                            // },
                          );
                        }),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: _pageManager.repeatStateNotifier,
                          builder: (context, RepeatState value, child) {
                            switch (value) {
                              case RepeatState.off:
                                return IconButton(
                                  icon:
                                      const Icon(Icons.key_off_sharp, size: 35),
                                  onPressed: _pageManager.onRepeatPressed,
                                  color: Colors.white,
                                  padding: EdgeInsets.zero,
                                );
                              case RepeatState.one:
                                return IconButton(
                                  icon: const Icon(Icons.repeat_one_rounded,
                                      size: 35),
                                  color: Colors.white,
                                  padding: EdgeInsets.zero,
                                  onPressed: _pageManager.onRepeatPressed,
                                );
                              case RepeatState.all:
                                return IconButton(
                                  icon: const Icon(Icons.repeat_rounded,
                                      size: 35),
                                  color: Colors.white,
                                  padding: EdgeInsets.zero,
                                  onPressed: _pageManager.onRepeatPressed,
                                );
                            }
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: _pageManager.isFirstSongNotifier,
                          builder: (context, bool value, child) {
                            return IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.skip_previous_rounded,
                                size: 35,
                              ),
                              color: Colors.white,
                              onPressed:
                                  value ? null : _pageManager.onBackPressed,
                            );
                          },
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
                                  return const CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  );
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
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  );
                              }
                            },
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _pageManager.isFirstSongNotifier,
                          builder: (context, bool value, child) {
                            return IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.skip_next_rounded,
                                size: 35,
                                color: Colors.white,
                              ),
                              color: Colors.white,
                              onPressed: _pageManager.onNextPressed,
                            );
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: _pageManager.volumeStateNotifier,
                          builder: (context, double value, child) {
                            if (value == 0) {
                              return IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.volume_off_outlined,
                                    size: 35),
                                color: Colors.white,
                                onPressed: _pageManager.onVolumePressed,
                              );
                            } //
                            else {
                              return IconButton(
                                padding: EdgeInsets.zero,
                                icon:
                                    const Icon(Icons.volume_down_alt, size: 35),
                                color: Colors.white,
                                onPressed: _pageManager.onVolumePressed,
                              );
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
