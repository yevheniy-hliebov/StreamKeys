import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/hid_macros/data/models/keyboard_device.dart';
import 'package:streamkeys/features/hid_macros/data/repositories/hid_macros_repository.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_type.dart';

part 'hid_macros_event.dart';
part 'hid_macros_state.dart';

class HidMacrosBloc extends Bloc<HidMacrosEvent, HidMacrosState> {
  HidMacrosRepository repo = HidMacrosRepository();

  List<KeyboardDevice> keyboards = [];
  KeyboardDevice? selectedKeyboard;
  KeyboardType? selectedKeyboardType;

  HidMacrosBloc() : super(const HidMacrosLoading()) {
    on<HidMacrosLoadKeyboardsEvent>(_load);
    on<HidMacrosSelectKeyboardEvent>(_selectKeyboard);
    on<HidMacrosSelectKeyboardTypeEvent>(_selectKeyboardType);

    add(const HidMacrosLoadKeyboardsEvent());
  }

  FutureVoid _load(
    HidMacrosLoadKeyboardsEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(const HidMacrosLoading());
    try {
      keyboards = await repo.getDeviceList();
      selectedKeyboard = await repo.getSelectedKeyboard();
      selectedKeyboardType = await repo.getSelectedKeyboardType();

      emit(HidMacrosLoaded(
        keyboards: keyboards,
        selectedKeyboard: selectedKeyboard,
        selectedKeyboardType: selectedKeyboardType,
      ));
    } catch (e) {
      if (e is PathNotFoundException) {
        emit(const HidMacrosXmlNotExist());
      }
    }
  }

  FutureVoid _selectKeyboard(
    HidMacrosSelectKeyboardEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(const HidMacrosLoading());
    selectedKeyboard = event.keyboard;
    await repo.selectKeyboard(event.keyboard);

    emit(HidMacrosLoaded(
      keyboards: keyboards,
      selectedKeyboard: selectedKeyboard,
      selectedKeyboardType: selectedKeyboardType,
    ));
  }

  FutureVoid _selectKeyboardType(
    HidMacrosSelectKeyboardTypeEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(const HidMacrosLoading());
    selectedKeyboardType = event.type;
    if (selectedKeyboard == null) {
      await repo.selectKeyboardType(keyboards[0], event.type);
    } else {
      await repo.selectKeyboardType(selectedKeyboard!, event.type);
    }

    emit(HidMacrosLoaded(
      keyboards: keyboards,
      selectedKeyboard: selectedKeyboard,
      selectedKeyboardType: selectedKeyboardType,
    ));
  }
}
