import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:process_run/shell.dart';
import 'package:path/path.dart' as path;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class StartupHelper {
  static String _getExecutablePath() {
    return Platform.resolvedExecutable;
  }

  static Future<String> _getAppDirectory() async {
    final executablePath = _getExecutablePath();
    return executablePath.replaceFirst('\\streamkeys.exe', '');
  }

  static Future<String?> _getStartupFolderPath() async {
    if (Platform.isWindows) {
      final shell = Shell();
      var result = await shell.run(
        'echo %APPDATA%\\Microsoft\\Windows\\Start Menu\\Programs\\Startup',
      );
      if (result.isNotEmpty && result.first.stdout != null) {
        return result.first.stdout.trim();
      }
    }
    return null;
  }

  static Future<void> createStartupShortcut() async {
    String executablePath = _getExecutablePath();
    String appDirectory = await _getAppDirectory();
    String startupFolderPath = await _getStartupFolderPath() ?? '';
    String arguments = "--startup";

    var shell = Shell();
    var tempDir = Directory.systemTemp;
    var tempFile = File('${tempDir.path}/temp_script.vbs');

    String vbsScript = '''
    Set oWS = WScript.CreateObject("WScript.Shell")
    sLinkFile = "$startupFolderPath\\streamkeys.lnk"
    Set oLink = oWS.CreateShortcut(sLinkFile)
        oLink.TargetPath = "$executablePath"
        oLink.Arguments = "$arguments"
        oLink.IconLocation = "$executablePath, 2"
        oLink.WindowStyle = "1"
        oLink.WorkingDirectory = "$appDirectory"
    oLink.Save
  ''';

    await tempFile.writeAsString(vbsScript);
    await shell.run('cscript //NoLogo ${tempFile.path}');
    await tempFile.delete();
  }

  static Future<void> removeStartupShortcut() async {
    if (Platform.isWindows) {
      String? startupFolderPath = await _getStartupFolderPath();
      if (startupFolderPath != null) {
        String shortcutName = 'streamkeys.lnk';
        String shortcutPath = path.join(startupFolderPath, shortcutName);

        final file = File(shortcutPath);

        if (await file.exists()) {
          await file.delete();
          if (kDebugMode) {
            print('Shortcut deleted from $shortcutPath');
          }
        } else {
          if (kDebugMode) {
            print('Shortcut not found at $shortcutPath');
          }
        }
      }
    }
  }

  static bool get isLaunchedAtStartup {
    final kernel32 = DynamicLibrary.open('kernel32.dll');

    final Pointer<Utf16> Function() getCommandLine = kernel32
        .lookup<NativeFunction<Pointer<Utf16> Function()>>('GetCommandLineW')
        .asFunction();

    final Pointer<Utf16> cmdLine = getCommandLine();
    final String commandLine = cmdLine.toDartString();
    return commandLine.contains('--startup');
  }

  static Future<bool> doesShortcutExistInStartup() async {
    String? startupFolderPath = await _getStartupFolderPath();
    if (startupFolderPath == null) {
      return false;
    }

    final filePath = '$startupFolderPath\\streamkeys.lnk';
    return File(filePath).exists();
  }
}
