part of 'key_bindings_bloc.dart';

class KeyBindingsEventHandler {
  final KeyBindingsRepository repository;
  final KeyBindingsBloc bloc;

  KeyBindingsEventHandler(this.repository, this.bloc);

  Future<void> onInit(
    KeyBindingsInit event,
    Emitter<KeyBindingsState> emit,
  ) async {
    final (loadedPageId, loadedMap) = await repository.getKeyMap();
    bloc.currentPageId = loadedPageId;
    bloc.map = loadedMap;

    bloc.completeInit();
    _emitLoaded(emit);
  }

  void onPageChanged(
    KeyBindingsPageChanged event,
    Emitter<KeyBindingsState> emit,
  ) {
    bloc.currentKeyData = null;
    bloc.currentPageId = event.currentPageId;
    _emitLoaded(emit);
  }

  void onSelectKey(
    KeyBindingsSelectKey event,
    Emitter<KeyBindingsState> emit,
  ) {
    bloc.currentKeyData = event.keyData;
    _emitLoaded(emit);
  }

  Future<void> onSaveData(
    KeyBindingsSaveDataOnPage event,
    Emitter<KeyBindingsState> emit,
  ) async {
    final pageKeyMap = bloc.getOrCreatePageKeyMap();
    pageKeyMap[event.keyCode.toString()] = event.keyBindingData.copyWith();

    _emitLoaded(emit);

    await repository.saveKeyBindingDataOnPage(
      bloc.currentPageId,
      event.keyCode,
      event.keyBindingData,
    );
  }

  Future<void> onAddAction(
    KeyBindingsAddAction event,
    Emitter<KeyBindingsState> emit,
  ) async {
    final pageKeyMap = bloc.getOrCreatePageKeyMap();
    final keyBindingData =
        pageKeyMap[event.keyCode.toString()] ?? KeyBindingData.create();

    final updatedKeyBindingData = keyBindingData.copyWith(
      actions: [...keyBindingData.actions, event.action],
    );

    pageKeyMap[event.keyCode.toString()] = updatedKeyBindingData;

    _emitLoaded(emit);

    await repository.saveKeyBindingDataOnPage(
      bloc.currentPageId,
      event.keyCode,
      updatedKeyBindingData,
    );
  }

  Future<void> onUpdateAction(
    KeyBindingsUpdateAction event,
    Emitter<KeyBindingsState> emit,
  ) async {
    final pageKeyMap = bloc.getOrCreatePageKeyMap();

    final keyBindingData =
        pageKeyMap[event.keyCode.toString()] ?? KeyBindingData.create();

    if (event.index < 0 || event.index >= keyBindingData.actions.length) {
      return;
    }

    final updatedActions = List<BindingAction>.from(keyBindingData.actions);
    updatedActions[event.index] = event.updatedAction;

    final updatedKeyBindingData = keyBindingData.copyWith(
      actions: updatedActions,
    );

    pageKeyMap[event.keyCode.toString()] = updatedKeyBindingData;

    _emitLoaded(emit);

    await repository.saveKeyBindingDataOnPage(
      bloc.currentPageId,
      event.keyCode,
      updatedKeyBindingData,
    );
  }

  Future<void> onDeleteAction(
    KeyBindingsDeleteAction event,
    Emitter<KeyBindingsState> emit,
  ) async {
    final pageKeyMap = bloc.getOrCreatePageKeyMap();

    final keyBindingData =
        pageKeyMap[event.keyCode.toString()] ?? KeyBindingData.create();

    if (event.index < 0 || event.index >= keyBindingData.actions.length) {
      return;
    }

    final updatedActions = List<BindingAction>.from(keyBindingData.actions)
      ..removeAt(event.index);

    final updatedKeyBindingData = keyBindingData.copyWith(
      actions: updatedActions,
    );

    pageKeyMap[event.keyCode.toString()] = updatedKeyBindingData;

    _emitLoaded(emit);

    await repository.saveKeyBindingDataOnPage(
      bloc.currentPageId,
      event.keyCode,
      updatedKeyBindingData,
    );
  }

  Future<void> onReorderActions(
    KeyBindingsReorderActions event,
    Emitter<KeyBindingsState> emit,
  ) async {
    final pageKeyMap = bloc.getOrCreatePageKeyMap();

    final keyBindingData =
        pageKeyMap[event.keyCode.toString()] ?? KeyBindingData.create();

    final actions = List<BindingAction>.from(keyBindingData.actions);

    int newIndex = event.newIndex;
    if (newIndex > event.oldIndex) {
      newIndex -= 1;
    }

    final action = actions.removeAt(event.oldIndex);
    actions.insert(newIndex, action);

    final updatedKeyBindingData = keyBindingData.copyWith(actions: actions);

    pageKeyMap[event.keyCode.toString()] = updatedKeyBindingData;

    _emitLoaded(emit);

    await repository.saveKeyBindingDataOnPage(
      bloc.currentPageId,
      event.keyCode,
      updatedKeyBindingData,
    );
  }

  Future<void> onSwap(
    KeyBindingsSwapKeys event,
    Emitter<KeyBindingsState> emit,
  ) async {
    final pageKeyMap = bloc.getOrCreatePageKeyMap();

    final firstData =
        bloc.getKeyBindingData(event.firstCode) ?? KeyBindingData.create();
    final secondData =
        bloc.getKeyBindingData(event.secondCode) ?? KeyBindingData.create();

    pageKeyMap[event.firstCode.toString()] = secondData;
    pageKeyMap[event.secondCode.toString()] = firstData;

    _emitLoaded(emit);

    await repository.saveKeyBindingDataOnPage(
      bloc.currentPageId,
      event.firstCode,
      secondData,
    );

    await repository.saveKeyBindingDataOnPage(
      bloc.currentPageId,
      event.secondCode,
      firstData,
    );
  }

  _emitLoaded(Emitter<KeyBindingsState> emit) {
    emit(
      KeyBindingsLoaded(
        map: bloc.pageMap,
        currentKeyData: bloc.currentKeyData,
        currentKeyBindingData: bloc.getKeyBindingData(
          bloc.currentKeyData?.keyCode,
        ),
      ),
    );
  }
}
