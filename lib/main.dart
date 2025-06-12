import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/common/widgets/theme_mode_switch.dart';
import 'package:streamkeys/core/theme/bloc/theme_mode_bloc.dart';
import 'package:streamkeys/core/theme/theme.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

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
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ThemeModeSwitch(
                      themeMode: thememode,
                      onChanged: (ThemeMode themeMode) {
                        context
                            .read<ThemeModeBloc>()
                            .add(ThemeModeChange(themeMode));
                      },
                    ),
                    const Text('StreamKeys'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
