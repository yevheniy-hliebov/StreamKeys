import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> _playSound(String assetPath) async {
    await _player.play(
      AssetSource(assetPath),
      mode: PlayerMode.lowLatency,
    );
  }

  Future<void> playTick() => _playSound('sounds/tick.mp3');

  Future<void> playShutter() => _playSound('sounds/shutter.mp3');
}
