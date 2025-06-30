import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/repositories/hidmacros_repository.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';

part 'hidmacros_event.dart';
part 'hidmacros_state.dart';

class HidMacrosBloc extends Bloc<HidMacrosEvent, HidMacrosState> {
  HidMacrosRepository repository = HidMacrosRepository();

  List<KeyboardDevice> keyboards = [];
  KeyboardDevice? selectedKeyboard;
  KeyboardType? selectedKeyboardType;

  HidMacrosBloc() : super(HidMacrosInitial()) {
    on<HidMacrosLoadKeyboardsEvent>(_load);
    on<HidMacrosSelectKeyboardEvent>(_selectKeyboard);
    on<HidMacrosSelectKeyboardTypeEvent>(_selectKeyboardType);
  }

  Future<void> _load(
    HidMacrosLoadKeyboardsEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(HidMacrosLoading());

    keyboards = await repository.getDeviceList();
    selectedKeyboard = await repository.getSelectedKeyboard();
    selectedKeyboardType = await repository.getSelectedKeyboardType();

    emit(HidMacrosLoaded(
      keyboards: keyboards,
      selectedKeyboard: selectedKeyboard,
      selectedKeyboardType: selectedKeyboardType,
    ));
  }

  Future<void> _selectKeyboard(
    HidMacrosSelectKeyboardEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(HidMacrosLoading());
    selectedKeyboard = event.keyboard;
    await repository.selectKeyboard(event.keyboard);

    emit(HidMacrosLoaded(
      keyboards: keyboards,
      selectedKeyboard: selectedKeyboard,
      selectedKeyboardType: selectedKeyboardType,
    ));
  }

  Future<void> _selectKeyboardType(
    HidMacrosSelectKeyboardTypeEvent event,
    Emitter<HidMacrosState> emit,
  ) async {
    emit(HidMacrosLoading());
    selectedKeyboardType = event.type;
    if (selectedKeyboard == null) {
      await repository.selectKeyboardType(keyboard: keyboards[0], type: event.type);
    } else {
      await repository.selectKeyboardType(keyboard: selectedKeyboard!, type: event.type);
    }

    emit(HidMacrosLoaded(
      keyboards: keyboards,
      selectedKeyboard: selectedKeyboard,
      selectedKeyboardType: selectedKeyboardType,
    ));
  }
}
