import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:streamkeys/desktop/utils/process_runner.dart';

class LaunchFileOrAppService {
  final ProcessRunner _processRunner;

  LaunchFileOrAppService(this._processRunner);

  Future<void> launch(
    String filePath, {
    bool asAdmin = false,
    List<String> arguments = const [],
  }) async {
    final file = File(filePath);

    if (!file.existsSync()) {
      throw Exception('Файл не знайдено: $filePath');
    }

    final workingDir = file.parent.path;
    final fileName = path.basename(filePath);
    final ext = path.extension(filePath).toLowerCase();

    try {
      switch (ext) {
        case '.vbs':
          await _runVbs(fileName, workingDir);
          break;
        case '.bat':
          await _runBat(fileName, workingDir, arguments, asAdmin);
          break;
        default:
          await _runExecutable(filePath, workingDir, asAdmin);
          break;
      }
    } catch (e) {
      _log(e.toString());
      rethrow;
    }
  }

  Future<void> _runVbs(String fileName, String dir) async {
    final command = 'Set-Location -Path "$dir"; wscript "$fileName"';
    await _runPowerShell(command);
  }

  Future<void> _runBat(
    String fileName,
    String dir,
    List<String> args,
    bool asAdmin,
  ) async {
    final joinedArgs = args.map((e) => '"$e"').join(' ');
    final command = 'Set-Location -Path "$dir"; .\\$fileName $joinedArgs';

    if (asAdmin) {
      final adminCommand =
          '''
Start-Process powershell -ArgumentList '-NoProfile -Command "$command"' -Verb RunAs
''';
      await _runPowerShell(adminCommand);
    } else {
      await _runPowerShell(command);
    }
  }

  Future<void> _runExecutable(String filePath, String dir, bool asAdmin) async {
    final args = [
      'Start-Process',
      '-FilePath',
      '"$filePath"',
      '-WorkingDirectory',
      '"$dir"',
      if (asAdmin) ...['-Verb', 'RunAs'],
    ];

    await _processRunner.start('powershell', args, runInShell: true);
  }

  Future<void> _runPowerShell(String command) async {
    await _processRunner.start('powershell', [
      '-Command',
      command,
    ], runInShell: true);
  }

  void _log(String message) {
    if (kDebugMode) {
      print('LaunchFileOrAppService: $message');
    }
  }
}
