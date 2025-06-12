part of 'theme_mode_bloc.dart';

sealed class ThemeModeEvent extends Equatable {
  const ThemeModeEvent();

  @override
  List<Object> get props => <Object>[];
}

class ThemeModeInit extends ThemeModeEvent {}

class ThemeModeChange extends ThemeModeEvent {
  final ThemeMode themeMode;

  const ThemeModeChange(this.themeMode);
}