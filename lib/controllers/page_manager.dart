import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  static String _url =
      'https://dl.mokhtalefmusic.com/music/1398/02/26/Deep%20House/Jay%20Aliev%20Deep.mp3';

  late AudioPlayer _audioPlayer;

  PageManager() {
    _init();
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void _init() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setUrl(_url);

    // Handle Icon Play & Pause & Progress
    _audioPlayer.playerStateStream.listen((playerState) {
      final playing = playerState.playing;
      final progressingState = playerState.processingState;

      if (progressingState == ProcessingState.loading ||
          progressingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      }
      else if(!playing){
        buttonNotifier.value = ButtonState.paused;
      }
      else{
        buttonNotifier.value = ButtonState.playing;
      }
    });
  }

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      Duration.zero,
      Duration.zero,
      Duration.zero,
    ),
  );

  final buttonNotifier = ValueNotifier(ButtonState.paused);
}

class ProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  ProgressBarState(this.current, this.buffered, this.total);
}

enum ButtonState { paused, playing, loading }
