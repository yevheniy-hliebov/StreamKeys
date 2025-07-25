import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:streamkeys/core/constants/spacing.dart';

class HelperFunctions {
  HelperFunctions._();

  static String getAssetsFolderPath() {
    if (!kDebugMode) {
      final exeDir = File(Platform.resolvedExecutable).parent;
      return '${exeDir.path}\\data\\flutter_assets\\assets';
    } else {
      return '${Directory.current.path}\\assets';
    }
  }

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

  static Future<String?> pickFile({FileType type = FileType.any}) async {
    final result = await FilePicker.platform.pickFiles(type: type);

    if (result != null) {
      final file = result.files.first;
      return file.path;
    }
    return null;
  }

  static Offset dragAnchorCenterStrategy(
    Draggable<Object> draggable,
    BuildContext context,
    Offset position,
  ) {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return Offset(size.width / 2, size.height / 2);
  }

  static Offset dragAnchorBottomLeftStrategy(
    Draggable<Object> draggable,
    BuildContext context,
    Offset position,
  ) {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return Offset(0 + Spacing.xs, size.height - Spacing.xs);
  }

  static Future<String> getLocalIPv4() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 &&
            !addr.isLoopback &&
            !addr.address.startsWith('192.168.56.')) {
          return addr.address;
        }
      }
    }
    return '127.0.0.1';
  }
}
