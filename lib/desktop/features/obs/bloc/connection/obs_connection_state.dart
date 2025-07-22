part of 'obs_connection_bloc.dart';

class ObsConnectionState extends Equatable {
  final ConnectionStatus status;
  final String? errorMessage;

  const ObsConnectionState(this.status, [this.errorMessage]);

  factory ObsConnectionState.initial() {
    return const ObsConnectionState(ConnectionStatus.notConnected);
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
