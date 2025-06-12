import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/core/theme/bloc/theme_mode_bloc.dart';

void main() {
  late SharedPreferences prefs;
  late ThemeModeRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    prefs = await SharedPreferences.getInstance();
    repository = ThemeModeRepository(prefs);
  });
  group('ThemeModeRepository', () {
    test('saveThemeMode stores light mode correctly', () async {
      await repository.saveThemeMode(ThemeMode.light);
      expect(prefs.getString(ThemeModeRepository.themeModeKey),
          ThemeMode.light.name);
    });

    test('saveThemeMode stores dark mode correctly', () async {
      await repository.saveThemeMode(ThemeMode.dark);
      expect(prefs.getString(ThemeModeRepository.themeModeKey),
          ThemeMode.dark.name);
    });

    test('getThemeMode returns light mode', () async {
      await prefs.setString(
          ThemeModeRepository.themeModeKey, ThemeMode.light.name);
      expect(await repository.getThemeMode(), ThemeMode.light);
    });

    test('getThemeMode returns dark mode', () async {
      await prefs.setString(
          ThemeModeRepository.themeModeKey, ThemeMode.dark.name);
      expect(await repository.getThemeMode(), ThemeMode.dark);
    });

    test('getThemeMode returns system when value is unknown', () async {
      await prefs.setString(ThemeModeRepository.themeModeKey, 'unknown');
      expect(await repository.getThemeMode(), ThemeMode.system);
    });

    test('getThemeMode returns system when value is null', () async {
      expect(await repository.getThemeMode(), ThemeMode.system);
    });
  });
}
