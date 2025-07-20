import 'dart:io';

import 'package:streamkeys/core/constants/version.dart';

class UpdaterLauncher {
  const UpdaterLauncher();

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

    await Process.start(
      updaterPath.path,
      [
        '--mode', mode.name,
        '--version', version,
        '--target', Directory.current.path,
      ],
      mode: ProcessStartMode.detached,
    );

    exit(0);
  }
}