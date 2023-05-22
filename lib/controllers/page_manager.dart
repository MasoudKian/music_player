import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/services/play_list_repository.dart';
import 'package:music_player/services/service_locator.dart';

class PageManager {
  //final AudioPlayer _audioPlayer;

  final _audioHandler = getIt<AudioHandler>();

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

  final playListNotifier = ValueNotifier<List<MediaItem>>([]);
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final repeatStateNotifier = RepeatStateNotifier();

  // volume
  final volumeStateNotifier = ValueNotifier<double>(1);

  late ConcatenatingAudioSource _playlist;

  PageManager() {
    _init();
  }

  void _init() async {
    _loadPlayList();
    _listenChangeInPlayList();
    // _setInitialPlayerList();
    // _listenChangePlayerState();
    // _listenChangePositionStream();
    // _listenChangeBufferedPositionStream();
    // _listenChangeTotalDurationStream();
    // _listenSequenceState();
  }

  Future _loadPlayList() async {
    final songRepository = getIt<PlayListRepository>();
    final playList = await songRepository.fetchMyPlayList();

    final mediaItems = playList.map(
          (song) => MediaItem(
        id: song['id'] ?? '-1',
        title: song['title'] ?? '',
        artist: song['artist'],
        artUri: Uri.parse(song['artUri'] ?? ''),
        extras: {'url': song['url']},
      ),
    ).toList();
    _audioHandler.addQueueItems(mediaItems);
  }

