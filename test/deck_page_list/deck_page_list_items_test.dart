import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_page.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list_items.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list_tile.dart';

void main() {
  testWidgets('renders correct number of tiles and calls callbacks',
      (WidgetTester tester) async {
    final List<DeckPage> pages = [
      DeckPage(id: '1', name: 'Page1'),
      DeckPage(id: '2', name: 'Page2'),
      DeckPage(id: '3', name: 'Page3'),
    ];

    String? selectedPageId;
    int? reorderedOldIndex;
    int? reorderedNewIndex;
    String? stoppedEditingName;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeckPageListItems(
            currentPageId: '2',
            pages: pages,
            isEditing: true,
            onSelectPage: (String pageId) => selectedPageId = pageId,
            onReorder: (int oldIndex, int newIndex) {
              reorderedOldIndex = oldIndex;
              reorderedNewIndex = newIndex;
            },
            onStopEditing: (String newName) => stoppedEditingName = newName,
          ),
        ),
      ),
    );

    expect(find.byType(DeckPageListTile), findsNWidgets(3));

    final Widget currentTile = tester
        .widgetList(find.byType(DeckPageListTile))
        .firstWhere((widget) => (widget as DeckPageListTile).page.id == '2');
    expect((currentTile as DeckPageListTile).isEditing, isTrue);

    await tester.tap(find.text('Page1'));
    expect(selectedPageId, '1');

    (tester.widget(find.byType(ReorderableListView)) as ReorderableListView)
        .onReorder(0, 2);
    expect(reorderedOldIndex, 0);
    expect(reorderedNewIndex, 2);

    final Finder tileEditingFinder = find.byWidgetPredicate((Widget widget) =>
        widget is DeckPageListTile &&
        widget.page.id == '2' &&
        widget.isEditing);
    final Finder textFieldFinder = find.descendant(
        of: tileEditingFinder, matching: find.byType(TextFormField));
    expect(textFieldFinder, findsOneWidget);

    await tester.enterText(textFieldFinder, 'NewName');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(stoppedEditingName, 'NewName');
  });
}
