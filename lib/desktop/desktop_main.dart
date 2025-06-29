import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/app.dart';
import 'package:streamkeys/core/cursor_status/widgets/cursor_status.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:streamkeys/common/widgets/page_tab.dart';
import 'package:streamkeys/desktop/features/deck/presentation/screens/grid_deck_screen.dart';
import 'package:streamkeys/desktop/features/deck/presentation/screens/keyboard_deck_screen.dart';
import 'package:streamkeys/desktop/features/deck_page_list/bloc/deck_page_list_bloc.dart';
import 'package:streamkeys/desktop/features/settings/presentation/screens/general_settings_screen.dart';
import 'package:streamkeys/desktop/features/settings/presentation/screens/settings_screen.dart';
import 'package:streamkeys/desktop/features/settings/presentation/screens/http_server_config_screen.dart';
import 'package:streamkeys/desktop/server/server.dart';
import 'package:streamkeys/service_locator.dart';

void desktopMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();

  registerBindingActions();

  final server = Server();
  await server.init();
  server.start();

  final hidmacros = sl<HidMacrosService>();
  await hidmacros.startAndEnsureConfig();

  final GridDeckPageListBloc gridDeckBloc = GridDeckPageListBloc();
  final KeyboardDeckPageListBloc keyboardDeckBloc = KeyboardDeckPageListBloc();

  gridDeckBloc.add(DeckPageListInit());
  keyboardDeckBloc.add(DeckPageListInit());

  runApp(
    App(
      providersBuilder: (context) => [
        BlocProvider<GridDeckPageListBloc>(create: (_) => gridDeckBloc),
        BlocProvider<KeyboardDeckPageListBloc>(create: (_) => keyboardDeckBloc),
      ],
      home: const CursorStatus(
        child: DashboardScreen(
          tabs: <PageTab>[
            GridDeckScreen(),
            KeyboardDeckScreen(),
            SettingsScreen(
              tabs: <PageTab>[
                GeneralSettingsScreen(),
                HttpServerConfigScreen(),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
