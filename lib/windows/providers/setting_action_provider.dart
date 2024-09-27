import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/action.dart';

class SettingActionProvider with ChangeNotifier {
  bool isLockedApp = false;

  final ButtonAction action;

  late TextEditingController nameController;
  late TextEditingController filePathController;

  SettingActionProvider({required this.action}) {
    nameController = TextEditingController(text: action.name);
    filePathController = TextEditingController(text: action.filePath);
  }

  Future<void> _performAction(Future<void> Function() actionToPerform) async {
    isLockedApp = true;
    notifyListeners();

    await actionToPerform();

    isLockedApp = false;
    notifyListeners();
  }

  Future<void> pickImage() async {
    await _performAction(action.pickImage);
  }

  Future<void> pickFile() async {
    await _performAction(() async {
      await action.pickFile();
      filePathController.text = action.filePath;
    });
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
