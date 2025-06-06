import 'dart:io';
import 'package:flutter/foundation.dart';

class FileExecutionHelper {
  const FileExecutionHelper._();

  static Future<void> runFile(String filePath) async {
    try {
      final cleanedPath = sanitizePath(filePath);

      final workingDir = File(cleanedPath).parent.path;

      final result = await Process.run(
        'cmd',
        ['/C', 'start', '', cleanedPath],
        runInShell: true,
        workingDirectory: workingDir,
      );

      if (result.exitCode == 0) {
        if (kDebugMode) {
          print('Script executed successfully: ${result.stdout}');
        }
      } else {
        throw Exception('${result.stderr}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static String sanitizePath(String input) {
    if (input.startsWith(r'\') &&
        RegExp(r'^[A-Z]:', caseSensitive: false).hasMatch(input.substring(1))) {
      return input.substring(1);
    }
    return input;
  }
}
