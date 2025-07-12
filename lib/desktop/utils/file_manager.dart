import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class FileManager {
  const FileManager();

  Future<String?> pickFile({FileType type = FileType.any}) async {
    final result = await FilePicker.platform.pickFiles(type: type);

    if (result != null) {
      final file = result.files.first;
      return file.path;
    }
    return null;
  }

  Future<String?> pickDirectory() async {
    final result = await FilePicker.platform.getDirectoryPath();
    return result;
  }

  Uint8List decodeBase64Image(String imageData) {
    final base64Str = imageData.split(',').last;
    return base64Decode(base64Str);
  }

  Future<String> saveScreenshot({
    String recordingPath = 'C:/Screenshots',
    required Uint8List bytes,
    required String fileNamePart,
  }) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH-mm-ss').format(now);
    final fileName = 'Screenshot [$fileNamePart] $formattedDate.jpg';

    final dir = Directory(recordingPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final filePath = '${dir.path}/$fileName';

    await File(filePath).writeAsBytes(bytes);
    return filePath;
  }
}
