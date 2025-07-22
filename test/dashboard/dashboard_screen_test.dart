import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:streamkeys/common/widgets/tabs/page_tab.dart';

import 'page_tab_mock.dart';

void main() {
  testWidgets(
    'DashboardScreen renders and switches between tabs',
    (WidgetTester tester) async {
      final List<PageTab> mockTabs = <PageTab>[
        const PageTabMock(
          label: 'Grid',
          icon: Icon(Icons.grid_view),
        ),
        const PageTabMock(
          label: 'Keyboard',
          icon: Icon(Icons.keyboard),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: DashboardScreen(tabs: mockTabs),
        ),
      );

      expect(find.text('Page: Grid'), findsOneWidget);
      expect(find.text('Page: Keyboard'), findsNothing);

      await tester.tap(find.byType(Tab).last);
      await tester.pumpAndSettle();

      expect(find.text('Page: Grid'), findsNothing);
      expect(find.text('Page: Keyboard'), findsOneWidget);
    },
  );
}
