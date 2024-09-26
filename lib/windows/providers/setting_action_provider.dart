import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/action.dart';
import 'package:streamkeys/windows/services/button_action_service.dart';

class SettingActionProvider with ChangeNotifier {
  final ButtonAction action;
  final ButtonActionService _buttonActionService = ButtonActionService();

  String imagePath = '';
  late TextEditingController nameController;
  late TextEditingController filePathController;

  SettingActionProvider({required this.action}) {
    imagePath = action.imagePath;
    nameController = TextEditingController(text: action.name);
    filePathController = TextEditingController(text: action.filePath);
  }

  Future<void> pickImage() async {
    await _buttonActionService.pickImage(action);
    imagePath = action.imagePath;
    notifyListeners();
  }

  Future<void> pickFile() async {
    await _buttonActionService.pickFile(action);
    filePathController.text = action.filePath;
    notifyListeners();
  }

  Future<void> clearAction() async {
    await _buttonActionService.clearAction(action);
    imagePath = '';
    nameController.text = '';
    filePathController.text = '';
    notifyListeners();
  }

  Future<void> updateAction() async {
    await _buttonActionService.updateAction(
      action,
      nameController.text,
      imagePath,
      filePathController.text,
    );
  }
}
