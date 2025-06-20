import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_page.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list_tile.dart';

class DeckPageListItems extends StatelessWidget {
  final String currentPageId;
  final List<DeckPage> pages;
  final bool isEditing;
  final void Function(String pageId)? onSelectPage;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final void Function(String newPageName)? onStopEditing;

  const DeckPageListItems({
    super.key,
    required this.currentPageId,
    required this.pages,
    this.isEditing = false,
    this.onSelectPage,
    this.onReorder,
    this.onStopEditing,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      itemCount: pages.length,
      onReorder: (int oldIndex, int newIndex) {
        onReorder?.call(oldIndex, newIndex);
      },
      itemBuilder: (BuildContext context, int index) {
        final bool isCurrent = pages[index].id == currentPageId;
        return DeckPageListTile(
          key: Key('$index-${pages[index]}'),
          page: pages[index],
          isCurrent: isCurrent,
          isEditing: isCurrent ? isEditing : false,
          onSelect: () => onSelectPage?.call(pages[index].id),
          trailing: ReorderableDragStartListener(
            index: index,
            child: const Icon(Icons.drag_handle),
          ),
          onStopEditing: onStopEditing,
        );
      },
    );
  }
}
