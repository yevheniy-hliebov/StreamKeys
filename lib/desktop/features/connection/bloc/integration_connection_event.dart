part of 'integration_connection_bloc.dart';

abstract class IntegrationConnectionEvent {}

class IntegrationConnectionChanged extends IntegrationConnectionEvent {
  final ConnectionStatus status;
  IntegrationConnectionChanged(this.status);
}

class IntegrationConnectionCheck extends IntegrationConnectionEvent {}
