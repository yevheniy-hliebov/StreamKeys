import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/keyboard_service.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/service_locator.dart';

class HidMacrosRepository {
  final IKeyboardService _keyboardService;
  final HidMacrosXmlService _xml;

  HidMacrosRepository({
    required IKeyboardService keyboardService,
    required HidMacrosXmlService xmlService,
  }) : _keyboardService = keyboardService,
       _xml = xmlService;

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
    await _keyboardService.setSelectedKeyboard(keyboard);
    await _keyboardService.setKeyboardType(type);
    await _xml.regenerateMacros(
      keyboard: keyboard,
      type: type,
      apiPassword: await sl<HttpServerPasswordService>().loadOrCreatePassword(),
    );
    await _xml.save();
  }

  KeyboardDevice? getSelectedKeyboard() => _keyboardService.getSelectedKeyboard();

  KeyboardType? getSelectedKeyboardType() => _keyboardService.getKeyboardType();
}
