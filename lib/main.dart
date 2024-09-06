import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/android/android_home_page.dart';
import 'package:streamkeys/android/last_octet_page.dart';
import 'package:streamkeys/common/theme/theme.dart';
import 'package:streamkeys/windows/windows_home_page.dart';
import 'package:streamkeys/windows/server.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  if (Platform.isWindows) {
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
  }

  runApp(const MyApp());
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
      return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
            );
          } else if (snapshot.hasData) {
            final prefs = snapshot.data as SharedPreferences;
            lastOctet = prefs.getString('lastOctet');
            if (lastOctet == null || lastOctet == '') {
              return const LastOctetPage();
            }

            final lastOctetInt = int.parse(lastOctet!);
            return AndroidHomePage(
              lastOctet: lastOctetInt,
            );
          } else {
            return const Scaffold();
          }
        },
      );
    }
  }
}
