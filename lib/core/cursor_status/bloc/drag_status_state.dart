part of 'cursor_status_bloc.dart';

class CursorStatusState extends Equatable {
  final MouseCursor cursor;

  const CursorStatusState(this.cursor);

  @override
  List<Object?> get props => [cursor];
}
