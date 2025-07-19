part of 'api_connection_bloc.dart';

sealed class ApiConnectionState extends Equatable {
  const ApiConnectionState();

  @override
  List<Object?> get props => [];
}

final class ApiConnectionInitial extends ApiConnectionState {}

class ApiConnectionLoaded extends ApiConnectionState {
  final ApiConnectionData? data;
  const ApiConnectionLoaded([this.data]);

  @override
  List<Object?> get props => [data];
}
