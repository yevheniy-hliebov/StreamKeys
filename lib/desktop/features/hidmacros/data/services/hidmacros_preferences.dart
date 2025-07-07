import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';

class KeyboardPreferences {
  final SharedPreferences prefs;

  const KeyboardPreferences(this.prefs);

  static const _systemIdKey = 'system_id';
  static const _keyboardNameKey = 'keyboard_name';
  static const _keyboardTypeKey = 'keyboard_type';

  Future<void> saveSelectedKeyboard(KeyboardDevice keyboard) async {
    await prefs.setString(_systemIdKey, Uri.encodeComponent(keyboard.systemId));
    await prefs.setString(_keyboardNameKey, keyboard.name);
  }

  KeyboardDevice? getSelectedKeyboard()  {
    final encodedId = prefs.getString(_systemIdKey) ?? '';
    final name = prefs.getString(_keyboardNameKey) ?? '';
    if (encodedId.isEmpty || name.isEmpty) return null;

    final id = Uri.decodeComponent(encodedId);
    return KeyboardDevice(name, id);
  }

  Future<void> saveKeyboardType(KeyboardType type) async {
    await prefs.setString(_keyboardTypeKey, type.name);
  }

  KeyboardType? getKeyboardType() {
    final type = prefs.getString(_keyboardTypeKey);

    for (var keyboardType in KeyboardType.values) {
      if (keyboardType.name == type) {
        return keyboardType;
      }
    }

    return null;
  }
}