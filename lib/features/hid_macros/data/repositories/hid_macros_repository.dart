import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/hid_macros/data/models/keyboard_device.dart';
import 'package:streamkeys/features/hid_macros/data/repositories/hid_macros_xml_manager.dart';
import 'package:streamkeys/features/hid_macros/data/repositories/keyboard_preferences.dart';
import 'package:streamkeys/features/keyboards_deck/models/keyboard_type.dart';

class HidMacrosRepository {
  final _prefs = KeyboardPreferences();
  final _xml = HidMacrosXmlManager();

  FutureVoid read() => _xml.load();

  Future<List<KeyboardDevice>> getDeviceList() async {
    await read();
    return _xml.getDevices();
  }

  FutureVoid updateKeyboardName(String systemId, String newName) async {
    await read();
    _xml.updateKeyboardName(systemId, newName);
    await _xml.save();
  }

  FutureVoid selectKeyboard(KeyboardDevice keyboard) async {
    await read();
    _xml.assignDeviceToMacros(keyboard.name);
    await _prefs.saveSelectedKeyboard(keyboard);
    await _xml.save();
  }

  FutureVoid selectKeyboardType(
      KeyboardDevice keyboard, KeyboardType type) async {
    await _prefs.saveKeyboardType(type);
    await read();
    await _xml.regenerateMacros(keyboard, type);
    await _xml.save();
  }

  Future<KeyboardDevice?> getSelectedKeyboard() => _prefs.getSelectedKeyboard();
  Future<KeyboardType?> getSelectedKeyboardType() => _prefs.getKeyboardType();
}
