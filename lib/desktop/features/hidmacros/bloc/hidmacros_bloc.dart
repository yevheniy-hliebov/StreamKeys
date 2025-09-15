import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/hidmacros_startup_options.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/repositories/hidmacros_repository.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';

part 'hidmacros_event.dart';
part 'hidmacros_state.dart';

class HidMacrosBloc extends Bloc<HidMacrosEvent, HidMacrosState> {
  final IHidMacrosRepository _repo;

  HidMacrosBloc({required IHidMacrosRepository repo})
    : _repo = repo,
      super(const HidMacrosState()) {
    on<HidMacrosLoadEvent>(_load);

    on<HidMacrosToggleAutoStartEvent>(_toggleAutoStart);
    on<HidMacrosToggleMinimizeToTrayEvent>(_toggleMinimizeToTray);
    on<HidMacrosToggleStartMinizedEvent>(_toggleStartMinimized);

    on<HidMacrosSelectKeyboardEvent>(_selectKeyboard);
    on<HidMacrosSelectKeyboardTypeEvent>(_selectKeyboardType);
    on<HidMacrosSelectKeyboardTypeAndSaveEvent>(_selectKeyboardTypeAndSave);

    on<HidMacrosApplyChangesEvent>(_applyChanges);
    on<HidMacrosCancelChangesEvent>(_cancelChanges);
  }

  Future<void> _load(
    HidMacrosLoadEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    final autoStart = await _repo.getAutoStart();

    await _repo.read();
    final options = await _repo.getStartupOptions();
    final keyboards = await _repo.getKeyboards();
    final keyboard = _repo.getSelectedKeyboard();
    final type = _repo.getSelectedKeyboardType();

    emit(
      HidMacrosState(
        keyboards: keyboards,
        selectedKeyboard: keyboard,
        selectedKeyboardType: type,
        options: options,
        autoStart: autoStart,
        savedKeyboard: keyboard,
        savedKeyboardType: type,
        savedOptions: options,
        savedAutoStart: autoStart,
      ),
    );
  }

  Future<void> _toggleAutoStart(
    HidMacrosToggleAutoStartEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(state.copyWith(autoStart: event.enabled));
  }

  Future<void> _toggleMinimizeToTray(
    HidMacrosToggleMinimizeToTrayEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(
      state.copyWith(
        options: state.options.copyWith(minimizeToTray: event.enabled),
      ),
    );
  }

  Future<void> _toggleStartMinimized(
    HidMacrosToggleStartMinizedEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(
      state.copyWith(
        options: state.options.copyWith(startMinimized: event.enabled),
      ),
    );
  }

  Future<void> _selectKeyboard(
    HidMacrosSelectKeyboardEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(state.copyWith(selectedKeyboard: event.keyboard));
  }

  Future<void> _selectKeyboardType(
    HidMacrosSelectKeyboardTypeEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(state.copyWith(selectedKeyboardType: event.type));
  }

  Future<void> _selectKeyboardTypeAndSave(
    HidMacrosSelectKeyboardTypeAndSaveEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    final updated = state.copyWith(selectedKeyboardType: event.type);

    await _repo.applyChanges(
      selectedKeyboard: updated.selectedKeyboard,
      selectedType: updated.selectedKeyboardType,
      options: updated.options,
      autoStart: updated.autoStart,
    );

    emit(
      updated.copyWith(
        savedKeyboard: updated.selectedKeyboard,
        savedKeyboardType: updated.selectedKeyboardType,
        savedOptions: updated.options,
        savedAutoStart: updated.autoStart,
      ),
    );
  }

  Future<void> _applyChanges(
    HidMacrosApplyChangesEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await _repo.applyChanges(
      selectedKeyboard: state.selectedKeyboard,
      selectedType: state.selectedKeyboardType,
      options: state.options,
      autoStart: state.autoStart,
    );

    emit(
      state.copyWith(
        isLoading: false,
        savedKeyboard: state.selectedKeyboard,
        savedKeyboardType: state.selectedKeyboardType,
        savedOptions: state.options,
        savedAutoStart: state.autoStart,
      ),
    );
  }

  Future<void> _cancelChanges(
    HidMacrosCancelChangesEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedKeyboard: state.savedKeyboard,
        selectedKeyboardType: state.savedKeyboardType,
        options: state.savedOptions,
        autoStart: state.savedAutoStart,
      ),
    );
  }
}
