part of 'streamerbot_connection_bloc.dart';

class StreamerBotConnectionState extends Equatable {
  final ConnectionStatus status;
  final String? errorMessage;

  const StreamerBotConnectionState(this.status, [this.errorMessage]);

  factory StreamerBotConnectionState.initial() {
    return const StreamerBotConnectionState(ConnectionStatus.notConnected);
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
