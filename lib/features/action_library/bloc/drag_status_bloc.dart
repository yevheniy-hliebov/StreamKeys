import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'drag_event.dart';
part 'drag_state.dart';

class DragStatusBloc extends Bloc<DragEvent, DragState> {
  DragStatusBloc() : super(const DragInactive()) {
    on<StartDragEvent>((event, emit) => emit(const DragActive()));
    on<EndDragEvent>((event, emit) => emit(const DragInactive()));
  }
}
