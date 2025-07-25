import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:streamkeys/desktop/utils/helper_functions.dart';
import 'package:streamkeys/desktop/utils/process_runner.dart';
import 'package:streamkeys/service_locator.dart';

class HidMacrosService {
  final ProcessRunner _processRunner;

  const HidMacrosService(this._processRunner);

  static const exeFileName = 'hidmacros.exe';
  static String assetsPath = HelperFunctions.getAssetsFolderPath();
  static final String exePath = '$assetsPath\\hidmacros\\$exeFileName';

  Future<bool> isRunning() async {
    try {
      final result = await _processRunner.run('tasklist', []);
      if (result.exitCode != 0) {
        _log('Error running tasklist: ${result.stderr}');
        return false;
      }
      return result.stdout.toString().toLowerCase().contains(
        exeFileName.toLowerCase(),
      );
    } catch (e) {
      _log('Error checking process: $e');
      return false;
    }
  }

  Future<void> startAndEnsureConfig() async {
    await start();

    if (!sl<HidMacrosXmlService>().isConfigExists) {
      _log('Config file not found after start, restarting HIDMacros...');
      await restart();
    }
  }

  Future<void> start() async {
    final nircmd = getNircmdFileOrNull();
    if (nircmd == null) return;

    try {
      final process = await _processRunner.start(nircmd.path, [
        'elevate',
        exePath,
      ], mode: ProcessStartMode.detached);
      _log('HIDMacros started with PID: ${process.pid}');
    } catch (e) {
      _log('Failed to start HIDMacros: $e');
    }
  }

  Future<void> stop() async {
    final nircmd = getNircmdFileOrNull();
    if (nircmd == null) return;

    try {
      final result = await _processRunner.run(nircmd.path, [
        'elevatecmd',
        'closeprocess',
        exeFileName,
      ]);

      if (result.exitCode == 0) {
        _log('Sent close window command to HIDMacros');
      } else {
        _log('Failed to send close command: ${result.stderr}');
      }
    } catch (e) {
      _log('Error stopping HIDMacros: $e');
    }
  }

  Future<void> restart({
    Duration waitDuration = const Duration(seconds: 3),
    Future<void> Function()? onBetween,
    bool autoStart = true,
  }) async {
    await stop();
    _log('HIDMacros stopped.${autoStart ? 'Restarting...' : ''}');

    await Future.delayed(waitDuration);

    if (onBetween != null) {
      await onBetween();
    }

    if (autoStart) {
      await start();
    }
  }

  File? getNircmdFileOrNull() {
    final path = '$assetsPath\\hidmacros\\nircmd.exe';
    final file = File(path);
    if (!file.existsSync()) {
      _log('nircmd.exe not found: $path');
      return null;
    }
    return file;
  }

  void _log(String message) {
    if (kDebugMode) {
      print('HIDMacrosService: $message');
    }
  }
}
