part of 'obs_settings_bloc.dart';

sealed class ObsSettingsState extends Equatable {
  const ObsSettingsState();

  @override
  List<Object?> get props => [];
}

class ObsSettingsInitial extends ObsSettingsState {}

class ObsSettingsLoaded extends ObsSettingsState {
  final ObsConnectionData? data;
  const ObsSettingsLoaded([this.data]);

  @override
  List<Object?> get props => [data];
}
