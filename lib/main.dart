import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/app_with_overlays.dart';
import 'package:streamkeys/features/dashboard/dashboard_deck_page.dart';
import 'package:streamkeys/common/theme/theme.dart';
import 'package:streamkeys/features/hid_macros/bloc/hid_macros_bloc.dart';
import 'package:streamkeys/features/obs/bloc/obs_connection_bloc.dart';
import 'package:streamkeys/features/obs/data/repositories/obs_connection_repository.dart';
import 'package:streamkeys/features/obs/widgets/obs_connection_status.dart';
import 'package:streamkeys/features/server/server.dart';
import 'package:streamkeys/features/theme/bloc/theme_mode_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/utils/hid_macros_helper.dart';

void main() async {
  final server = Server();
  await server.init();
  await server.start();

  final hidMacrosHelper = HidMacrosHelper();
  await hidMacrosHelper.start();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeModeBloc()),
        BlocProvider(
          create: (_) => ObsConnectionBloc(ObsConnectionRepository()),
        ),
        BlocProvider(create: (_) => HidMacrosBloc()),
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
                ObsConnectionStatus(),
              ],
            ),
          );
        },
      ),
    );
  }
}
