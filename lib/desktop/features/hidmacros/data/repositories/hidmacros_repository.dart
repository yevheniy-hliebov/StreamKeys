import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_preferences.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_xml_service.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/service_locator.dart';

class HidMacrosRepository {
  final _prefs = KeyboardPreferences();
  final _xml = HidMacrosXmlService();
  final hidmacros = sl<HidMacrosService>();

  Future<List<KeyboardDevice>> getDeviceList() async {
    await _xml.read();
    return _xml.getDevices();
  }

  Future<void> selectKeyboard(KeyboardDevice keyboard) async {
    await _xml.read();
    _xml.assignDeviceToMacros(keyboard.name);
    await _prefs.saveSelectedKeyboard(keyboard);

    await hidmacros.stop();
    await Future.delayed(const Duration(seconds: 3));
    await _xml.save();
    await hidmacros.start();
  }

  Future<void> selectKeyboardType({
    required KeyboardDevice keyboard,
    required KeyboardType type,
  }) async {
    await _prefs.saveKeyboardType(type);
    await _xml.read();
    await _xml.regenerateMacros(keyboard, type);
    
    await hidmacros.stop();
    await Future.delayed(const Duration(seconds: 3));
    await _xml.save();
    await hidmacros.start();
  }

  Future<KeyboardDevice?> getSelectedKeyboard() => _prefs.getSelectedKeyboard();
  Future<KeyboardType?> getSelectedKeyboardType() => _prefs.getKeyboardType();
}
