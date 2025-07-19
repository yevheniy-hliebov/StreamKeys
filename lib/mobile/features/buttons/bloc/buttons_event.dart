part of 'buttons_bloc.dart';

sealed class ButtonsEvent extends Equatable {
  const ButtonsEvent();

  @override
  List<Object> get props => [];
}

final class ButtonsLoad extends ButtonsEvent {}

final class ButtonsRefresh extends ButtonsEvent {}
