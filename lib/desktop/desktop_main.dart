import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/app.dart';
import 'package:streamkeys/common/widgets/theme_mode_switch.dart';
import 'package:streamkeys/core/theme/bloc/theme_mode_bloc.dart';
import 'package:streamkeys/service_locator.dart';

void desktopMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();

  runApp(const App(home: HomeScreen()));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<ThemeModeBloc, ThemeMode>(
              builder: (BuildContext context, ThemeMode thememode) {
                return ThemeModeSwitch(
                  themeMode: thememode,
                  onChanged: (ThemeMode themeMode) {
                    context
                        .read<ThemeModeBloc>()
                        .add(ThemeModeChange(themeMode));
                  },
                );
              },
            ),
            const Text('StreamKeys'),
          ],
        ),
      ),
    );
  }
}
