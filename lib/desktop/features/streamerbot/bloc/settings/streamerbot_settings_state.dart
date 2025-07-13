part of 'streamerbot_settings_bloc.dart';

sealed class StreamerBotSettingsState extends Equatable {
  const StreamerBotSettingsState();

  @override
  List<Object?> get props => [];
}

class StreamerBotSettingsInitial extends StreamerBotSettingsState {}

class StreamerBotSettingsLoaded extends StreamerBotSettingsState {
  final StreamerBotConnectionData? data;
  const StreamerBotSettingsLoaded([this.data]);

  @override
  List<Object?> get props => [data];
}
