import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class JsonReadAndWrite {
  final String fileName;

  const JsonReadAndWrite({
    required this.fileName,
  });

  Future<String> get _localJsonPath async {
    if (Platform.isWindows) {
      final directory = Directory('${Platform.environment['APPDATA']}\\StreamKeys');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (kDebugMode) {
        print(directory.path);
      }
      return directory.path;
    } else {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }

  Future<File> get _localJson async {
    final path = await _localJsonPath;

    return File('$path/$fileName');
  }

  Future<File> save(String content) async {
    final file = await _localJson;

    return file.writeAsString(content);
  }

  Future<String> read() async {
    try {
      final file = await _localJson;

      final content = await file.readAsString();

      return content;
    } catch (e) {
      return '';
    }
  }
}
