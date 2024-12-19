import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class JsonReadAndWrite {
  final String fileName;
  final bool isAsset;

  const JsonReadAndWrite({
    required this.fileName,
    this.isAsset = false,
  });

  Future<String> get _localJsonPath async {
    if (Platform.isWindows) {
      final directory =
          Directory('${Platform.environment['APPDATA']}\\StreamKeys');
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
    if (isAsset) {
      throw UnsupportedError('Cannot save content to an asset file.');
    }
    final file = await _localJson;

    // Форматований JSON
    String formattedContent = const JsonEncoder.withIndent('  ').convert(
      jsonDecode(content),
    );

    // Зберігаємо форматований JSON
    return file.writeAsString(formattedContent,
        mode: FileMode.write, flush: true, encoding: utf8);
  }

  Future<String> read() async {
    try {
      if (isAsset) {
        final content =
            await rootBundle.loadString('lib/windows/assets/$fileName');
        return content;
      } else {
        final file = await _localJson;
        return await file.readAsString();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error reading file: $e');
      }
      return '';
    }
  }
}
