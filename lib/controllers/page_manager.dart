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

  final playListNotifier = ValueNotifier<List<AudioMetaData>>([]);
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final repeatStateNotifier = RepeatStateNotifier();

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
        'https://dl.mokhtalefmusic.com/music/1398/02/26/Deep%20House/Jay%20Aliev%20Deep.mp3');
    final song2 = Uri.parse(
        'https://avapedia.com/station/24054/masih-to-ke-nisti-pisham-ft-arash-ap/d?nonce=05c8a58693');
    final song3 = Uri.parse(
        'https://avapedia.com/station/2497/shah-beyt/d?nonce=05c8a58693');
    final song4 = Uri.parse(
        'https://avapedia.com/station/24044/khabe-khoob/d?nonce=05c8a58693');
    final song5 = Uri.parse(
        'https://avapedia.com/station/24052/aroome-del/d?nonce=05c8a58693');

    _playlist = ConcatenatingAudioSource(
      children: [
        AudioSource.uri(
          song1,
          tag: AudioMetaData(
              title: 'Deep House 1',
              artist: 'Ethnic',
              imageAddress: '$prefix/deep1.jpg'),
        ),
        AudioSource.uri(
          song2,
          tag: AudioMetaData(
              title: 'Deep House 1',
              artist: 'Love',
              imageAddress: '$prefix/deep2.jpeg'),
        ),
        AudioSource.uri(
          song3,
          tag: AudioMetaData(
              title: 'Deep House 3',
              artist: 'AHABABA',
              imageAddress: '$prefix/deep3.jpeg'),
        ),
        AudioSource.uri(
          song4,
          tag: AudioMetaData(
              title: 'Deep House 4',
              artist: 'Besso',
              imageAddress: '$prefix/deep4.jpeg'),
        ),
        AudioSource.uri(
          song5,
          tag: AudioMetaData(
              title: 'Music 5',
              artist: 'Irea',
              imageAddress: '$prefix/deep5.jpeg'),
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
      } else if (progressingState == ProcessingState.completed) {
      _audioPlayer.stop();
      } else {
        buttonNotifier.value = ButtonState.playing;
      }
    });
  }

  void _listenSequenceState() {
    _audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) {
        return;
      }

      // update current song detail
      final currentItem = sequenceState.currentSource;
      final song = currentItem!.tag as AudioMetaData;
      currentSongDetailNotifier.value = song;

      //Play List
      final playList = sequenceState.effectiveSequence;
      final title = playList.map((song) {
        return song.tag as AudioMetaData;
        // return titleSong.title;
      }).toList();
      playListNotifier.value = title;

      // update next and back button
      if (playList.isEmpty || currentItem == null) {
        isFirstSongNotifier.value = true;
        isLastSongNotifier.value = true;
      } //
      else {
        isFirstSongNotifier.value = playList.first == currentItem;
        isLastSongNotifier.value = playList.last == currentItem;
      }
    });
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(position) {
    _audioPlayer.seek(position);
  }

  void onBackPressed() {
    _audioPlayer.seekToPrevious();
  }

  void onNextPressed() {
    _audioPlayer.seekToNext();
  }

  void onRepeatPressed() {
    repeatStateNotifier.nextState();
    if (repeatStateNotifier.value == RepeatState.off) {
      _audioPlayer.setLoopMode(LoopMode.off);
    } //
    else if (repeatStateNotifier.value == RepeatState.one) {
      _audioPlayer.setLoopMode(LoopMode.one);
    } //
    else {
      _audioPlayer.setLoopMode(LoopMode.all);
    }
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

class RepeatStateNotifier extends ValueNotifier<RepeatState> {
  RepeatStateNotifier() : super(_initialValue);

  static const _initialValue = RepeatState.off;

  void nextState() {
    var next = (value.index + 1) % RepeatState.values.length;
    value = RepeatState.values[next];
  }
}
