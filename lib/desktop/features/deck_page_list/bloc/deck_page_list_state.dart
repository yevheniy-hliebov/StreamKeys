part of 'deck_page_list_bloc.dart';

sealed class DeckPageListState extends Equatable {
  const DeckPageListState();

  @override
  List<Object> get props => <Object>[];
}

final class DeckPageListInitial extends DeckPageListState {}

final class DeckPageListLoaded extends DeckPageListState {
  final String currentPageName;
  final List<String> pages;
  final bool isEditing;

  const DeckPageListLoaded({
    required this.currentPageName,
    required this.pages,
    this.isEditing = false,
  });

  @override
  List<Object> get props => <Object>[currentPageName, pages, isEditing];
}

final class DeckPageListLoading extends DeckPageListState {}
