part of 'key_bindings_bloc.dart';

sealed class KeyBindingsEvent extends Equatable {
  const KeyBindingsEvent();

  @override
  List<Object> get props => <Object>[];
}

class KeyBindingsInit extends KeyBindingsEvent {}

class KeyBindingsPageChanged extends KeyBindingsEvent {
  final String currentPageId;

  const KeyBindingsPageChanged(this.currentPageId);
}

class KeyBindingsSelectKey extends KeyBindingsEvent {
  final int keyCode;

  const KeyBindingsSelectKey(this.keyCode);
}

class KeyBindingsSaveDataOnPage extends KeyBindingsEvent {
  final int keyCode;
  final KeyBindingData keyBindingData;

  const KeyBindingsSaveDataOnPage(this.keyCode, this.keyBindingData);
}
