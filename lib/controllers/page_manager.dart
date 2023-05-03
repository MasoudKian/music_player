import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  static String _url =
      'https://dl.mokhtalefmusic.com/music/1398/02/26/Deep%20House/Jay%20Aliev%20Deep.mp3';

  late AudioPlayer _audioPlayer;

  PageManager() {
    _init();
  }

  void play () async{
    await _audioPlayer.setUrl(_url);
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(position){
    _audioPlayer.seek(position);
  }
  void _init() async {
    _audioPlayer = AudioPlayer();


    // Handle Icon Play & Pause & Progress
    _audioPlayer.playerStateStream.listen((playerState) {
      final playing = playerState.playing;
      final progressingState = playerState.processingState;

      if (progressingState == ProcessingState.loading ||
          progressingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!playing) {
        buttonNotifier.value = ButtonState.paused;
      } else {
        buttonNotifier.value = ButtonState.playing;
      }
    });
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
    _audioPlayer.bufferedPositionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: position,
        total: oldState.total,
      );
    });
    _audioPlayer.durationStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: position??Duration.zero,
      );
    });
  }

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );

  final buttonNotifier = ValueNotifier(ButtonState.paused);
}

class ProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  ProgressBarState(
      {required this.current, required this.buffered, required this.total});
}

enum ButtonState { paused, playing, loading }
