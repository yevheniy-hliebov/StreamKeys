part of 'drag_status_bloc.dart';

abstract class DragState extends Equatable {
  const DragState();

  @override
  List<Object?> get props => [];
}

class DragInactive extends DragState {
  const DragInactive();
}

class DragActive extends DragState {
  const DragActive();
}
