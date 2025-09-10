import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/service_locator.dart';

class HidMacrosRepository {
  final HidMacrosPreferences _keyboardPrefs;
  final HidMacrosXmlService _xml;

  HidMacrosRepository({
    HidMacrosPreferences? keyboardPrefs,
    HidMacrosXmlService? xmlService,
  }) : _keyboardPrefs = keyboardPrefs ?? sl<HidMacrosPreferences>(),
       _xml = xmlService ?? sl<HidMacrosXmlService>();

  Future<void> init() async => _xml.read();

  Future<void> setMinimizeToTray(bool enabled) async {
    _xml.setMinimizeToTray(enabled);
    await _xml.save();
  }

  bool getMinimizeToTray() => _xml.getMinimizeToTray();

  Future<void> setStartMinimized(bool enabled) async {
    _xml.setStartMinimized(enabled);
    await _xml.save();
  }

  bool getStartMinimized() => _xml.getStartMinimized();

  List<KeyboardDevice> getDeviceList() {
    return _xml.getDevices();
  }

  Future<void> select({
    required KeyboardDevice keyboard,
    required KeyboardType type,
  }) async {
    await _keyboardPrefs.saveKeyboard(keyboard);
    await _keyboardPrefs.saveKeyboardType(type);
    await _xml.regenerateMacros(
      keyboard: keyboard,
      type: type,
      apiPassword: await sl<HttpServerPasswordService>().loadOrCreatePassword(),
    );
    await _xml.save();
  }

  KeyboardDevice? getSelectedKeyboard() => _keyboardPrefs.getSelectedKeyboard();

  KeyboardType? getSelectedKeyboardType() => _keyboardPrefs.getKeyboardType();
}
