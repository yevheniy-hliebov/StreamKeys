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
  final BaseKeyData keyData;

  const KeyBindingsSelectKey(this.keyData);
}

class KeyBindingsSaveDataOnPage extends KeyBindingsEvent {
  final int keyCode;
  final KeyBindingData keyBindingData;

  const KeyBindingsSaveDataOnPage(this.keyCode, this.keyBindingData);
}

final class KeyBindingsSwapKeys extends KeyBindingsEvent {
  final int firstCode;
  final int secondCode;

  const KeyBindingsSwapKeys(this.firstCode, this.secondCode);

  @override
  List<Object> get props => [firstCode, secondCode];
}
