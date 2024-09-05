import 'dart:io';
import 'package:flutter/foundation.dart';

class FileExecutionService {
  const FileExecutionService._();
  
  static Future<void> runFile(String filePath) async {
    try {
      final file = File(filePath);
      final workingDirectory = file.parent.path;
      final result = await Process.run(filePath, [],
          runInShell: true, workingDirectory: workingDirectory);

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
}
