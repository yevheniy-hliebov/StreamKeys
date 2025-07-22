part of 'api_connection_bloc.dart';

sealed class ApiConnectionEvent extends Equatable {
  const ApiConnectionEvent();

  @override
  List<Object> get props => [];
}

class ApiConnectionLoad extends ApiConnectionEvent {}

class ApiConnectionSave extends ApiConnectionEvent {
  final ApiConnectionData data;
  const ApiConnectionSave(this.data);
}
