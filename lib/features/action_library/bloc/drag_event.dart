part of 'drag_status_bloc.dart';

abstract class DragEvent extends Equatable {
  const DragEvent();

  @override
  List<Object?> get props => [];
}

class StartDragEvent extends DragEvent {
  const StartDragEvent();
}

class EndDragEvent extends DragEvent {
  const EndDragEvent();
}
