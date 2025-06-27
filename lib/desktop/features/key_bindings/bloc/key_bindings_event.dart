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

class KeyBindingsAddAction extends KeyBindingsEvent {
  final int keyCode;
  final BindingAction action;

  const KeyBindingsAddAction(this.keyCode, this.action);
}

class KeyBindingsDeleteAction extends KeyBindingsEvent {
  final int keyCode;
  final int index;

  const KeyBindingsDeleteAction(this.keyCode, this.index);
}

class KeyBindingsReorderActions extends KeyBindingsEvent {
  final int keyCode;
  final int oldIndex;
  final int newIndex;

  const KeyBindingsReorderActions({
    required this.keyCode,
    required this.oldIndex,
    required this.newIndex,
  });
}

class KeyBindingsUpdateAction extends KeyBindingsEvent {
  final int keyCode;
  final int index;
  final BindingAction updatedAction;

  const KeyBindingsUpdateAction({
    required this.keyCode,
    required this.index,
    required this.updatedAction,
  });
}

final class KeyBindingsSwapKeys extends KeyBindingsEvent {
  final int firstCode;
  final int secondCode;

  const KeyBindingsSwapKeys(this.firstCode, this.secondCode);

  @override
  List<Object> get props => [firstCode, secondCode];
}
