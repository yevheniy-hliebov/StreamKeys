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
  final HidMacrosConfig hidmacrosConfig;

  const HidMacrosLoaded({
    required this.keyboards,
    this.selectedKeyboard,
    this.selectedKeyboardType,
    this.hidmacrosConfig = const HidMacrosConfig(),
  });

  @override
  List<Object?> get props => [
    keyboards,
    selectedKeyboard,
    selectedKeyboardType,
    hidmacrosConfig,
  ];
}

class HidMacrosLoading extends HidMacrosState {}
