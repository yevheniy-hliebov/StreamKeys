part of 'integration_connection_bloc.dart';

class IntegrationConnectionState {
  final ConnectionStatus status;
  const IntegrationConnectionState(this.status);

  factory IntegrationConnectionState.initial() =>
      const IntegrationConnectionState(ConnectionStatus.notConnected);
}
