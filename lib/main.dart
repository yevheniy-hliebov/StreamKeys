import 'package:flutter/material.dart';
import 'package:streamkeys/features/dashboard/view.dart';
import 'package:streamkeys/common/theme/theme.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: STheme.light,
      darkTheme: STheme.dark,
      home: const DashboardPage(),
    );
  }
}
