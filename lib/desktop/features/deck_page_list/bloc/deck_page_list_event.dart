part of 'deck_page_list_bloc.dart';

sealed class DeckPageListEvent extends Equatable {
  const DeckPageListEvent();

  @override
  List<Object> get props => <Object>[];
}

class DeckPageListInit extends DeckPageListEvent {}

class DeckPageListAddPage extends DeckPageListEvent {}

class DeckPageListSelectPage extends DeckPageListEvent {
  final String selectPageName;

  const DeckPageListSelectPage(this.selectPageName);
}

class DeckPageListStartEditingPage extends DeckPageListEvent {}

class DeckPageListStopEditingPage extends DeckPageListEvent {
  final String newPageName;

  const DeckPageListStopEditingPage(this.newPageName);
}

class DeckPageListDeletePage extends DeckPageListEvent {}

class DeckPageListReorder extends DeckPageListEvent {
  final int oldIndex;
  final int newIndex;

  const DeckPageListReorder(this.oldIndex, this.newIndex);
}
