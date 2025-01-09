import 'package:audioplayers/audioplayers.dart';

class AudioPlayerController {
  AudioPlayer? _player;

  AudioPlayerController() {
    _player = AudioPlayer();
    _player!.audioCache = AudioCache(prefix: 'asset/');
  }

  void playBeep() {
    _player?.play(AssetSource('sound/beep.mp3'));
  }
}
