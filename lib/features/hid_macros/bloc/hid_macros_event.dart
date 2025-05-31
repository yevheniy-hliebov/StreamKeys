part of 'hid_macros_bloc.dart';

abstract class HidMacrosEvent extends Equatable {
  const HidMacrosEvent();

  @override
  List<Object?> get props => [];
}

class HidMacrosLoadKeyboardsEvent extends HidMacrosEvent {
  const HidMacrosLoadKeyboardsEvent();
}

class HidMacrosSelectKeyboardEvent extends HidMacrosEvent {
  final KeyboardDevice keyboard;

  const HidMacrosSelectKeyboardEvent(this.keyboard);
}

class HidMacrosSelectKeyboardTypeEvent extends HidMacrosEvent {
  final KeyboardType type;

  const HidMacrosSelectKeyboardTypeEvent(this.type);
}
