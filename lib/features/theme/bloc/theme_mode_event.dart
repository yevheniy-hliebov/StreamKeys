part of 'theme_mode_bloc.dart';

sealed class ThemeModeEvent {}

final class ThemeModeLoadEvent extends ThemeModeEvent {}

final class ThemeModeChangeEvent extends ThemeModeEvent {
  final ThemeMode themeMode;

  ThemeModeChangeEvent({required this.themeMode});
}
