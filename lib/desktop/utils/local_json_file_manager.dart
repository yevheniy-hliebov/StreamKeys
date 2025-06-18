import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:streamkeys/desktop/utils/helper_function.dart';

class LocalJsonFileManager {
  final String filePath;
  final bool isAsset;

  LocalJsonFileManager.asset(this.filePath) : isAsset = true;
  LocalJsonFileManager.storage(this.filePath) : isAsset = false;

  Future<Map<String, dynamic>?> read() async {
    try {
      if (isAsset) {
        final String path = 'assets/$filePath';
        final String content = await rootBundle.loadString(path);
        return jsonDecode(content);
      } else {
        final String storagePath = await HelperFunctions.getStoragePath();
        final File file = File('$storagePath/$filePath');
        final String content = await file.readAsString();
        return jsonDecode(content);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error reading ${isAsset ? "asset" : "file"}: $e');
      }
      return null;
    }
  }

  Future<void> save(Map<String, dynamic> json) async {
    if (isAsset) {
      throw UnsupportedError('Cannot save to asset file.');
    }

    final String storagePath = await HelperFunctions.getStoragePath();
    final File file = File('$storagePath/$filePath');

    final String formattedContent =
        const JsonEncoder.withIndent('  ').convert(json);

    await file.writeAsString(
      formattedContent,
      mode: FileMode.write,
      flush: true,
      encoding: utf8,
    );
  }
}
