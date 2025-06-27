part of 'key_bindings_bloc.dart';

sealed class KeyBindingsState extends Equatable {
  const KeyBindingsState();

  @override
  List<Object?> get props => <Object?>[];
}

final class KeyBindingsInitial extends KeyBindingsState {}

final class KeyBindingsLoaded extends KeyBindingsState {
  final KeyBindingMap map;
  final BaseKeyData? currentKeyData;
  final KeyBindingData? currentKeyBindingData;

  const KeyBindingsLoaded({
    required this.map,
    this.currentKeyData,
    this.currentKeyBindingData,
  });

  @override
  List<Object?> get props =>
      <Object?>[map, currentKeyData, currentKeyBindingData];
}
