part of 'cursor_status_bloc.dart';

abstract class CursorStatusEvent extends Equatable {
  const CursorStatusEvent();

  @override
  List<Object?> get props => [];
}

class CursorDrag extends CursorStatusEvent {}

class CursorForbidden extends CursorStatusEvent {}

class CursorDefault extends CursorStatusEvent {}