  _listenChangeInPlayList(){
    _audioHandler.queue.listen((playlist) {
      if(playlist.isEmpty){
        return;
      }//
      else{
        final newList = playlist.map((item) => item).toList();
        playListNotifier.value = newList;
      }
    });
  }


//   void _setInitialPlayerList() async {
//
//
// //Image & Music
//
//     // const prefix = 'assets/images';
//     //
//     // final song1 = Uri.parse(
//     //     'https://dl.mokhtalefmusic.com/music/1398/02/26/Deep%20House/Jay%20Aliev%20Deep.mp3');
//     // final song2 = Uri.parse(
//     //     'https://avapedia.com/station/24054/masih-to-ke-nisti-pisham-ft-arash-ap/d?nonce=05c8a58693');
//     // final song3 = Uri.parse(
//     //     'https://avapedia.com/station/2497/shah-beyt/d?nonce=05c8a58693');
//     // final song4 = Uri.parse(
//     //     'https://avapedia.com/station/24044/khabe-khoob/d?nonce=05c8a58693');
//     // final song5 = Uri.parse(
//     //     'https://avapedia.com/station/24052/aroome-del/d?nonce=05c8a58693');
//
//     //Playe List
//     // _playlist = ConcatenatingAudioSource(
//     //   children: [
//     //     AudioSource.uri(
//     //       song1,
//     //       tag: AudioMetaData(
//     //           title: 'Deep House 1',
//     //           artist: 'Ethnic',
//     //           imageAddress: '$prefix/deep1.jpg'),
//     //     ),
//     //     AudioSource.uri(
//     //       song2,
//     //       tag: AudioMetaData(
//     //           title: 'Deep House 1',
//     //           artist: 'Love',
//     //           imageAddress: '$prefix/deep2.jpeg'),
//     //     ),
//     //     AudioSource.uri(
//     //       song3,
//     //       tag: AudioMetaData(
//     //           title: 'Deep House 3',
//     //           artist: 'AHABABA',
//     //           imageAddress: '$prefix/deep3.jpeg'),
//     //     ),
//     //     AudioSource.uri(
//     //       song4,
//     //       tag: AudioMetaData(
//     //           title: 'Deep House 4',
//     //           artist: 'Besso',
//     //           imageAddress: '$prefix/deep4.jpeg'),
//     //     ),
//     //     AudioSource.uri(
//     //       song5,
//     //       tag: AudioMetaData(
//     //           title: 'Music 5',
//     //           artist: 'Irea',
//     //           imageAddress: '$prefix/deep5.jpeg'),
//     //     ),
//     //   ],
//     // );
//
//     if (_audioPlayer.bufferedPosition == Duration.zero) {
//       await _audioPlayer.setAudioSource(_playlist);
//     } //
//   }
//
//   void _listenChangePlayerState() {
//     _audioPlayer.playerStateStream.listen((playerState) {
//       final playing = playerState.playing;
//       final processingState = playerState.processingState;
//       if (processingState == ProcessingState.loading ||
//           processingState == ProcessingState.buffering) {
//         buttonNotifier.value = ButtonState.loading;
//       } //
//       else if (!playing) {
//         buttonNotifier.value = ButtonState.paused;
//       } else if (processingState != ProcessingState.completed) {
//         buttonNotifier.value = ButtonState.playing;
//       } //
//       else {
//         _audioPlayer.stop();
//       }
//     });
//   }
//
//   void _listenChangePositionStream() {
//     _audioPlayer.positionStream.listen((position) {
//       final oldState = progressNotifier.value;
//       progressNotifier.value = ProgressBarState(
//         current: position,
//         buffered: oldState.buffered,
//         total: oldState.total,
//       );
//     });
//   }
//
//   void _listenChangeBufferedPositionStream() {
//     _audioPlayer.bufferedPositionStream.listen((position) {
//       final oldState = progressNotifier.value;
//       progressNotifier.value = ProgressBarState(
//         current: oldState.current,
//         buffered: position,
//         total: oldState.total,
//       );
//     });
//   }
//
//   void _listenChangeTotalDurationStream() {
//     _audioPlayer.durationStream.listen((position) {
//       final oldState = progressNotifier.value;
//       progressNotifier.value = ProgressBarState(
//         current: oldState.current,
//         buffered: oldState.buffered,
//         total: position ?? Duration.zero,
//       );
//     });
//   }
//
//   void _listenSequenceState() {
//     // Handle Icon Play & Pause & Progress
//     _audioPlayer.playerStateStream.listen((playerState) {
//       final playing = playerState.playing;
//       final progressingState = playerState.processingState;
//
//       if (progressingState == ProcessingState.loading ||
//           progressingState == ProcessingState.buffering) {
//         buttonNotifier.value = ButtonState.loading;
//       } else if (!playing) {
//         buttonNotifier.value = ButtonState.paused;
//       } else if (progressingState == ProcessingState.completed) {
//         _audioPlayer.stop();
//       } else {
//         buttonNotifier.value = ButtonState.playing;
//       }
//     });
//     _audioPlayer.sequenceStateStream.listen((sequenceState) {
//       if (sequenceState == null) {
//         return;
//       }
//
//       // update current song detail
//       final currentItem = sequenceState.currentSource;
//       final song = currentItem!.tag as AudioMetaData;
//       currentSongDetailNotifier.value = song;
//
//       //Play List
//       final playList = sequenceState.effectiveSequence;
//       final title = playList.map((song) {
//         return song.tag as AudioMetaData;
//         // return titleSong.title;
//       }).toList();
//       playListNotifier.value = title;
//
//       // update next and back button
//       if (playList.isEmpty || currentItem == null) {
//         isFirstSongNotifier.value = true;
//         isLastSongNotifier.value = true;
//       } //
//       else {
//         isFirstSongNotifier.value = playList.first == currentItem;
//         isLastSongNotifier.value = playList.last == currentItem;
//       }
//
//       //update volume button
//       if (_audioPlayer.volume != 0) {
//         volumeStateNotifier.value = 1;
//       } //
//       else {
//         volumeStateNotifier.value = 0;
//       }
//     });
//   }

  void onVolumePressed() {
    if (volumeStateNotifier.value != 0) {
      _audioPlayer.setVolume(0);
      volumeStateNotifier.value = 0;
    } //
    else {
      _audioPlayer.setVolume(1);
      volumeStateNotifier.value = 1;
    }
  }

  void play() {
    _audioHandler.play();
  }

  void pause() {
    _audioHandler.pause();
  }

  void seek(position) {
    _audioPlayer.seek(position);
  }

  void playFromPlayList(int index) {
    _audioPlayer.seek(Duration.zero, index: index);
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
