part of 'hid_macros_bloc.dart';

class HidMacrosState extends Equatable {
  const HidMacrosState();

  @override
  List<Object?> get props => [];
}

class HidMacrosLoaded extends HidMacrosState {
  final List<KeyboardDevice> keyboards;
  final KeyboardDevice? selectedKeyboard;
  final KeyboardType? selectedKeyboardType;

  const HidMacrosLoaded({
    required this.keyboards,
    this.selectedKeyboard,
    this.selectedKeyboardType,
  });

  @override
  List<Object?> get props => [
        keyboards,
        selectedKeyboard,
        selectedKeyboardType,
      ];
}

class HidMacrosLoading extends HidMacrosState {
  const HidMacrosLoading();
}

class HidMacrosXmlNotExist extends HidMacrosState {
  const HidMacrosXmlNotExist();
}
