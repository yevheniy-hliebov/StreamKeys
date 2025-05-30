import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:streamkeys/common/models/typedefs.dart';

class HidMacrosRepository {
  late String exePath;

  HidMacrosRepository() {
    final assetsPath = getAssetPath('lib\\assets');
    exePath = '$assetsPath\\hid_macros\\HIDMacros.exe';
  }

  Future<bool> isRunning() async {
    try {
      final result = await Process.run('tasklist', []);
      if (result.exitCode != 0) {
        _log('Error executing tasklist: ${result.stderr}');
        return false;
      }
      return result.stdout.toString().toLowerCase().contains('hidmacros.exe');
    } catch (e) {
      _log('Process validation error: $e');
      return false;
    }
  }

  FutureVoid start() async {
    if (!await File(exePath).exists()) {
      _log('File not found: $exePath');
      return;
    }

    await _runAsAdmin(
      filePath: exePath,
      onSuccess: 'HIDMacros is running as administrator',
      onError: 'Startup error',
    );
  }

  FutureVoid stop() async {
    await _runAsAdmin(
      filePath: 'taskkill',
      args: ['/F', '/IM', 'HIDMacros.exe'],
      onSuccess: 'HIDMacros completed with administrator privileges',
      onError: 'Completion error',
    );
  }

  FutureVoid restart() async {
    await stop();
    await start();
  }

  FutureVoid _runAsAdmin({
    required String filePath,
    List<String> args = const [],
    required String onSuccess,
    required String onError,
  }) async {
    try {
      final result = await Process.run(
        'powershell.exe',
        [
          'Start-Process',
          '-Verb',
          'RunAs',
          '-FilePath',
          filePath,
          if (args.isNotEmpty) ...['-ArgumentList', args.join(',')],
        ],
        runInShell: true,
      );

      if (result.exitCode == 0) {
        _log(onSuccess);
      } else {
        _log('$onError: ${result.stderr}');
      }
    } catch (e) {
      _log('$onError: $e');
    }
  }

  void _log(String message) {
    if (kDebugMode) {
      print('HIDMacrosController: $message');
    }
  }

  String getAssetPath(String relativePath) {
    if (!kDebugMode) {
      final exeDir = File(Platform.resolvedExecutable).parent;
      return '${exeDir.path}\\data\\flutter_assets\\$relativePath';
    } else {
      return '${Directory.current.path}\\$relativePath';
    }
  }
}
