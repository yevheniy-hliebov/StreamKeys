import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/desktop/features/deck_page_list/bloc/deck_page_list_bloc.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/repositorires/key_bindings_repository.dart';

part 'key_bindings_event.dart';
part 'key_bindings_state.dart';

class GridKeyBindingsBloc extends KeyBindingsBloc {
  GridKeyBindingsBloc(DeckPageListBloc decPageListkBloc)
      : super(KeyBindingsRepository(DeckType.grid), decPageListkBloc);
}

class KeyboardKeyBindingsBloc extends KeyBindingsBloc {
  KeyboardKeyBindingsBloc(DeckPageListBloc decPageListkBloc)
      : super(KeyBindingsRepository(DeckType.keyboard), decPageListkBloc);
}

class KeyBindingsBloc extends Bloc<KeyBindingsEvent, KeyBindingsState> {
  final DeckPageListBloc decPageListkBloc;
  late final StreamSubscription<DeckPageListState> deckSubscription;

  final KeyBindingsRepository repository;

  late final Completer<void> _initCompleter;
  late KeyBindingPagesMap map;
  late String currentPageId;

  int? currentKeyCode;

  KeyBindingMap get pageMap {
    return Map.from(map[currentPageId] ?? <String, KeyBindingData>{});
  }

  KeyBindingData getKeyBingingData(int? keyCode) {
    final KeyBindingMap map = pageMap;
    if (map.isEmpty) {
      return const KeyBindingData();
    } else {
      return map[keyCode.toString()] ?? const KeyBindingData();
    }
  }

  KeyBindingsBloc(
    this.repository,
    this.decPageListkBloc,
  ) : super(KeyBindingsInitial()) {
    _initCompleter = Completer<void>();

    deckSubscription = decPageListkBloc.stream.listen(
      (DeckPageListState deckState) async {
        if (deckState is DeckPageListLoaded) {
          await _initCompleter.future;
          currentPageId = deckState.currentPageId;
          add(KeyBindingsPageChanged(deckState.currentPageId));
        }
      },
    );

    on<KeyBindingsInit>(_init);
    on<KeyBindingsPageChanged>(_changePage);
    on<KeyBindingsSelectKey>(_selectKey);
    on<KeyBindingsSaveDataOnPage>(_saveKeyBindingDataOnPage);
  }

  Future<void> _init(
    KeyBindingsInit event,
    Emitter<KeyBindingsState> emit,
  ) async {
    final (loadedPageId, loadedMap) = await repository.getKeyMap();
    currentPageId = loadedPageId;
    map = loadedMap;

    _initCompleter.complete();
    emit(KeyBindingsLoaded(pageMap, currentKeyCode));
  }

  void _changePage(
    KeyBindingsPageChanged event,
    Emitter<KeyBindingsState> emit,
  ) {
    currentKeyCode = null;
    emit(KeyBindingsLoaded(pageMap, currentKeyCode));
  }

  void _selectKey(
    KeyBindingsSelectKey event,
    Emitter<KeyBindingsState> emit,
  ) {
    currentKeyCode = event.keyCode;
    emit(KeyBindingsLoaded(pageMap, currentKeyCode));
  }

  void _saveKeyBindingDataOnPage(
    KeyBindingsSaveDataOnPage event,
    Emitter<KeyBindingsState> emit,
  ) async {
    final keyCode = event.keyCode.toString();
    Map<String, KeyBindingData>? pageKeyMap = map[currentPageId];
    pageKeyMap ??= <String, KeyBindingData>{};

    pageKeyMap[keyCode] = event.keyBindingData;

    emit(KeyBindingsLoaded(pageMap, currentKeyCode));

    await repository.saveKeyBindingDataOnPage(
      currentPageId,
      event.keyCode,
      event.keyBindingData,
    );
  }

  @override
  Future<void> close() {
    deckSubscription.cancel();
    return super.close();
  }
}
