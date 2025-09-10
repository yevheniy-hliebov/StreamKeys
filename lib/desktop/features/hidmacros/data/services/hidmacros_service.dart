import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_process.dart';
import 'package:streamkeys/desktop/utils/logger.dart';
import 'package:streamkeys/service_locator.dart';

class HidMacrosService {
  final IHidMacrosProcess process;
  final ILogger _logger;

  const HidMacrosService({required this.process, required ILogger logger})
    : _logger = logger;

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
