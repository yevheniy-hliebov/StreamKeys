import 'dart:io';

import 'package:flutter/material.dart';
import 'package:streamkeys/android/android_home_page.dart';
import 'package:streamkeys/common/theme/theme.dart';
import 'package:streamkeys/windows/windows_home_page.dart';

class SMaterialApp extends StatefulWidget {
  const SMaterialApp({super.key});

  @override
  State<SMaterialApp> createState() => _MyAppState();
}

class _MyAppState extends State<SMaterialApp> {
  String? lastOctet;

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
