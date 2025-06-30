import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_xml_service.dart';
import 'package:streamkeys/desktop/utils/helper_functions.dart';
import 'package:streamkeys/desktop/utils/process_runner.dart';

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
      return result.stdout
          .toString()
          .toLowerCase()
          .contains(exeFileName.toLowerCase());
    } catch (e) {
      _log('Error checking process: $e');
      return false;
    }
  }

  Future<void> startAndEnsureConfig() async {
    await start();

    if (!HidMacrosXmlService().isConfigExists) {
      _log('Config file not found after start, restarting HIDMacros...');
      await restart();
    }
  }

  Future<void> start() async {
    final nircmdPath = '$assetsPath\\hidmacros\\nircmd.exe';

    if (!await File(nircmdPath).exists()) {
      _log('nircmd.exe not found: $nircmdPath');
      return;
    }

    try {
      final process = await _processRunner.start(
        nircmdPath,
        ['elevate', exePath],
        mode: ProcessStartMode.detached,
      );
      _log('HIDMacros started with PID: ${process.pid}');
    } catch (e) {
      _log('Failed to start HIDMacros: $e');
    }
  }

  Future<void> stop() async {
    final nircmdPath = '$assetsPath\\hidmacros\\nircmd.exe';

    if (!await File(nircmdPath).exists()) {
      _log('nircmd.exe not found: $nircmdPath');
      return;
    }

    try {
      final result = await _processRunner.run(
        nircmdPath,
        ['elevatecmd', 'closeprocess', exeFileName],
      );

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
    Duration waitDuration = const Duration(seconds: 5),
  }) async {
    await stop();
    _log('HIDMacros stopped. Restarting...');
    await Future.delayed(waitDuration);
    await start();
  }

  void _log(String message) {
    if (kDebugMode) {
      print('HIDMacrosService: $message');
    }
  }
}
