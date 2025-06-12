import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamkeys/core/theme/bloc/theme_mode_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeModeRepository extends Mock implements ThemeModeRepository {}

void main() {
  late MockThemeModeRepository repository;

  setUp(() {
    repository = MockThemeModeRepository();
    registerFallbackValue(ThemeMode.system);
  });

  group('ThemeModeBloc', () {
    blocTest<ThemeModeBloc, ThemeMode>(
      'emits saved theme mode on ThemeModeInit',
      build: () {
        when(() => repository.getThemeMode())
            .thenAnswer((_) async => ThemeMode.dark);
        return ThemeModeBloc(repository);
      },
      wait: const Duration(milliseconds: 1),
      expect: () => <ThemeMode>[ThemeMode.dark],
      verify: (_) => verify(() => repository.getThemeMode()).called(1),
    );

    blocTest<ThemeModeBloc, ThemeMode>(
      'emits new theme mode on ThemeModeChange',
      build: () {
        when(() => repository.getThemeMode())
            .thenAnswer((_) async => ThemeMode.system);
        when(() => repository.saveThemeMode(any())).thenAnswer((_) async {});
        return ThemeModeBloc(repository);
      },
      act: (ThemeModeBloc bloc) async {
        await Future<void>.delayed(Duration.zero);
        bloc.add(const ThemeModeChange(ThemeMode.light));
      },
      expect: () => <ThemeMode>[ThemeMode.system, ThemeMode.light],
      verify: (ThemeModeBloc bloc) {
        verify(() => repository.saveThemeMode(ThemeMode.light)).called(1);
      },
    );
  });
}
