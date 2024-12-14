// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:streamkeys/windows/models/base_action.dart';
import 'package:streamkeys/windows/models/keyboard/keyboard_action_button_info.dart';
import 'package:streamkeys/windows/models/keyboard/keyboard_key.dart';
import 'package:streamkeys/windows/models/keyboard/keyboard_map.dart';
import 'package:streamkeys/windows/models/keyboard/page_keyboard_data.dart';
import 'package:streamkeys/windows/services/keyboard_deck_service.dart';

class KeyboardDeckProvider extends ChangeNotifier {
  final String currentPage;
  late PageKeyboardData pageKeyboardData;

  KeyboardMap? keyboardMap;
  final KeyboardDeckService _service = KeyboardDeckService();

  Json? selectedKey;

  KeyboardDeckProvider(this.currentPage) {
    init();
  }

  FutureVoid init() async {
    await _service.init();
    await getKeyboardMap();
    await getData();

    notifyListeners();
  }

  FutureVoid getData() async {
    final data = _service.jsonData;

    pageKeyboardData = PageKeyboardData.fromJson(
      currentPage,
      keyboardActionsJson: data['map_pages'][currentPage] ?? {},
    );

    notifyListeners();
  }

  List<KeyboardKey> get functionRow {
    return keyboardMap != null ? keyboardMap!.functionRow : [];
  }

  List<List<KeyboardKey>> get mainBlock {
    return keyboardMap != null ? keyboardMap!.mainBlock : [];
  }

  List<List<KeyboardKey>> get navigationBlock {
    return keyboardMap != null ? keyboardMap!.navigationBlock : [];
  }

  List<List<KeyboardKey>> get numpad {
    return keyboardMap != null ? keyboardMap!.numpad : [];
  }

  FutureVoid getKeyboardMap() async {
    try {
      final mapData = await _service.getKeyboardMap();
      if (mapData != null) {
        keyboardMap = KeyboardMap.fromJson(mapData);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load keyboard keys: $e');
      }
    }
  }

  void selectKey({
    required String area,
    int? row,
    required int index,
    required int keyCode,
  }) {
    selectedKey = {
      'area': area,
      'row': row,
      'index': index,
      'keyCode': keyCode,
    };
    notifyListeners();
  }

  bool isSelected({
    required String area,
    int? row,
    required int index,
  }) {
    if (selectedKey == null) {
      return false;
    }
    if (selectedKey!['area'] == area &&
        selectedKey!['row'] == row &&
        selectedKey!['index'] == index) {
      return true;
    }
    return false;
  }

  KeyboardActionButtonInfo? get selectedButtonInfo {
    if (selectedKey == null) {
      return null;
    }
    final foundButtonInfo = getActionInfo(selectedKey!['keyCode']);
    if (foundButtonInfo == null) {
      return KeyboardActionButtonInfo(keyCode: selectedKey!['keyCode']);
    } else {
      return foundButtonInfo;
    }
  }

  KeyboardActionButtonInfo? getActionInfo(int keyCode) {
    KeyboardActionButtonInfo? buttonInfo =
        pageKeyboardData.keyboardActions[keyCode.toString()];
    return buttonInfo;
  }

  FutureVoid setAction(
    BaseAction action, {
    required int keyCode,
  }) async {
    final buttonInfo = KeyboardActionButtonInfo(
      keyCode: keyCode,
      action: action.copy(),
    );

    pageKeyboardData.keyboardActions[keyCode.toString()] = buttonInfo;

    await _savePageData();
    notifyListeners();
  }

  void updateSelectedButtonInfo(KeyboardActionButtonInfo buttonInfo) async {
    pageKeyboardData.keyboardActions[buttonInfo.keyCode.toString()] =
        buttonInfo;
    notifyListeners();
  }

  FutureVoid _savePageData() async {
    await _service.getData();
    _service.jsonData['map_pages'][currentPage] =
        pageKeyboardData.toJson()['keys'];
    await _service.saveData();
  }
}
