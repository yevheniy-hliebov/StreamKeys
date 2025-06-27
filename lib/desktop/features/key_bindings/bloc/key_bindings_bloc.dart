import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/binding_action.dart';
import 'package:streamkeys/desktop/features/deck_page_list/bloc/deck_page_list_bloc.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/repositorires/key_bindings_repository.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/base_key_data.dart';

part 'key_bindings_event.dart';
part 'key_bindings_state.dart';
part 'key_bindings_bloc_variants.dart';
part 'key_bindings_utils.dart';
part 'key_bindings_event_handler.dart';

class KeyBindingsBloc extends Bloc<KeyBindingsEvent, KeyBindingsState>
    with KeyBindingsUtils {
  final KeyBindingsRepository repository;
  final DeckPageListBloc _deckPageListBloc;

  late final Completer<void> _initCompleter;
  late final StreamSubscription<DeckPageListState> _deckSubscription;
  late final KeyBindingsEventHandler _handler;

  BaseKeyData? currentKeyData;

  KeyBindingsBloc(this.repository, DeckPageListBloc deckPageListBloc)
      : _deckPageListBloc = deckPageListBloc,
        super(KeyBindingsInitial()) {
    _initCompleter = Completer<void>();
    _handleDeckSubscription();

    _handler = KeyBindingsEventHandler(repository, this);

    on<KeyBindingsInit>(_handler.onInit);
    on<KeyBindingsPageChanged>(_handler.onPageChanged);
    on<KeyBindingsSelectKey>(_handler.onSelectKey);
    on<KeyBindingsSaveDataOnPage>(_handler.onSaveData);
    on<KeyBindingsAddAction>(_handler.onAddAction);
    on<KeyBindingsUpdateAction>(_handler.onUpdateAction);
    on<KeyBindingsDeleteAction>(_handler.onDeleteAction);
    on<KeyBindingsReorderActions>(_handler.onReorderActions);
    on<KeyBindingsSwapKeys>(_handler.onSwap);
  }

  void completeInit() {
    if (!_initCompleter.isCompleted) {
      _initCompleter.complete();
    }
  }

  void _handleDeckSubscription() {
    _deckSubscription = _deckPageListBloc.stream.listen(
      (DeckPageListState deckState) async {
        if (deckState is DeckPageListLoaded) {
          await _initCompleter.future;
          add(KeyBindingsPageChanged(deckState.currentPageId));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _deckSubscription.cancel();
    return super.close();
  }
}
