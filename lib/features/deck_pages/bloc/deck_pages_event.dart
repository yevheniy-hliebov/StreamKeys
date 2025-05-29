part of 'deck_pages_bloc.dart';

abstract class DeckPagesEvent extends Equatable {
  const DeckPagesEvent();

  @override
  List<Object?> get props => [];
}

class DeckPagesInitEvent extends DeckPagesEvent {
  const DeckPagesInitEvent();
}

class DeckPagesAddEvent extends DeckPagesEvent {
  const DeckPagesAddEvent();
}

class DeckPagesSelectEvent extends DeckPagesEvent {
  final String pageName;

  const DeckPagesSelectEvent(this.pageName);
}

class DeckPagesStartRenameEvent extends DeckPagesEvent {
  const DeckPagesStartRenameEvent();
}

class DeckPagesRenamedEvent extends DeckPagesEvent {
  final String newPageName;

  const DeckPagesRenamedEvent(this.newPageName);
}

class DeckPagesDisableRenameEvent extends DeckPagesEvent {
  const DeckPagesDisableRenameEvent();
}

class DeckPagesDeleteEvent extends DeckPagesEvent {
  const DeckPagesDeleteEvent();
}

class DeckPagesReorderEvent extends DeckPagesEvent {
  final int oldIndex;
  final int newIndex;

  const DeckPagesReorderEvent(this.oldIndex, this.newIndex);
}
