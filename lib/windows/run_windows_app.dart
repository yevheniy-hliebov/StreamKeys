import 'package:flutter/material.dart';
import 'package:streamkeys/material_app.dart';
import 'package:streamkeys/windows/server/server.dart';
import 'package:window_manager/window_manager.dart';

Future<void> runWindowsApp() async {
  await Server.start();

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const size = Size(385, 272);

  const windowOptions = WindowOptions(
    size: size,
    maximumSize: size,
    minimumSize: size,
    center: true,
    fullScreen: false,
    alwaysOnTop: false,
    title: 'StreamKeys',
  );

  await windowManager.waitUntilReadyToShow(windowOptions);
  windowManager.show();
  windowManager.focus();

  windowManager.addListener(WindowMinimizedListener());

  runApp(const SMaterialApp());
}

class WindowMinimizedListener extends WindowListener {
  @override
  void onWindowMinimize() {
    windowManager.hide();
  }
}
