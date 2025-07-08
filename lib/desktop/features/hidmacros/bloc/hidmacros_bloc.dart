import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/hidmacros_config.dart';
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
  HidMacrosConfig hidmacrosConfig = const HidMacrosConfig();

  HidMacrosBloc({HidMacrosRepository? repository, HidMacrosService? hidmacros})
      : _repository = repository ?? HidMacrosRepository(),
        _hidmacros = hidmacros ?? sl<HidMacrosService>(),
        super(HidMacrosInitial()) {
    on<HidMacrosLoadEvent>(_load);

    on<HidMacrosToggleAutoStartEvent>(_toogleAutoStart);
    on<HidMacrosToggleMinimizeToTrayEvent>(_toggleMinimizedToTray);
    on<HidMacrosToggleStartMinizedEvent>(_toggleStartMinimized);

    on<HidMacrosSelectKeyboardEvent>(_selectKeyboard);
    on<HidMacrosSelectKeyboardTypeEvent>(_selectKeyboardType);
  }

  Future<void> _load(
    HidMacrosLoadEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(HidMacrosLoading());

    await _repository.init();

    hidmacrosConfig = hidmacrosConfig.copyWith(
      autoStart: _repository.getAutoStart(),
      minimizeToTray: _repository.getMinimizeToTray(),
      startMinimized: _repository.getStartMinimized(),
    );

    keyboards = _repository.getDeviceList();

    selectedKeyboard = _repository.getSelectedKeyboard();
    selectedKeyboardType = _repository.getSelectedKeyboardType();

    _emitLoaded(emit);
  }

  Future<void> _toogleAutoStart(
    HidMacrosToggleAutoStartEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    hidmacrosConfig = hidmacrosConfig.copyWith(autoStart: event.enabled);
    await _repository.saveAutoStart(event.enabled);

    _emitLoaded(emit);
  }

  Future<void> _toggleMinimizedToTray(event, emit) async {
    hidmacrosConfig = hidmacrosConfig.copyWith(minimizeToTray: event.enabled);
    _emitLoaded(emit);
    _hidmacros.restart(
      onBetween: () async => _repository.setMinimizeToTray(event.enabled),
    );
  }

  Future<void> _toggleStartMinimized(event, emit) async {
    hidmacrosConfig = hidmacrosConfig.copyWith(startMinimized: event.enabled);
    _emitLoaded(emit);
    _hidmacros.restart(
      onBetween: () => _repository.setStartMinimized(event.enabled),
    );
  }

  Future<void> _selectKeyboard(
    HidMacrosSelectKeyboardEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(HidMacrosLoading());
    selectedKeyboard = event.keyboard;

    final type = selectedKeyboardType ?? KeyboardType.numpad;

    await _hidmacros.restart(
      onBetween: () => _repository.select(
        keyboard: event.keyboard,
        type: type,
      ),
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

    await _hidmacros.restart(
      onBetween: () => _repository.select(
        keyboard: keyboard,
        type: event.type,
      ),
    );

    _emitLoaded(emit);
  }

  void _emitLoaded(Emitter<HidMacrosState> emit) {
    emit(HidMacrosLoaded(
      keyboards: keyboards,
      selectedKeyboard: selectedKeyboard,
      selectedKeyboardType: selectedKeyboardType,
      hidmacrosConfig: hidmacrosConfig,
    ));
  }
}
