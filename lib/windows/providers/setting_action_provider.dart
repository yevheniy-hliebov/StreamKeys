import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/action.dart';

class SettingActionProvider with ChangeNotifier {
  final ButtonAction action;

  late TextEditingController nameController;
  late TextEditingController filePathController;

  SettingActionProvider({required this.action}) {
    nameController = TextEditingController(text: action.name);
    filePathController = TextEditingController(text: action.filePath);
  }

  Future<void> pickImage() async {
    await action.pickImage();
    notifyListeners();
  }

  Future<void> pickFile() async {
    await action.pickFile();
    filePathController.text = action.filePath;
    notifyListeners();
  }

  Future<void> clearAction() async {
    await action.clear();
    nameController.text = '';
    filePathController.text = '';
    notifyListeners();
  }

  Future<void> updateAction() async {
    action.name = nameController.text;
    await action.update();
  }
}
