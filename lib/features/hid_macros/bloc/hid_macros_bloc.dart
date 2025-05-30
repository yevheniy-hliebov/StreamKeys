import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/hid_macros/data/models/keyboard_device.dart';
import 'package:streamkeys/features/hid_macros/data/repositories/hid_macros_xml_repository.dart';
import 'package:streamkeys/features/keyboards_deck/models/keyboard_type.dart';

part 'hid_macros_event.dart';
part 'hid_macros_state.dart';

class HidMacrosBloc extends Bloc<HidMacrosEvent, HidMacrosState> {
  HidMacrosRepository repo = HidMacrosRepository();

  List<KeyboardDevice> keyboards = [];
  String selectedKeyboardSystemId = '';
  KeyboardType selectedKeyboardType = KeyboardType.full;

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
    keyboards = await repo.getDeviceList();
    selectedKeyboardSystemId = await repo.getSelectedKeyboard() ?? '';
    selectedKeyboardType = await repo.getSelectedKeyboardType();

    emit(HidMacrosLoaded(
      keyboards: keyboards,
      selectedKeyboardSystemId: selectedKeyboardSystemId,
      selectedKeyboardType: selectedKeyboardType,
    ));
  }

  FutureVoid _selectKeyboard(
    HidMacrosSelectKeyboardEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    selectedKeyboardSystemId = event.systemId;
    await repo.saveSelectedKeyboard(event.systemId);

    emit(HidMacrosLoaded(
      keyboards: keyboards,
      selectedKeyboardSystemId: selectedKeyboardSystemId,
      selectedKeyboardType: selectedKeyboardType,
    ));
  }

  FutureVoid _selectKeyboardType(
    HidMacrosSelectKeyboardTypeEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    selectedKeyboardType = event.type;
    await repo.saveSelectedKeyboardType(event.type);

    emit(HidMacrosLoaded(
      keyboards: keyboards,
      selectedKeyboardSystemId: selectedKeyboardSystemId,
      selectedKeyboardType: selectedKeyboardType,
    ));
  }
}
