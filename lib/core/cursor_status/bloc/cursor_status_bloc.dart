import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cursor_status_event.dart';
part 'drag_status_state.dart';

class CursorStatusBloc extends Bloc<CursorStatusEvent, CursorStatusState> {
  CursorStatusBloc() : super(const CursorStatusState(MouseCursor.defer)) {
    on<CursorDrag>((event, emit) {
      emit(const CursorStatusState(SystemMouseCursors.click));
    });
    on<CursorForbidden>(
      (event, emit) =>
          emit(const CursorStatusState(SystemMouseCursors.forbidden)),
    );
    on<CursorDefault>(
      (event, emit) => emit(const CursorStatusState(MouseCursor.defer)),
    );
  }
}
