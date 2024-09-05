import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/theme.dart';
import 'package:streamkeys/windows/windows_home_page.dart';
import 'package:streamkeys/windows/server.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  Server.routerHandler();
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreamKeys',
      themeMode: ThemeMode.light,
      theme: STheme.light,
      darkTheme: STheme.dark,
      home: const WindowsHomePage(),
    );
  }
}