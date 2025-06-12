import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamkeys/common/widgets/theme_mode_switch.dart';

void main() {
  testWidgets('ThemeModeSwitch triggers onChanged with correct value', (WidgetTester tester) async {
    ThemeMode? selectedMode;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          body: ThemeModeSwitch(
            themeMode: ThemeMode.light,
            onChanged: (ThemeMode themeMode) => selectedMode = themeMode,
          ),
        ),
      ),
    );

    final Finder switchFinder = find.byType(Switch);
    final Switch sw = tester.widget(switchFinder);
    expect(sw.value, false);

    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    expect(selectedMode, ThemeMode.dark);
  });
}
