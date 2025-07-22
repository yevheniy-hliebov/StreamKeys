import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/core/theme/data/repositories/theme_mode_repository.dart';
export 'package:streamkeys/core/theme/data/repositories/theme_mode_repository.dart';

part 'theme_mode_event.dart';

class ThemeModeBloc extends Bloc<ThemeModeEvent, ThemeMode> {
  final ThemeModeRepository themeModeRepository;
  late ThemeMode themeMode;

  ThemeModeBloc(this.themeModeRepository) : super(ThemeMode.system) {
    on<ThemeModeInit>(_init);
    on<ThemeModeChange>(_change);

    add(ThemeModeInit());
  }

  Future<void> _init(ThemeModeInit event, Emitter<ThemeMode> emit) async {
    try {
      themeMode = await themeModeRepository.getThemeMode();
    } finally {
      emit(themeMode);
    }
  }

  Future<void> _change(ThemeModeChange event, Emitter<ThemeMode> emit) async {
    themeMode = event.themeMode;
    try {
      await themeModeRepository.saveThemeMode(themeMode);
    } finally {
      emit(themeMode);
    }
  }
}
