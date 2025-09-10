import 'package:flutter/services.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/service_locator.dart';

abstract class IKeyboardService {
  Future<List<String>> getIds();

  Future<void> setSelectedKeyboard(KeyboardDevice keyboard);
  KeyboardDevice? getSelectedKeyboard();
  
  Future<void> setKeyboardType(KeyboardType type);
  KeyboardType? getKeyboardType();
}

class KeyboardService implements IKeyboardService {
  final SharedPreferences _prefs;

  KeyboardService(this._prefs);

  static const MethodChannel _channel = MethodChannel('streamkeys/keyboards');

  static const _selectedKeyboardIdKey = 'selected_keyboard_id';
  static const _selectedKeyboardNameKey = 'selected_keyboard_name';
  static const _keyboardTypeKey = 'keyboard_type';

  @override
  Future<List<String>> getIds() async {
    final List devices = await _channel.invokeMethod('getKeyboardDevices');
    return devices.map((d) => d.toString().trim()).toList();
  }

  @override
  Future<void> setSelectedKeyboard(KeyboardDevice keyboard) async {
    await _prefs.setString(_selectedKeyboardIdKey, keyboard.systemId);
    await _prefs.setString(_selectedKeyboardNameKey, keyboard.name);
  }

  @override
  KeyboardDevice? getSelectedKeyboard() {
    final id = _prefs.getString(_selectedKeyboardIdKey);
    final name = _prefs.getString(_selectedKeyboardNameKey);
    if (id == null || name == null) return null;
    return KeyboardDevice(name, id);
  }

  @override
  Future<void> setKeyboardType(KeyboardType type) async {
    await _prefs.setInt(_keyboardTypeKey, type.index);
  }

  @override
  KeyboardType? getKeyboardType() {
    final typeIndex = _prefs.getInt(_keyboardTypeKey);
    if (typeIndex == null) return null;
    return KeyboardType.values[typeIndex];
  }
}
