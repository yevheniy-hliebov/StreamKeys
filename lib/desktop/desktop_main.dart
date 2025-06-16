// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/app.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/widgets/page_tab.dart';
import 'package:streamkeys/desktop/features/deck/presentation/screens/grid_deck_screen.dart';
import 'package:streamkeys/desktop/features/deck/presentation/screens/keyboard_deck_screen.dart';
import 'package:streamkeys/desktop/features/deck_page_list/bloc/deck_page_list_bloc.dart';
import 'package:streamkeys/desktop/features/settings/presentation/screens/settings_screen.dart';
import 'package:streamkeys/service_locator.dart';

void desktopMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();

  final GridDeckPageListBloc gridDeckBloc = GridDeckPageListBloc();
  final KeyboardDeckPageListBloc keyboardDeckBloc = KeyboardDeckPageListBloc();

  runApp(
    App(
      providersBuilder: (context) => [
        BlocProvider<GridDeckPageListBloc>.value(value: gridDeckBloc),
        BlocProvider<KeyboardDeckPageListBloc>.value(value: keyboardDeckBloc),
      ],
      home: const DashboardScreen(
        tabs: <PageTab>[
          GridDeckScreen(),
          KeyboardDeckScreen(),
          SettingsScreen(),
        ],
      ),
    ),
  );
}
