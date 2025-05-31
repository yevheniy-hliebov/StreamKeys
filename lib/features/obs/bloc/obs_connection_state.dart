part of 'obs_connection_bloc.dart';

abstract class ObsConnectionState extends Equatable {
  final ObsConnectionData? data;
  final bool autoReconnect;

  const ObsConnectionState([this.data, this.autoReconnect = false]);

  @override
  List<Object?> get props => [data, autoReconnect];
}

class ObsConnectionInitial extends ObsConnectionState {
  const ObsConnectionInitial([super.data, super.autoReconnect]);
}

class ObsConnectionLoading extends ObsConnectionState {
  const ObsConnectionLoading([super.data, super.autoReconnect]);
}

class ObsConnectionConnected extends ObsConnectionState {
  const ObsConnectionConnected([super.data, super.autoReconnect]);
}

class ObsConnectionError extends ObsConnectionState {
  final String message;

  const ObsConnectionError(this.message,
      [ObsConnectionData? data, bool autoReconnect = false])
      : super(data, autoReconnect);

  @override
  List<Object?> get props => [message, data, autoReconnect];
}
