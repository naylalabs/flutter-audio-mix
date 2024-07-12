import 'package:audio_service/audio_service.dart';
import 'package:flutter_audio_mix/models/mix_audio_player.dart';
import 'package:just_audio/just_audio.dart';

/// An [AudioHandler] for playing a single item.
class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();
  final List<MixAudioPlayer> _playerList = [];

  /// Initialise our audio handler.
  AudioPlayerHandler() {
    _init();
  }

  //TODO WILL CHANGE FOR ADD FOREGROUND NOTIFICATION
  Future<void> _init() async {}

  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) async {
    switch (name) {
      case 'mixMusic':
        // try {
        final player = MixAudioPlayer(extras!["id"]);
        await player.setUrl(extras["url"]);
        _playerList.add(player);
        player.play();
        // } catch (e) {
        //   debugPrint("Error on mix music: $e");
        //   // onStop();
        // }
        break;
      case 'pause':
        // try {
        var id = extras!["id"];
        for (int i = 0; i < _playerList.length; i++) {
          if (_playerList[i].id == id) {
            _playerList[i].dispose();
            _playerList.removeAt(i);
          }
        }
        // } catch (e) {
        //   debugPrint("Player custom action pause Error: $e");
        // }
        break;

      case 'pauseAll':
        // try {
        pause();
        // } catch (e) {
        //   debugPrint("Player custom action pause Error: $e");
        // }
        break;
    }
    return super.customAction(name, extras);
  }

  @override
  Future<void> play() async {
    for (var element in _playerList) {
      await element.play();
    }
  }

  @override
  Future<void> pause() async {
    for (var element in _playerList) {
      await element.pause();
    }
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
