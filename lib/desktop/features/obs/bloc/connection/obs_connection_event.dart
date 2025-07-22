part of 'obs_connection_bloc.dart';

sealed class ObsConnectionEvent extends Equatable {
  const ObsConnectionEvent();

  @override
  List<Object> get props => [];
}

class ObsConnectionReconnect extends ObsConnectionEvent {}

class ObsConnectionChanged extends ObsConnectionEvent {
  final ConnectionStatus status;
  const ObsConnectionChanged(this.status);
}
