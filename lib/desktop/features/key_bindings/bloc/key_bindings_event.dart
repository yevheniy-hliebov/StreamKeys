part of 'key_bindings_bloc.dart';

sealed class KeyBindingsEvent extends Equatable {
  const KeyBindingsEvent();

  @override
  List<Object> get props => <Object>[];
}

class KeyBindingInit extends KeyBindingsEvent {}

class KeyBindingPageChanged extends KeyBindingsEvent {
  final String currentPageId;

  const KeyBindingPageChanged(this.currentPageId);
}

class KeyBindingSelectKey extends KeyBindingsEvent {
  final int keyCode;

  const KeyBindingSelectKey(this.keyCode);
}
