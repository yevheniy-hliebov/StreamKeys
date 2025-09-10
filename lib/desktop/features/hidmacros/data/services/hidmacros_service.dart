import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_auto_start_service.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_connection_watcher.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_process.dart';
import 'package:streamkeys/desktop/utils/logger.dart';
import 'package:streamkeys/service_locator.dart';

class HidMacrosService {
  final ILogger _logger;
  final IHidMacrosProcess process;
  final IHidMacrosAutoStartPreferences autoStartPrefs;
  late final IHidMacrosStatusMonitor statusMonitor;

  HidMacrosService({
    required ILogger logger,
    required this.process,
    required this.autoStartPrefs,
  }) : _logger = logger {
    statusMonitor = HidMacrosStatusMonitor(process);
  }

  Future<void> startAndEnsureConfig() async {
    await process.start();

    if (!sl<HidMacrosXmlService>().isConfigExists) {
      _log('Config file not found after start, restarting HIDMacros...');
      await process.restart();
    }
  }

  void _log(String message) {
    _logger(service: 'HIDMacros', msg: message);
  }
}
