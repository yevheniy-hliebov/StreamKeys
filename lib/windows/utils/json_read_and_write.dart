import 'dart:io';

import 'package:path_provider/path_provider.dart';

class JsonReadAndWrite {
  final String fileName;

  const JsonReadAndWrite({
    required this.fileName,
  });

  Future<String> get _localJsonPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
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
