part of 'buttons_bloc.dart';

sealed class ButtonsState extends Equatable {
  const ButtonsState();

  @override
  List<Object> get props => [];
}

final class ButtonsInitial extends ButtonsState {}

final class ButtonsLoading extends ButtonsState {}

final class ButtonsLoaded extends ButtonsState {
  final HttpButtonsResponse buttons;

  const ButtonsLoaded(this.buttons);

  @override
  List<Object> get props => [buttons];
}

final class ButtonsError extends ButtonsState {
  final String message;

  const ButtonsError(this.message);

  @override
  List<Object> get props => [message];
}
