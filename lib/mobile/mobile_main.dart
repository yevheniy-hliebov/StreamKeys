import 'package:flutter/material.dart';
import 'package:streamkeys/app.dart';
import 'package:streamkeys/service_locator.dart';

void mobileMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();

  runApp(App(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Mobile'),
      ),
    ),
  ));
}
