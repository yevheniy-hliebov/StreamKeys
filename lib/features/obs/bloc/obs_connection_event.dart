part of 'obs_connection_bloc.dart';

abstract class ObsConnectionEvent extends Equatable {
  const ObsConnectionEvent();

  @override
  List<Object?> get props => [];
}

class ObsConnectionConnectEvent extends ObsConnectionEvent {
  final ObsConnectionData? updatedConnectionData;

  const ObsConnectionConnectEvent([this.updatedConnectionData]);

  @override
  List<Object?> get props => [updatedConnectionData];
}

class ObsConnectionDisconnectEvent extends ObsConnectionEvent {}

class ObsConnectionReconnectEvent extends ObsConnectionEvent {
  final ObsConnectionData? updatedConnectionData;

  const ObsConnectionReconnectEvent([this.updatedConnectionData]);

  @override
  List<Object?> get props => [updatedConnectionData];
}

class ObsConnectionToggleAutoReconnectEvent extends ObsConnectionEvent {
  final bool enabled;

  const ObsConnectionToggleAutoReconnectEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}
