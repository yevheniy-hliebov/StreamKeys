import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_preferences.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_xml_service.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/service_locator.dart';

class HidMacrosRepository {
  final KeyboardPreferences _keyboardPrefs;
  final HidMacrosXmlService _xml;

  HidMacrosRepository({
    KeyboardPreferences? keyboardPrefs,
    HidMacrosXmlService? xmlService,
  })  : _keyboardPrefs = keyboardPrefs ?? KeyboardPreferences(sl<SharedPreferences>()),
        _xml = xmlService ?? HidMacrosXmlService();

  Future<List<KeyboardDevice>> getDeviceList() async {
    await _xml.read();
    return _xml.getDevices();
  }

  Future<void> select({
    required KeyboardDevice keyboard,
    required KeyboardType type,
    Future<void> Function()? onBeforeSave,
    Future<void> Function()? onAfterSave,
  }) async {
    await _keyboardPrefs.saveKeyboardType(type);
    await _xml.read();
    await _xml.regenerateMacros(keyboard, type);

    await _performSaveSequence(
      () => _xml.save(),
      onBeforeSave: onBeforeSave,
      onAfterSave: onAfterSave,
    );
  }

  Future<void> _performSaveSequence(
    Future<void> Function() saveCallback, {
    Future<void> Function()? onBeforeSave,
    Future<void> Function()? onAfterSave,
  }) async {
    if (onBeforeSave != null) await onBeforeSave();
    await saveCallback();
    if (onAfterSave != null) await onAfterSave();
  }

  KeyboardDevice? getSelectedKeyboard() => _keyboardPrefs.getSelectedKeyboard();
  KeyboardType? getSelectedKeyboardType() => _keyboardPrefs.getKeyboardType();
}
