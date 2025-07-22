part of 'key_bindings_bloc.dart';

class GridKeyBindingsBloc extends KeyBindingsBloc {
  GridKeyBindingsBloc(DeckPageListBloc decPageListkBloc)
    : super(KeyBindingsRepository(DeckType.grid), decPageListkBloc);
}

class KeyboardKeyBindingsBloc extends KeyBindingsBloc {
  KeyboardKeyBindingsBloc(DeckPageListBloc decPageListkBloc)
    : super(KeyBindingsRepository(DeckType.keyboard), decPageListkBloc);
}
