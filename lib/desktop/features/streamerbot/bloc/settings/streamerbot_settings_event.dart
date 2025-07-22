part of 'streamerbot_settings_bloc.dart';

sealed class StreamerBotSettingsEvent extends Equatable {
  const StreamerBotSettingsEvent();

  @override
  List<Object> get props => [];
}

class StreamerBotSettingsLoad extends StreamerBotSettingsEvent {}

class StreamerBotSettingsSave extends StreamerBotSettingsEvent {
  final StreamerBotConnectionData data;
  const StreamerBotSettingsSave(this.data);
}
