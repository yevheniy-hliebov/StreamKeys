import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/mobile/features/buttons/data/models/http_buttons_response.dart';
import 'package:streamkeys/mobile/features/buttons/data/repositories/buttons_repository.dart';

part 'buttons_event.dart';
part 'buttons_state.dart';

class ButtonsBloc extends Bloc<ButtonsEvent, ButtonsState> {
  final ButtonsRepository repository;

  ButtonsBloc(this.repository) : super(ButtonsInitial()) {
    on<ButtonsLoad>(_onLoad);
    on<ButtonsRefresh>(_onRefresh);
  }

  Future<void> _onLoad(
      ButtonsEvent event,
      Emitter<ButtonsState> emit,
  ) async {
    emit(ButtonsLoading());
    try {
      final buttons = await repository.fetchButtons();
      emit(ButtonsLoaded(buttons));
    } catch (e) {
      emit(ButtonsError(e.toString()));
    }
  }

  Future<void> _onRefresh(
      ButtonsRefresh event,
      Emitter<ButtonsState> emit,
  ) async {
    await _onLoad(event, emit);
  }
}
