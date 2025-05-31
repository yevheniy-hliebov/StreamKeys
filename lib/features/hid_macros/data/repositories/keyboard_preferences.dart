import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/features/hid_macros/data/models/keyboard_device.dart';
import 'package:streamkeys/features/keyboards_deck/models/keyboard_type.dart';

class KeyboardPreferences {
  final _systemIdKey = 'system_id';
  final _keyboardNameKey = 'keyboard_name';
  final _keyboardTypeKey = 'keyboard_type';

  Future<void> saveSelectedKeyboard(KeyboardDevice keyboard) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_systemIdKey, keyboard.systemId);
    await prefs.setString(_keyboardNameKey, keyboard.name);
  }

  Future<KeyboardDevice?> getSelectedKeyboard() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_systemIdKey) ?? '';
    final name = prefs.getString(_keyboardNameKey) ?? '';
    return (id.isEmpty || name.isEmpty) ? null : KeyboardDevice(name, id);
  }

  Future<void> saveKeyboardType(KeyboardType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyboardTypeKey, type.name);
  }

  Future<KeyboardType?> getKeyboardType() async {
    final prefs = await SharedPreferences.getInstance();
    final type = prefs.getString(_keyboardTypeKey);

    for (var keyboardType in KeyboardType.values) {
      if (keyboardType.name == type) {
        return keyboardType;
      }
    }

    return null;
  }
}
