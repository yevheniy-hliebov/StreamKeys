part of 'hidmacros_bloc.dart';

sealed class HidMacrosEvent extends Equatable {
  const HidMacrosEvent();

  @override
  List<Object> get props => [];
}

class HidMacrosLoadEvent extends HidMacrosEvent {}

class HidMacrosSelectKeyboardEvent extends HidMacrosEvent {
  final KeyboardDevice keyboard;

  const HidMacrosSelectKeyboardEvent(this.keyboard);
}

class HidMacrosSelectKeyboardTypeEvent extends HidMacrosEvent {
  final KeyboardType type;

  const HidMacrosSelectKeyboardTypeEvent(this.type);
}

class HidMacrosSelectKeyboardTypeAndSaveEvent extends HidMacrosEvent {
  final KeyboardType type;

  const HidMacrosSelectKeyboardTypeAndSaveEvent(this.type);
}

class HidMacrosToggleAutoStartEvent extends HidMacrosEvent {
  final bool enabled;

  const HidMacrosToggleAutoStartEvent(this.enabled);
}

class HidMacrosToggleMinimizeToTrayEvent extends HidMacrosEvent {
  final bool enabled;

  const HidMacrosToggleMinimizeToTrayEvent(this.enabled);
}

class HidMacrosToggleStartMinizedEvent extends HidMacrosEvent {
  final bool enabled;

  const HidMacrosToggleStartMinizedEvent(this.enabled);
}

class HidMacrosApplyChangesEvent extends HidMacrosEvent {}

class HidMacrosCancelChangesEvent extends HidMacrosEvent {}
