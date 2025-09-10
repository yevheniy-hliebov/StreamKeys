import 'dart:io';

import 'package:streamkeys/desktop/utils/logger.dart';
import 'package:streamkeys/desktop/utils/process_runner.dart';

abstract class IHidMacrosProcess {
  Future<void> start();
  Future<void> stop();
  Future<void> restart({
    Duration timoutAfterStop,
    Future<void> Function()? onBetween,
    bool shouldStart,
  });
  Future<bool> getStatus();
}

class HidMacrosProcess implements IHidMacrosProcess {
  final String _assetsPath;
  final ProcessRunner _runner;
  final File? _nircmd;
  final ILogger _logger;

  const HidMacrosProcess({
    required String assetsPath,
    required ProcessRunner runner,
    required File? nircmd,
    required ILogger logger,
  }) : _assetsPath = assetsPath,
       _runner = runner,
       _nircmd = nircmd,
       _logger = logger;

  String get _filename => 'hidmacros.exe';
  String get _folderPath => '$_assetsPath\\hidmacros';

  @override
  Future<bool> getStatus() async {
    try {
      final result = await _runner.run('tasklist', []);
      if (result.exitCode != 0) {
        _log('Error running tasklist: ${result.stderr}');
        return false;
      }
      return result.stdout.toString().toLowerCase().contains(
        _filename.toLowerCase(),
      );
    } catch (e) {
      _log('Error checking process: $e');
      return false;
    }
  }

  @override
  Future<void> start() async {
    if (_nircmd == null) return;

    try {
      await _runner.start(_nircmd.path, [
        'elevate',
        '$_folderPath\\$_filename',
      ], mode: ProcessStartMode.detached);

      _waitUntilRunning();
      _log('Started.');
    } catch (e) {
      _log('Failed to start HIDMacros: $e');
    }
  }

  @override
  Future<void> stop() async {
    if (_nircmd == null) return;

    try {
      final result = await _runner.run(_nircmd.path, [
        'elevatecmd',
        'closeprocess',
        _filename,
      ]);

      if (result.exitCode == 0) {
        _log('Sent close window command');
      } else {
        _log('Failed to send close command: ${result.stderr}');
      }
    } catch (e) {
      _log('Error stopping: $e');
    }
  }

  @override
  Future<void> restart({
    Duration timoutAfterStop = const Duration(seconds: 5),
    Future<void> Function()? onBetween,
    bool shouldStart = false,
  }) async {
    if (await getStatus()) {
      await stop();
      _log('Stopped. ${shouldStart ? 'Restarting...' : ''}');
    }

    await Future.delayed(timoutAfterStop);

    if (onBetween != null) {
      await onBetween();
    }

    if (shouldStart) {
      await start();
    }
  }

  void _log(String message) {
    _logger(service: 'HIDMacros', msg: message);
  }

  Future<void> _waitUntilRunning({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final start = DateTime.now();
    while (!(await getStatus())) {
      if (DateTime.now().difference(start) > timeout) {
        _log('Application didn\'t start within ${timeout.inSeconds} seconds');
        break;
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }
}
