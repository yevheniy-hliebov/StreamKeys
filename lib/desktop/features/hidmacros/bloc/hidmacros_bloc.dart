import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/repositories/hidmacros_repository.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';
import 'package:streamkeys/service_locator.dart';

part 'hidmacros_event.dart';
part 'hidmacros_state.dart';

class HidMacrosBloc extends Bloc<HidMacrosEvent, HidMacrosState> {
  final HidMacrosRepository _repository;
  final HidMacrosService _hidmacros;

  List<KeyboardDevice> keyboards = [];
  KeyboardDevice? selectedKeyboard;
  KeyboardType? selectedKeyboardType;
  bool autoStart = true;

  HidMacrosBloc({HidMacrosRepository? repository, HidMacrosService? hidmacros})
      : _repository = repository ?? HidMacrosRepository(),
        _hidmacros = hidmacros ?? sl<HidMacrosService>(),
        super(HidMacrosInitial()) {
    on<HidMacrosLoadKeyboardsEvent>(_load);
    on<HidMacrosSelectKeyboardEvent>(_selectKeyboard);
    on<HidMacrosSelectKeyboardTypeEvent>(_selectKeyboardType);
    on<HidMacrosToggleAutoStartEvent>(_toogleAutoStart);
  }

  Future<void> _load(
    HidMacrosLoadKeyboardsEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(HidMacrosLoading());

    keyboards = await _repository.getDeviceList();
    selectedKeyboard = _repository.getSelectedKeyboard();
    selectedKeyboardType = _repository.getSelectedKeyboardType();
    autoStart = _repository.getAutoStart();

    _emitLoaded(emit);
  }

  Future<void> _selectKeyboard(
    HidMacrosSelectKeyboardEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(HidMacrosLoading());
    selectedKeyboard = event.keyboard;

    final type = selectedKeyboardType ?? KeyboardType.numpad;
    await _repository.select(
      keyboard: event.keyboard,
      type: type,
      onBeforeSave: _hidmacrosStop,
      onAfterSave: _hidmacros.start,
    );

    _emitLoaded(emit);
  }

  Future<void> _selectKeyboardType(
    HidMacrosSelectKeyboardTypeEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(HidMacrosLoading());
    selectedKeyboardType = event.type;

    final keyboard = selectedKeyboard ?? keyboards[0];
    await _repository.select(
      keyboard: keyboard,
      type: event.type,
      onBeforeSave: _hidmacrosStop,
      onAfterSave: _hidmacrosStart,
    );

    _emitLoaded(emit);
  }

  Future<void> _toogleAutoStart(
      HidMacrosToggleAutoStartEvent event, Emitter<HidMacrosState> emit) async {
    autoStart = event.enabled;
    await _repository.saveAutoStart(event.enabled);

    _emitLoaded(emit);
  }

  Future<void> _hidmacrosStop() async {
    await _hidmacros.stop();
    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> _hidmacrosStart() async {
    if (autoStart) {
      await _hidmacros.start();
    }
  }

  void _emitLoaded(Emitter<HidMacrosState> emit) {
    emit(HidMacrosLoaded(
      keyboards: keyboards,
      selectedKeyboard: selectedKeyboard,
      selectedKeyboardType: selectedKeyboardType,
      autoStart: autoStart,
    ));
  }
}
