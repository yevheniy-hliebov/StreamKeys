part of 'key_bindings_bloc.dart';

sealed class KeyBindingsState extends Equatable {
  const KeyBindingsState();
  
  @override
  List<Object?> get props => <Object?>[];
}

final class KeyBindingsInitial extends KeyBindingsState {}

final class KeyBindingsLoaded extends KeyBindingsState {
  final KeyBindingMap? map;
  final int? currentKeyCode;

  const KeyBindingsLoaded(this.map, this.currentKeyCode);

  @override
  List<Object?> get props => <Object?>[map, currentKeyCode];
}
