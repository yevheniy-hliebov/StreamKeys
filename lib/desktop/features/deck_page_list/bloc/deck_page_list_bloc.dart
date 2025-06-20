import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_page.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_type.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/repositories/deck_page_list_repository.dart';

part 'deck_page_list_event.dart';
part 'deck_page_list_state.dart';

class GridDeckPageListBloc extends DeckPageListBloc {
  GridDeckPageListBloc() : super(DeckPageListRepository(DeckType.grid));
}

class KeyboardDeckPageListBloc extends DeckPageListBloc {
  KeyboardDeckPageListBloc() : super(DeckPageListRepository(DeckType.keyboard));
}

class DeckPageListBloc extends Bloc<DeckPageListEvent, DeckPageListState> {
  final DeckPageListRepository repository;

  bool isEditing = false;

  DeckPageListBloc(this.repository) : super(DeckPageListInitial()) {
    on<DeckPageListInit>(_init);
    on<DeckPageListAddPage>(_add);
    on<DeckPageListSelectPage>(_select);
    on<DeckPageListDeletePage>(_delete);
    on<DeckPageListStartEditingPage>(_startEditing);
    on<DeckPageListStopEditingPage>(_stopEditing);
    on<DeckPageListReorder>(_reorder);

    add(DeckPageListInit());
  }

  Future<void> _init(
    DeckPageListInit event,
    Emitter<DeckPageListState> emit,
  ) async {
    await repository.init();
    _emitLoaded(emit);
  }

  Future<void> _add(
    DeckPageListAddPage event,
    Emitter<DeckPageListState> emit,
  ) async {
    await repository.addAndSelectPage(
      DeckPage.createWithUniqueName(pages: repository.orderPages),
    );
    _emitLoaded(emit);
  }

  Future<void> _select(
    DeckPageListSelectPage event,
    Emitter<DeckPageListState> emit,
  ) async {
    await repository.selectPage(event.pageId);
    _emitLoaded(emit);
  }

  Future<void> _delete(
    DeckPageListDeletePage event,
    Emitter<DeckPageListState> emit,
  ) async {
    await repository.deletePage(repository.currentPageId);
    _emitLoaded(emit);
  }

  Future<void> _startEditing(
    DeckPageListStartEditingPage event,
    Emitter<DeckPageListState> emit,
  ) async {
    _emitLoaded(emit, isEdit: true);
  }

  Future<void> _stopEditing(
    DeckPageListStopEditingPage event,
    Emitter<DeckPageListState> emit,
  ) async {
    await repository.renameCurrentPage(event.newPageName);
    _emitLoaded(emit);
  }

  Future<void> _reorder(
    DeckPageListReorder event,
    Emitter<DeckPageListState> emit,
  ) async {
    await repository.reorderPages(event.oldIndex, event.newIndex);
    _emitLoaded(emit);
  }

  void _emitLoaded(Emitter<DeckPageListState> emit, {bool isEdit = false}) async {
    isEditing = isEdit;
    emit(DeckPageListLoaded(
      currentPageId: repository.currentPageId,
      pages: repository.orderPages,
      isEditing: isEditing,
    ));
  }
}
