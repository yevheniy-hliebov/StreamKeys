part of 'streamerbot_connection_bloc.dart';

sealed class StreamerBotConnectionEvent extends Equatable {
  const StreamerBotConnectionEvent();

  @override
  List<Object> get props => [];
}

class StreamerBotConnectionReconnect extends StreamerBotConnectionEvent {}

class StreamerBotConnectionChanged extends StreamerBotConnectionEvent {
  final ConnectionStatus status;
  const StreamerBotConnectionChanged(this.status);
}
