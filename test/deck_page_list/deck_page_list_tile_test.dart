import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamkeys/desktop/features/deck_page_list/data/models/deck_page.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list_tile.dart';

void main() {
  final testPage = DeckPage(id: '1', name: 'Page 1');

  group('DeckPageListTile', () {
    testWidgets('shows Text when not editing or not current',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DeckPageListTile(
            page: testPage,
            isCurrent: false,
            isEditing: false,
          ),
        ),
      );

      expect(find.text(testPage.name), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('shows TextFormField when editing and current',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DeckPageListTile(
            page: testPage,
            isCurrent: true,
            isEditing: true,
            onStopEditing: (String newName) {},
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text(testPage.name), findsOneWidget);
    });

    testWidgets('calls onSelect when tapped', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: DeckPageListTile(
            page: testPage,
            onSelect: () {
              tapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      expect(tapped, isTrue);
    });

    testWidgets('calls onStopEditing on form submit',
        (WidgetTester tester) async {
      String? submittedName;
      await tester.pumpWidget(
        MaterialApp(
          home: DeckPageListTile(
            page: testPage,
            isCurrent: true,
            isEditing: true,
            onStopEditing: (String newName) {
              submittedName = newName;
            },
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'New Page');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      expect(submittedName, 'New Page');
    });
  });
}
