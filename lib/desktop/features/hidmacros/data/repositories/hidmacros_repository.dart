import 'package:streamkeys/desktop/features/hidmacros/data/models/hidmacros_startup_options.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_service.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';

abstract class IHidMacrosRepository {
  Future<void> read();
  Future<bool> getAutoStart();
  Future<HidMacrosStartupOptions> getStartupOptions();
  Future<List<KeyboardDevice>> getKeyboards();
  KeyboardDevice? getSelectedKeyboard();
  KeyboardType? getSelectedKeyboardType();
  Future<void> applyChanges({
    required KeyboardDevice? selectedKeyboard,
    required KeyboardType? selectedType,
    required HidMacrosStartupOptions options,
    required bool autoStart,
  });
}

class HidMacrosRepository implements IHidMacrosRepository {
  final HidMacrosService _hidmacros;

  HidMacrosRepository(this._hidmacros);

  @override
  Future<void> read() async {
    await _hidmacros.config.read();
  }

  @override
  Future<bool> getAutoStart() async {
    return _hidmacros.autoStartPrefs.getAutoStart();
  }

  @override
  Future<HidMacrosStartupOptions> getStartupOptions() async {
    return _hidmacros.config.startup.getStartupOptions();
  }

  @override
  Future<List<KeyboardDevice>> getKeyboards() {
    return _hidmacros.config.devices.getDevices();
  }

  @override
  KeyboardDevice? getSelectedKeyboard() {
    return _hidmacros.keyboardService.getSelectedKeyboard();
  }

  @override
  KeyboardType? getSelectedKeyboardType() {
    return _hidmacros.keyboardService.getKeyboardType();
  }

  @override
  Future<void> applyChanges({
    required KeyboardDevice? selectedKeyboard,
    required KeyboardType? selectedType,
    required HidMacrosStartupOptions options,
    required bool autoStart,
  }) {
    return _hidmacros.applyChanges(
      selectedKeyboard: selectedKeyboard,
      selectedType: selectedType,
      options: options,
      autoStart: autoStart,
    );
  }
}
