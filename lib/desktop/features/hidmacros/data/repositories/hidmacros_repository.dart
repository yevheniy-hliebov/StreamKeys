import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/service_locator.dart';

class HidMacrosRepository {
  final HidMacrosPreferences _keyboardPrefs;
  final HidMacrosXmlService _xml;

  Future<void> Function()? onBeforeSave;
  Future<void> Function()? onAfterSave;

  HidMacrosRepository({
    HidMacrosPreferences? keyboardPrefs,
    HidMacrosXmlService? xmlService,
  })  : _keyboardPrefs = keyboardPrefs ?? sl<HidMacrosPreferences>(),
        _xml = xmlService ?? sl<HidMacrosXmlService>();

  Future<void> init() async => _xml.read();

  Future<void> saveAutoStart(bool value) => _keyboardPrefs.saveAutoStart(value);

  bool getAutoStart() => _keyboardPrefs.getAutoStart();

  Future<void> setMinimizeToTray(bool enabled) async {
    _xml.setMinimizeToTray(enabled);
    await _performSaveSequence();
  }

  bool getMinimizeToTray() => _xml.getMinimizeToTray();

  Future<void> setStartMinimized(bool enabled) async {
    _xml.setStartMinimized(enabled);
    await _performSaveSequence();
  }

  bool getStartMinimized() => _xml.getStartMinimized();

  List<KeyboardDevice> getDeviceList() {
    return _xml.getDevices();
  }

  Future<void> select({
    required KeyboardDevice keyboard,
    required KeyboardType type,
  }) async {
    await _keyboardPrefs.saveKeyboardType(type);
    await _xml.regenerateMacros(
      keyboard: keyboard,
      type: type,
      apiPassword: await sl<HttpServerPasswordService>().loadOrCreatePassword(),
    );
    await _performSaveSequence();
  }

  KeyboardDevice? getSelectedKeyboard() => _keyboardPrefs.getSelectedKeyboard();

  KeyboardType? getSelectedKeyboardType() => _keyboardPrefs.getKeyboardType();

  Future<void> _performSaveSequence() async {
    await onBeforeSave?.call();
    await _xml.save();
    await onAfterSave?.call();
  }
}
