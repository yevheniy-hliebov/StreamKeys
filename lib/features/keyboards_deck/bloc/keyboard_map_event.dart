part of 'keyboard_map_bloc.dart';

sealed class KeyboardMapEvent extends Equatable {
  const KeyboardMapEvent();

  @override
  List<Object> get props => [];
}

final class KeyboardMapLoad extends KeyboardMapEvent {}

final class KeyboardMapSelectKey extends KeyboardMapEvent {
  final KeyboardKey keyboardKey;

  const KeyboardMapSelectKey(this.keyboardKey);
}

final class KeyboardMapSelectPage extends KeyboardMapEvent {
  final String pageName;

  const KeyboardMapSelectPage(this.pageName);
}

final class KeyboardMapUpdateKeyData extends KeyboardMapEvent {
  final KeyboardKeyData keyData;

  const KeyboardMapUpdateKeyData(this.keyData);
}
