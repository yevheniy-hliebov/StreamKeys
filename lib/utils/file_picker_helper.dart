import 'package:file_picker/file_picker.dart';

class FilePickerHelper {
  const FilePickerHelper._();

  static Future<String?> pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      PlatformFile file = result.files.first;
      return file.path;
    }
    return null;
  }

  static Future<String?> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      PlatformFile file = result.files.first;
      return file.path;
    }
    return null;
  }
}