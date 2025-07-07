part of 'hidmacros_bloc.dart';

sealed class HidMacrosState extends Equatable {
  const HidMacrosState();

  @override
  List<Object?> get props => [];
}

final class HidMacrosInitial extends HidMacrosState {}

class HidMacrosLoaded extends HidMacrosState {
  final List<KeyboardDevice> keyboards;
  final KeyboardDevice? selectedKeyboard;
  final KeyboardType? selectedKeyboardType;
  final bool autoStart;

  const HidMacrosLoaded({
    required this.keyboards,
    this.selectedKeyboard,
    this.selectedKeyboardType,
    this.autoStart = false,
  });

  @override
  List<Object?> get props => [
        keyboards,
        selectedKeyboard,
        selectedKeyboardType,
      ];
}

class HidMacrosLoading extends HidMacrosState {}
