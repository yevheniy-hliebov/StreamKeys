import 'package:flutter/material.dart';
import 'package:streamkeys/app.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/widgets/page_tab.dart';
import 'package:streamkeys/desktop/features/deck/presentation/screens/grid_deck_screen.dart';
import 'package:streamkeys/desktop/features/deck/presentation/screens/keyboard_deck_screen.dart';
import 'package:streamkeys/desktop/features/settings/presentation/screens/settings_screen.dart';
import 'package:streamkeys/service_locator.dart';

void desktopMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();

  runApp(
    const App(
      home: DashboardScreen(
        tabs: <PageTab>[
          GridDeckScreen(),
          KeyboardDeckScreen(),
          SettingsScreen(),
        ],
      ),
    ),
  );
}
