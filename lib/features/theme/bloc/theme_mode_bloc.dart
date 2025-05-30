import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/theme/repositories/theme_mode_reporistory.dart';

part 'theme_mode_event.dart';

class ThemeModeBloc extends Bloc<ThemeModeEvent, ThemeMode> {
  late ThemeModeRepository _themeModeRepository;

  ThemeModeBloc({ThemeModeRepository? themeModeRepository})
      : super(ThemeMode.light) {
    _themeModeRepository = themeModeRepository ?? ThemeModeRepository();

    on<ThemeModeLoadEvent>(loadThemeMode);
    add(ThemeModeLoadEvent());
    on<ThemeModeChangeEvent>(saveThemeMode);
  }

  FutureVoid loadThemeMode(
    ThemeModeLoadEvent event,
    Emitter<ThemeMode> emit,
  ) async {
    final savedThemeMode = await _themeModeRepository.getThemeMode();
    emit(savedThemeMode);
  }

  FutureVoid saveThemeMode(
    ThemeModeChangeEvent event,
    Emitter<ThemeMode> emit,
  ) async {
    await _themeModeRepository.saveThemeMode(event.themeMode);
    emit(event.themeMode);
  }
}
