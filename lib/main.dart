import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/app_with_overlays.dart';
import 'package:streamkeys/features/action_library/bloc/drag_status_bloc.dart';
import 'package:streamkeys/features/dashboard/dashboard_deck_page.dart';
import 'package:streamkeys/common/theme/theme.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/hid_macros/bloc/hid_macros_bloc.dart';
import 'package:streamkeys/features/keyboards_deck/bloc/keyboard_map_bloc.dart';
import 'package:streamkeys/features/obs/bloc/obs_connection_bloc.dart';
import 'package:streamkeys/features/obs/data/repositories/obs_connection_repository.dart';
import 'package:streamkeys/features/obs/widgets/obs_connection_status.dart';
import 'package:streamkeys/features/theme/bloc/theme_mode_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/features/twitch/bloc/auth/twitch_auth_bloc.dart';
import 'package:streamkeys/features/twitch/bloc/connection/twitch_connection_bloc.dart';
import 'package:streamkeys/features/twitch/bloc/connection/twitch_connection_event.dart';
import 'package:streamkeys/features/twitch/data/repositories/twitch_connection_service.dart';
import 'package:streamkeys/features/twitch/widgets/twitch_connection_status.dart';
import 'package:streamkeys/utils/hid_macros_helper.dart';

void main() async {
  await HidMacrosHelper.start();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final twitchRepository = TwitchRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeModeBloc()),
        BlocProvider(
          create: (_) => ObsConnectionBloc(ObsConnectionRepository()),
        ),
        BlocProvider(create: (_) => HidMacrosBloc()),
        BlocProvider(create: (_) => DragStatusBloc()),
        BlocProvider(create: (_) => GridDeckPagesBloc()),
        BlocProvider(create: (_) => KeyboardDeckPagesBloc()),
        BlocProvider(create: (_) => KeyboardMapBloc()),
        BlocProvider(
          create: (_) => TwitchAuthBloc(twitchRepository),
        ),
        BlocProvider(
          create: (_) => TwitchConnectionBloc(
            twitchRepository,
            TwitchConnectionService(),
          )..add(StartConnectionChecks()),
        ),
      ],
      child: BlocBuilder<ThemeModeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'StreamKeys',
            themeMode: themeMode,
            theme: STheme.light,
            darkTheme: STheme.dark,
            home: const AppWithOverlays(
              home: DashboardPage(),
              overlays: [
                TwitchConnectionStatus(),
                ObsConnectionStatus(),
              ],
            ),
          );
        },
      ),
    );
  }
}
