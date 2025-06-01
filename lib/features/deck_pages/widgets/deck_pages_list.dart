import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/deck_pages/bloc/deck_pages_bloc.dart';
import 'package:streamkeys/features/deck_pages/data/models/deck_pages.dart';
import 'package:streamkeys/features/deck_pages/data/models/deck_type_enum.dart';
import 'package:streamkeys/features/deck_pages/widgets/deck_page_list_tile.dart';
import 'package:streamkeys/features/keyboards_deck/bloc/keyboard_map_bloc.dart';

class DeckPagesListWrapper extends StatelessWidget {
  final DeckType deckType;

  const DeckPagesListWrapper({
    super.key,
    required this.deckType,
  });

  @override
  Widget build(BuildContext context) {
    if (deckType == DeckType.keyboard) {
      final bloc = context.read<KeyboardDeckPagesBloc>();
      return BlocBuilder<KeyboardDeckPagesBloc, DeckPagesState>(
        builder: (context, state) {
          if ((state is DeckPagesLoaded || state is DeckPagesEditingName) &&
              state.data != null) {
            _selectPageForMap(context, state);

            return _buildList(bloc, state);
          }
          return const SizedBox();
        },
      );
    } else {
      final bloc = context.read<GridDeckPagesBloc>();
      return BlocBuilder<GridDeckPagesBloc, DeckPagesState>(
        builder: (context, state) {
          if ((state is DeckPagesLoaded || state is DeckPagesEditingName) &&
              state.data != null) {
            // _selectPageForMap(context, state);

            return _buildList(bloc, state);
          }
          return const SizedBox();
        },
      );
    }
  }

  void _selectPageForMap(BuildContext context, DeckPagesState state) {
    if (state is DeckPagesLoaded) {
      context
          .read<KeyboardMapBloc>()
          .add(KeyboardMapSelectPage(state.data!.currentPage));
    }
  }

  Widget _buildList(DeckPagesBloc bloc, DeckPagesState state) {
    return DeckPagesList(
      deckPageData: state.data!,
      onReorder: (oldIndex, newIndex) {
        bloc.add(DeckPagesReorderEvent(oldIndex, newIndex));
      },
      onSelect: (pageName) {
        bloc.add(DeckPagesSelectEvent(pageName));
      },
      onRenamedPage: (newName) {
        bloc.add(DeckPagesRenamedEvent(newName));
      },
      isEditing: state is DeckPagesEditingName,
    );
  }
}

class DeckPagesList extends StatelessWidget {
  final DeckPagesData deckPageData;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(String pageName) onSelect;
  final void Function(String newName) onRenamedPage;
  final bool isEditing;

  const DeckPagesList({
    super.key,
    required this.deckPageData,
    required this.onReorder,
    required this.onSelect,
    required this.onRenamedPage,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        itemCount: deckPageData.orderPages.length,
        onReorder: onReorder,
        itemBuilder: (context, index) {
          final pageName = deckPageData.orderPages[index];
          final isCurrent = deckPageData.currentPage == pageName;
          final currentColor =
              isCurrent ? SColors.primary : SColors.of(context).background;

          return Container(
            key: Key(pageName),
            color: currentColor,
            padding: const EdgeInsets.only(right: 8),
            child: DeckPageListTile(
              pageName: pageName,
              index: index,
              isCurrent: isCurrent,
              isEditing: isEditing,
              onTap: () => onSelect(pageName),
              onRenamedPage: onRenamedPage,
            ),
          );
        },
      ),
    );
  }
}
