import 'dart:io';
import 'package:streamkeys/desktop/utils/logger.dart';

class Nircmd {
  final Logger logger;
  final String assetsPath;

  const Nircmd({required this.logger, required this.assetsPath});

  File? getFile() {
    final path = '$assetsPath\\hidmacros\\nircmd.exe';
    final file = File(path);
    if (!file.existsSync()) {
      logger(service: 'Nircmd', msg: 'nircmd.exe not found: $path');
      return null;
    }
    return file;
  }
}
