// ignore_for_file: always_specify_types
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/core/theme/bloc/theme_mode_bloc.dart';
import 'package:streamkeys/core/theme/theme.dart';
import 'package:streamkeys/service_locator.dart';

class App extends StatelessWidget {
  final List<BlocProvider>? Function(BuildContext context)? providersBuilder;
  final Widget home;

  const App({
    super.key,
    this.providersBuilder,
    required this.home,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeModeBloc>(
          create: (BuildContext context) => ThemeModeBloc(
            ThemeModeRepository(sl<SharedPreferences>()),
          ),
        ),
        ...(providersBuilder?.call(context) ?? [])
      ],
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
