import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _player;

  SoundService([AudioPlayer? player]) : _player = player ?? AudioPlayer();

  Future<void> _playSound(String assetPath) async {
    await _player.play(AssetSource(assetPath), mode: PlayerMode.lowLatency);
  }

  Future<void> playTick() => _playSound('sounds/tick.mp3');

  Future<void> countdownTick(
    Duration delay, {
    required bool playSound,
    void Function(int secondsLeft)? onTick,
  }) async {
    for (int i = delay.inSeconds; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      onTick?.call(i);
      if (playSound) await playTick();
    }
  }

  Future<void> playShutter() => _playSound('sounds/shutter.mp3');
}
