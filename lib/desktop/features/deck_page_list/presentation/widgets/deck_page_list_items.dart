import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list_tile.dart';

class DeckPageListItems extends StatelessWidget {
  final String currentPageName;
  final List<String> pages;
  final bool isEditing;
  final void Function(String pageName)? onSelectPage;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final void Function(String newPageName)? onStopEditing;

  const DeckPageListItems({
    super.key,
    required this.currentPageName,
    required this.pages,
    this.isEditing = false,
    this.onSelectPage,
    this.onReorder,
    this.onStopEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        itemCount: pages.length,
        onReorder: (int oldIndex, int newIndex) {
          onReorder?.call(oldIndex, newIndex);
        },
        itemBuilder: (BuildContext context, int index) {
          final bool isCurrent = pages[index] == currentPageName;
          return DeckPageListTile(
            key: Key('$index-${pages[index]}'),
            pageName: pages[index],
            isCurrent: isCurrent,
            isEditing: isCurrent ? isEditing : false,
            onSelect: () => onSelectPage?.call(pages[index]),
            onStopEditing: onStopEditing,
          );
        },
      ),
    );
  }
}
