import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/core/theme/bloc/theme_mode_bloc.dart';
import 'package:streamkeys/core/theme/theme.dart';
import 'package:streamkeys/service_locator.dart';

class App extends StatelessWidget {
  final Widget home;

  const App({
    super.key,
    required this.home,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeModeBloc>(
      create: (BuildContext context) => ThemeModeBloc(
        ThemeModeRepository(sl<SharedPreferences>()),
      ),
      child: BlocBuilder<ThemeModeBloc, ThemeMode>(
        builder: (BuildContext context, ThemeMode thememode) {
          return MaterialApp(
            title: 'StreamKeys',
            themeMode: thememode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: home,
          );
        },
      ),
    );
  }
}
