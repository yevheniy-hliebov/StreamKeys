import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class HelperFunctions {
  HelperFunctions._();

  static Future<String> getStoragePath() async {
    if (Platform.isWindows) {
      final Directory directory = Directory(
        '${Platform.environment['APPDATA']}\\StreamKeys',
      );

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      if (kDebugMode) {
        print('Windows storage path: ${directory.path}');
      }

      return directory.path;
    } else {
      final Directory directory = await getApplicationDocumentsDirectory();

      if (kDebugMode) {
        print('Non-Windows storage path: ${directory.path}');
      }

      return directory.path;
    }
  }
}
