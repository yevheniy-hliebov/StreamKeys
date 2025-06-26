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
    emit(KeyBindingsLoaded(bloc.pageMap, bloc.currentKeyData));
  }

  void onPageChanged(
    KeyBindingsPageChanged event,
    Emitter<KeyBindingsState> emit,
  ) {
    bloc.currentKeyData = null;
    bloc.currentPageId = event.currentPageId;
    emit(KeyBindingsLoaded(bloc.pageMap, bloc.currentKeyData));
  }

  void onSelectKey(
    KeyBindingsSelectKey event,
    Emitter<KeyBindingsState> emit,
  ) {
    bloc.currentKeyData = event.keyData;
    emit(KeyBindingsLoaded(bloc.pageMap, bloc.currentKeyData));
  }

  Future<void> onSaveData(
    KeyBindingsSaveDataOnPage event,
    Emitter<KeyBindingsState> emit,
  ) async {
    final pageKeyMap = bloc.getOrCreatePageKeyMap();
    pageKeyMap[event.keyCode.toString()] = event.keyBindingData;

    emit(KeyBindingsLoaded(bloc.pageMap, bloc.currentKeyData));

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
    final keyBindingData = pageKeyMap[event.keyCode.toString()]?.copyWith() ??
        KeyBindingData.create();

    keyBindingData.actions.add(event.action);

    pageKeyMap[event.keyCode.toString()] = keyBindingData;

    emit(KeyBindingsLoaded(bloc.pageMap, bloc.currentKeyData));

    await repository.saveKeyBindingDataOnPage(
      bloc.currentPageId,
      event.keyCode,
      keyBindingData,
    );
  }

  Future<void> onSwap(
    KeyBindingsSwapKeys event,
    Emitter<KeyBindingsState> emit,
  ) async {
    final pageKeyMap = bloc.getOrCreatePageKeyMap();

    final firstData = bloc.getKeyBindingData(event.firstCode);
    final secondData = bloc.getKeyBindingData(event.secondCode);

    pageKeyMap[event.firstCode.toString()] = secondData;
    pageKeyMap[event.secondCode.toString()] = firstData;

    emit(KeyBindingsLoaded(bloc.pageMap, bloc.currentKeyData));

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
}
