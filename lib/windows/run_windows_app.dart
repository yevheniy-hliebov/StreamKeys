import 'package:flutter/material.dart';
import 'package:streamkeys/material_app.dart';
import 'package:streamkeys/windows/services/tray_manager_service.dart';
import 'package:streamkeys/windows/utils/startup_helpers.dart';
import 'package:window_manager/window_manager.dart';

Future<void> runWindowsApp() async {
  final trayManagerService = TrayManagerService();
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const size = Size(1400, 850);

  const windowOptions = WindowOptions(
    minimumSize: size,
    center: true,
    fullScreen: false,
    alwaysOnTop: false,
    title: 'StreamKeys',
  );

  windowManager.addListener(WindowMinimizedListener());

  await windowManager.waitUntilReadyToShow(
    windowOptions,
    () async {
      await trayManagerService.setupTray();
      if (StartupHelper.isLaunchedAtStartup) {
        await windowManager.minimize();
      } else {
        await windowManager.focus();
        await windowManager.maximize();
      }
    },
  );

  runApp(const SMaterialApp());
}

class WindowMinimizedListener extends WindowListener {
  @override
  void onWindowMinimize() {
    windowManager.hide();
  }
}
