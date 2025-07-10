part of 'obs_settings_bloc.dart';

sealed class ObsSettingsEvent extends Equatable {
  const ObsSettingsEvent();

  @override
  List<Object> get props => [];
}

class ObsSettingsLoad extends ObsSettingsEvent {}

class ObsSettingsSave extends ObsSettingsEvent {
  final ObsConnectionData data;
  const ObsSettingsSave(this.data);
}