part of 'hid_macros_bloc.dart';

class HidMacrosState extends Equatable {
  const HidMacrosState();

  @override
  List<Object?> get props => [];
}

class HidMacrosLoaded extends HidMacrosState {
  final List<KeyboardDevice> keyboards;
  final String selectedKeyboardSystemId;
  final KeyboardType selectedKeyboardType;

  const HidMacrosLoaded({
    required this.keyboards,
    required this.selectedKeyboardSystemId,
    required this.selectedKeyboardType,
  });

  @override
  List<Object?> get props => [
        keyboards,
        selectedKeyboardSystemId,
        selectedKeyboardType,
      ];
}

class HidMacrosLoading extends HidMacrosState {
  const HidMacrosLoading();
}
