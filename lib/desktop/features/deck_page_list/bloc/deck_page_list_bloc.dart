import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';

part 'deck_page_list_event.dart';
part 'deck_page_list_state.dart';

class GridDeckPageListBloc extends DeckPageListBloc {
  GridDeckPageListBloc() : super(DeckType.grid);
}

class KeyboardDeckPageListBloc extends DeckPageListBloc {
  KeyboardDeckPageListBloc() : super(DeckType.keyboard);
}

class DeckPageListBloc extends Bloc<DeckPageListEvent, DeckPageListState> {
  final DeckType deckType;

  late String currentPageName;
  late List<String> pages;
  bool isEditing = false;

  DeckPageListBloc(this.deckType) : super(DeckPageListInitial()) {
    on<DeckPageListInit>(_init);
    on<DeckPageListAddPage>(_add);
    on<DeckPageListSelectPage>(_select);
    on<DeckPageListDeletePage>(_delete);
    on<DeckPageListStartEditingPage>(_startEditing);
    on<DeckPageListStopEditingPage>(_stopEditing);
    on<DeckPageListReorder>(_reorder);

    add(DeckPageListInit());
  }

  Future<void> _init(DeckPageListInit event, Emitter<DeckPageListState> emit) async {
    currentPageName = 'Default page';
    pages = <String>[
      'Default page',
    ];
    isEditing = false;

    _emitLoaded(emit);
  }

  Future<void> _add(DeckPageListAddPage event, Emitter<DeckPageListState> emit) async {
    const String baseName = 'Page';
    String uniquePageName = baseName;
    int counter = 1;

    while (pages.contains(uniquePageName)) {
      uniquePageName = '$baseName $counter';
      counter++;
    }

    pages.add(uniquePageName);
    currentPageName = uniquePageName;

    _emitLoaded(emit);
  }

  Future<void> _select(
    DeckPageListSelectPage event,
    Emitter<DeckPageListState> emit,
  ) async {
    currentPageName = event.selectPageName;
    _emitLoaded(emit);
  }

  Future<void> _delete(
    DeckPageListDeletePage event,
    Emitter<DeckPageListState> emit,
  ) async {
    int index = pages.indexOf(currentPageName);
    if (pages.length > 1) {
      pages.removeAt(index);
      if (index != 0) {
        index--;
      }
      currentPageName = pages[index];
    }
    _emitLoaded(emit);
  }

  Future<void> _startEditing(
    DeckPageListStartEditingPage event,
    Emitter<DeckPageListState> emit,
  ) async {
    isEditing = true;
    _emitLoaded(emit);
  }

  Future<void> _stopEditing(
    DeckPageListStopEditingPage event,
    Emitter<DeckPageListState> emit,
  ) async {
    isEditing = false;
    final int index = pages.indexOf(currentPageName);
    pages[index] = event.newPageName;
    currentPageName = event.newPageName;

    _emitLoaded(emit);
  }

  Future<void> _reorder(
    DeckPageListReorder event,
    Emitter<DeckPageListState> emit,
  ) async {
    int newIndex = event.newIndex;
    final int oldIndex = event.oldIndex;

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    if (newIndex < 0) {
      newIndex = 0;
    } else if (newIndex > pages.length) {
      newIndex = pages.length;
    }

    final String movedItem = pages.removeAt(oldIndex);
    pages.insert(newIndex, movedItem);

    _emitLoaded(emit);
  }

  void _emitLoaded(Emitter<DeckPageListState> emit) {
    emit(DeckPageListLoaded(
      currentPageName: currentPageName,
      pages: pages,
      isEditing: isEditing,
    ));
  }
}
