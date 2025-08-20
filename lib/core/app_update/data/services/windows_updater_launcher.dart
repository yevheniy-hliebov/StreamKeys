import 'dart:io';

import 'package:github_updater/github_updater.dart';
import 'package:streamkeys/desktop/utils/process_runner.dart';

class WindowsUpdaterLauncher {
  final ProcessRunner _processRunner;
  final void Function(int code) _exitFn;

  WindowsUpdaterLauncher([
    ProcessRunner? processRunner,
    void Function(int)? exitFn,
  ]) : _processRunner = processRunner ?? RealProcessRunner(),
       _exitFn = exitFn ?? exit;

  Future<void> launch({
    required AppVersionMode mode,
    required String version,
  }) async {
    final executable = File(Platform.resolvedExecutable);
    final parentDir = executable.parent.parent;
    final updaterPath = File('${parentDir.path}/Updater.exe');

    if (!await updaterPath.exists()) {
      throw Exception('Updater.exe not found at ${updaterPath.path}');
    }

    await _processRunner.start(updaterPath.path, [
      '--mode',
      mode.name,
      '--version',
      version,
      '--target',
      Directory.current.path,
    ], mode: ProcessStartMode.detached);

    _exitFn(0);
  }
}
