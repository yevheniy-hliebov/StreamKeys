import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamkeys/desktop/features/deck_page_list/presentation/widgets/deck_page_list_tile.dart';

void main() {
  group('DeckPageListTile', () {
    testWidgets('shows Text when not editing or not current',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DeckPageListTile(
            pageName: 'Page 1',
            isCurrent: false,
            isEditing: false,
          ),
        ),
      );

      expect(find.text('Page 1'), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('shows TextFormField when editing and current',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DeckPageListTile(
            pageName: 'Page 1',
            isCurrent: true,
            isEditing: true,
            onStopEditing: (String newName) {},
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Page 1'), findsOneWidget);
    });

    testWidgets('calls onSelect when tapped', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: DeckPageListTile(
            pageName: 'Page 1',
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
            pageName: 'Page 1',
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
