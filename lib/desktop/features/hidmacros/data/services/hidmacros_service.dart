import 'package:streamkeys/desktop/features/hidmacros/data/models/hidmacros_startup_options.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_auto_start_service.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_config.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_connection_watcher.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_process.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/keyboard_service.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/desktop/utils/logger.dart';

class HidMacrosService {
  final ILogger _logger;
  final IHidMacrosProcess process;
  final IHidMacrosConfig config;
  final IKeyboardService keyboardService;
  final IHidMacrosAutoStartPreferences autoStartPrefs;
  late final IHidMacrosStatusMonitor statusMonitor;

  HidMacrosService({
    required ILogger logger,
    required this.process,
    required this.config,
    required this.keyboardService,
    required this.autoStartPrefs,
  }) : _logger = logger {
    statusMonitor = HidMacrosStatusMonitor(process);
  }

  Future<void> ensureConfigAndStart() async {
    if (!config.isConfigExists()) {
      _log('Xml config file not found, generating xml file...');
      final keyboardIds = await keyboardService.getIds();
      final keyboard = keyboardService.getSelectedKeyboard();
      final type = keyboardService.getKeyboardType();

      await config.generateXml(
        keyboardIds: keyboardIds,
        selectedKeyboard: keyboard,
        selectedType: type,
      );

      await config.save();
    }

    if (autoStartPrefs.getAutoStart()) {
      await process.start();
    }
  }

  Future<void> applyChanges({
    required KeyboardDevice? selectedKeyboard,
    required KeyboardType? selectedType,
    required HidMacrosStartupOptions options,
    required bool autoStart,
  }) async {
    if (await process.getStatus()) {
      await process.stop(force: true);
    }

    await config.read();

    if (selectedKeyboard != null) {
      await keyboardService.setSelectedKeyboard(selectedKeyboard);
    }

    if (selectedType != null) {
      await keyboardService.setKeyboardType(selectedType);
    }

    if (selectedKeyboard != null && selectedType != null) {
      await config.macros.setMacros(selectedKeyboard, selectedType);
    }

    await config.startup.setStartupOptions(options);

    await autoStartPrefs.setAutoStart(autoStart);

    await config.save();

    _log('Changes applied');

    if (autoStart) {
      await process.start();
    }
  }

  void _log(String message) {
    _logger(service: 'HIDMacros', msg: message);
  }
}
