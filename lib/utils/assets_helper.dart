import 'dart:io';

import 'package:flutter/foundation.dart';

class AssetsHelper {
  static String get assetsFolderPath {
    if (!kDebugMode) {
      final exeDir = File(Platform.resolvedExecutable).parent;
      return '${exeDir.path}\\data\\flutter_assets\\lib\\assets';
    } else {
      return '${Directory.current.path}\\lib\\assets';
    }
  }
}
