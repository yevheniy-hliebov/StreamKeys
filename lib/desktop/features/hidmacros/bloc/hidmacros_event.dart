part of 'hidmacros_bloc.dart';

sealed class HidMacrosEvent extends Equatable {
  const HidMacrosEvent();

  @override
  List<Object> get props => [];
}

class HidMacrosLoadKeyboardsEvent extends HidMacrosEvent {}

class HidMacrosSelectKeyboardTypeEvent extends HidMacrosEvent {
  final KeyboardType type;

  const HidMacrosSelectKeyboardTypeEvent(this.type);
}

class HidMacrosSelectKeyboardEvent extends HidMacrosEvent {
  final KeyboardDevice keyboard;

  const HidMacrosSelectKeyboardEvent(this.keyboard);
}

class HidMacrosToggleAutoStartEvent extends HidMacrosEvent {
  final bool enabled;
  
  const HidMacrosToggleAutoStartEvent(this.enabled);
}
