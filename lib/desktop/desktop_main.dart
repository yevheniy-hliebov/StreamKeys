import 'package:flutter/material.dart';
import 'package:streamkeys/app.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:streamkeys/service_locator.dart';

void desktopMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();

  runApp(const App(home: DashboardScreen()));
}
