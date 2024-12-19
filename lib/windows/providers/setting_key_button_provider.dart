import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/touch/action_touch_button_info.dart';
import 'package:streamkeys/windows/models/keyboard/keyboard_action_button_info.dart';
import 'package:streamkeys/windows/models/typedefs.dart';
import 'package:streamkeys/windows/services/keyboard_deck_service.dart';

class SettingButtonProvider extends ChangeNotifier {
  ActionButtonInfo buttonInfo;
  final String deckType;

  bool _mounted = true;
  bool get mounted => _mounted;

  late TextEditingController nameController;
  final KeyboardDeckService _service = KeyboardDeckService();

  SettingButtonProvider(this.buttonInfo, this.deckType) {
    nameController = TextEditingController(text: buttonInfo.name);
    nameController.addListener(() {
      buttonInfo.name = nameController.text;
    });
    _service.init();
  }

  void updateButtonInfo() async {
    if (deckType == 'keyboard') {
      String currentPage = _service.jsonData['current_page'];
      final keyCode = (buttonInfo as KeyboardActionButtonInfo).keyCode;
      _service.jsonData['map_pages'][currentPage][keyCode.toString()] =
          buttonInfo.toJson();
      await _service.saveData();
    }
    if (mounted) {
      notifyListeners();
    }
  }

  FutureVoid pickImage() async {
    await buttonInfo.pickImage();
    notifyListeners();
  }

  void changeColor(Color selectedColor) {
    buttonInfo.backgroundColor = selectedColor;
    notifyListeners();
  }

  void clear() {
    buttonInfo.clear();
    nameController.clear();
    notifyListeners();
  }

  void delete() {
    buttonInfo.delete();
    nameController.clear();
    updateButtonInfo();
    notifyListeners();
  }

  void clearAction(int index) {
    buttonInfo.actions[index].clear();
    notifyListeners();
  }

  void deleteAction(int index) {
    buttonInfo.actions.removeAt(index);
    updateButtonInfo();
    notifyListeners();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
