import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/theme/theme.dart';
import 'package:streamkeys/common/widgets/app_with_overlays.dart';
import 'package:streamkeys/features/action_library/bloc/drag_status_bloc.dart';
import 'package:streamkeys/features/dashboard/dashboard_deck_page.dart';
import 'package:streamkeys/features/hid_macros/bloc/hid_macros_bloc.dart';
import 'package:streamkeys/features/keyboards_deck/bloc/keyboard_map_bloc.dart';
import 'package:streamkeys/features/obs/widgets/obs_connection_status.dart';
import 'package:streamkeys/features/theme/bloc/theme_mode_bloc.dart';
import 'package:streamkeys/features/twitch/widgets/twitch_connection_status.dart';

class WindowsApp extends StatelessWidget {
  const WindowsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeModeBloc()),
        BlocProvider(create: (_) => HidMacrosBloc()),
        BlocProvider(create: (_) => DragStatusBloc()),
        BlocProvider(create: (_) => KeyboardMapBloc()),
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
