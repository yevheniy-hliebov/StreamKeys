import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/models/typedefs.dart';
import 'package:streamkeys/features/deck_pages/data/models/deck_pages.dart';
import 'package:streamkeys/features/deck_pages/data/repositories/deck_pages_repository.dart';

part 'deck_pages_event.dart';
part 'deck_pages_state.dart';

class DeckPagesBloc extends Bloc<DeckPagesEvent, DeckPagesState> {
  DeckPagesRepository repo;
  late DeckPagesData deckPagesData;

  DeckPagesBloc(this.repo) : super(const DeckPagesInitial()) {
    on<DeckPagesInitEvent>(_init);
    on<DeckPagesAddEvent>(_addPage);
    on<DeckPagesSelectEvent>(_selectPage);
    on<DeckPagesStartRenameEvent>(_startRenamePage);
    on<DeckPagesRenamedEvent>(_renamePage);
    on<DeckPagesDisableRenameEvent>(_disableRenamePage);
    on<DeckPagesDeleteEvent>(_deletePage);
    on<DeckPagesReorderEvent>(_reorderList);

    add(const DeckPagesInitEvent());
  }

  FutureVoid _init(
    DeckPagesInitEvent event,
    Emitter<DeckPagesState> emit,
  ) async {
    deckPagesData = await repo.getDeckPages();

    emit(DeckPagesLoaded(deckPagesData));
  }

  FutureVoid _addPage(
    DeckPagesAddEvent event,
    Emitter<DeckPagesState> emit,
  ) async {
    String baseName = 'Page';
    String uniquePageName = baseName;
    int counter = 1;

    while (deckPagesData.orderPages.contains(uniquePageName)) {
      uniquePageName = '$baseName $counter';
      counter++;
    }

    deckPagesData.orderPages.add(uniquePageName);
    deckPagesData.currentPage = uniquePageName;

    emit(const DeckPagesInitial());
    emit(DeckPagesLoaded(deckPagesData));
    await _save();
  }

  FutureVoid _selectPage(
    DeckPagesSelectEvent event,
    Emitter<DeckPagesState> emit,
  ) async {
    deckPagesData.currentPage = event.pageName;

    emit(const DeckPagesInitial());
    emit(DeckPagesLoaded(deckPagesData));
    await _save();
  }

  FutureVoid _startRenamePage(
    DeckPagesStartRenameEvent event,
    Emitter<DeckPagesState> emit,
  ) async {
    emit(DeckPagesEditingName(deckPagesData));
  }

  FutureVoid _renamePage(
    DeckPagesRenamedEvent event,
    Emitter<DeckPagesState> emit,
  ) async {
    final index = deckPagesData.orderPages.indexOf(deckPagesData.currentPage);
    deckPagesData.orderPages[index] = event.newPageName;

    deckPagesData.currentPage = event.newPageName;

    emit(DeckPagesLoaded(deckPagesData));
    await _save();
  }

  FutureVoid _disableRenamePage(
    DeckPagesDisableRenameEvent event,
    Emitter<DeckPagesState> emit,
  ) async {
    emit(DeckPagesLoaded(deckPagesData));
  }

  FutureVoid _deletePage(
    DeckPagesDeleteEvent event,
    Emitter<DeckPagesState> emit,
  ) async {
    int index = deckPagesData.orderPages.indexOf(deckPagesData.currentPage);
    if (deckPagesData.orderPages.length > 1) {
      deckPagesData.orderPages.removeAt(index);
      if (index != 0) {
        index--;
      }
      deckPagesData.currentPage = deckPagesData.orderPages[index];
    }

    emit(const DeckPagesInitial());
    emit(DeckPagesLoaded(deckPagesData));
    await _save();
  }

  FutureVoid _reorderList(
    DeckPagesReorderEvent event,
    Emitter<DeckPagesState> emit,
  ) async {
    int newIndex = event.newIndex;
    int oldIndex = event.oldIndex;

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    if (newIndex < 0) {
      newIndex = 0;
    } else if (newIndex > deckPagesData.orderPages.length) {
      newIndex = deckPagesData.orderPages.length;
    }

    final movedItem = deckPagesData.orderPages.removeAt(oldIndex);
    deckPagesData.orderPages.insert(newIndex, movedItem);

    emit(const DeckPagesInitial());
    emit(DeckPagesLoaded(deckPagesData));
    await _save();
  }

  FutureVoid _save() async {
    repo.save(deckPagesData);
  }
}
