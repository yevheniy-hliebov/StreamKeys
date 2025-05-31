part of 'deck_pages_bloc.dart';

abstract class DeckPagesState extends Equatable {
  final DeckPagesData? data;

  const DeckPagesState([this.data]);

  @override
  List<Object?> get props => [data];
}

class DeckPagesInitial extends DeckPagesState {
  const DeckPagesInitial();
}

class DeckPagesLoaded extends DeckPagesState {
  const DeckPagesLoaded(super.data);
}

class DeckPagesEditingName extends DeckPagesState {
  const DeckPagesEditingName(super.data);
}
