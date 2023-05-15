import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  final AudioPlayer _audioPlayer;

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );

  final buttonNotifier = ValueNotifier(ButtonState.paused);
  final currentSongDetailNotifier = ValueNotifier<AudioMetaData>(
      AudioMetaData(title: "", artist: "", imageAddress: ""));

  final playListNotifier = ValueNotifier<List<String>>([]);
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final repeatStateNotifier = ValueNotifier<RepeatState>(RepeatState.off);

  late ConcatenatingAudioSource _playlist;

  PageManager(this._audioPlayer) {
    _init();
  }

  void _init() async {
    _setInitialPlayerList();
    _listenChangePlayerState();
    _listenChangePositionStream();
    _listenChangeBufferedPositionStream();
    _listenChangeTotalDurationStream();

    _listenSequenceState();
  }

  void _setInitialPlayerList() async {
    // String url =
    //     'https://dl.mokhtalefmusic.com/music/1398/02/26/Deep%20House/Jay%20Aliev%20Deep.mp3';
    // if (_audioPlayer.bufferedPosition == Duration.zero) {
    //   await _audioPlayer.setUrl(url);
    // }

    const prefix = 'assets/images';

    final song1 = Uri.parse(
        'https://songsara.net/vip-dl/?filename=dl/2022/10/Ethnic%20Deep%20House%202%20(Playlist)/01%20Marrakesh.mp3');
    final song2 = Uri.parse(
        'https://songsara.net/vip-dl/?filename=dl/2022/10/Ethnic%20Deep%20House%202%20(Playlist)/03%20Kameyama.mp3');
    final song3 = Uri.parse(
        'https://songsara.net/vip-dl/?filename=dl/2022/10/Ethnic%20Deep%20House%202%20(Playlist)/04%20Miramar.mp3');
    final song4 = Uri.parse(
        'https://songsara.net/vip-dl/?filename=dl/2022/10/Ethnic%20Deep%20House%202%20(Playlist)/06%20All%20Rise%20(Radio%20Mix).mp3');
    final song5 = Uri.parse(
        'https://songsara.net/vip-dl/?filename=dl/2022/10/Ethnic%20Deep%20House%202%20(Playlist)/07%20Go%20Up%20Go%20Up.mp3');

    _playlist = ConcatenatingAudioSource(
      children: [
        AudioSource.uri(
          song1,
          tag: AudioMetaData(
              title: 'Music 1',
              artist: 'Deep1',
              imageAddress: '$prefix/deep1.jpg'),
        ),
        AudioSource.uri(
          song1,
          tag: AudioMetaData(
              title: 'Music 2',
              artist: 'Deep2',
              imageAddress: '$prefix/deep2.jpg'),
        ),
        AudioSource.uri(
          song1,
          tag: AudioMetaData(
              title: 'Music 3',
              artist: 'Deep3',
              imageAddress: '$prefix/deep3.jpg'),
        ),
        AudioSource.uri(
          song1,
          tag: AudioMetaData(
              title: 'Music 4',
              artist: 'Deep4',
              imageAddress: '$prefix/deep4.jpg'),
        ),
        AudioSource.uri(
          song1,
          tag: AudioMetaData(
              title: 'Music 5',
              artist: 'Deep5',
              imageAddress: '$prefix/deep5.jpg'),
        ),
      ],
    );
    _audioPlayer.setAudioSource(_playlist);
  }

  void _listenChangePositionStream() {
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenChangeBufferedPositionStream() {
    _audioPlayer.bufferedPositionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: position,
        total: oldState.total,
      );
    });
  }

  void _listenChangeTotalDurationStream() {
    _audioPlayer.durationStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: position ?? Duration.zero,
      );
    });
  }

  void _listenChangePlayerState() {
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
  }

  void _listenSequenceState() {}

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(position) {
    _audioPlayer.seek(position);
  }
}

class AudioMetaData {
  final String title;
  final String artist;
  final String imageAddress;

  AudioMetaData(
      {required this.title, required this.artist, required this.imageAddress});
}

class ProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  ProgressBarState(
      {required this.current, required this.buffered, required this.total});
}

enum ButtonState { paused, playing, loading }

enum RepeatState { one, all, off }
