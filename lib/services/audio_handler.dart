import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.music_player',
      androidNotificationChannelName: 'My Music player',
      androidStopForegroundOnPause: true,
      androidNotificationOngoing: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  final _audioPlayer = AudioPlayer();
  final _playList = ConcatenatingAudioSource(children: []);

  MyAudioHandler() {
    _loadEmptyList();
  }

  _loadEmptyList() async {
    await _audioPlayer.setAudioSource(_playList);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final audioSource = mediaItems.map((mediaItem) =>
        AudioSource.uri(
          Uri.parse(mediaItem.extras!['url']), tag: mediaItem,
        )).toList();
    _playList.addAll(audioSource);

    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> play() async{
    _audioPlayer.play();
  }

  @override
  Future<void> pause() async{
    _audioPlayer.pause();
  }
}
