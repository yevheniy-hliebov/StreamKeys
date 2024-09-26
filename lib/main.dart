import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/android/android_home_page.dart';
import 'package:streamkeys/common/theme/theme.dart';
import 'package:streamkeys/windows/windows_home_page.dart';
import 'package:streamkeys/windows/server/server.dart';
import 'package:window_manager/window_manager.dart';


Future<void> main() async {
  if (Platform.isWindows) {
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
  }

  runApp(const MyApp());
}

class WindowMinimizedListener extends WindowListener {
  @override
  void onWindowMinimize() {
    windowManager.hide();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? lastOctet;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then(
      (prefs) {
        lastOctet = prefs.getString('lastOctet');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreamKeys',
      themeMode: ThemeMode.dark,
      theme: STheme.light,
      darkTheme: STheme.dark,
      home: _home,
    );
  }

  Widget get _home {
    if (Platform.isWindows) {
      return const WindowsHomePage();
    } else {
      return const AndroidHomePage();
    }
  }
}
