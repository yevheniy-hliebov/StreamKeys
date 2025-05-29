import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/utils/helper_functions.dart';

class JsonHelper {
  final String filePath;
  final bool isAsset;

  JsonHelper.asset(this.filePath) : isAsset = true;
  JsonHelper.storage(this.filePath) : isAsset = false;

  Future<Json?> read() async {
    try {
      if (isAsset) {
        final path = 'lib/windows/assets/$filePath';
        final content = await rootBundle.loadString(path);
        return jsonDecode(content);
      } else {
        final storagePath = await HelperFunctions.getStoragePath();
        final file = File('$storagePath/$filePath');
        final content = await file.readAsString();
        return jsonDecode(content);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error reading ${isAsset ? "asset" : "file"}: $e');
      }
      return null;
    }
  }

  FutureVoid save(Json content) async {
    if (isAsset) {
      throw UnsupportedError('Cannot save to asset file.');
    }

    final storagePath = await HelperFunctions.getStoragePath();
    final file = File('$storagePath/$filePath');

    final formattedContent =
        const JsonEncoder.withIndent('  ').convert(content);

    await file.writeAsString(
      formattedContent,
      mode: FileMode.write,
      flush: true,
      encoding: utf8,
    );
  }
}
