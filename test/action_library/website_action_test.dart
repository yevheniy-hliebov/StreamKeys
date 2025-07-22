import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/website_action.dart';
import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/utils/url_launcher.dart';

class MockUrlLauncher extends Mock implements UrlLauncher {}

void main() {
  group('WebsiteAction', () {
    test('actionLabel returns name when url is empty', () {
      final action = WebsiteAction(url: '');
      expect(action.label, equals('Open website'));
    });

    test('actionLabel includes URL when not empty', () {
      final action = WebsiteAction(url: 'https://example.com');
      expect(action.label, contains('https://example.com'));
    });

    test('toJson and fromJson are inverse', () {
      final original = WebsiteAction(url: 'https://example.com');
      final json = original.toJson();
      final from = WebsiteAction.fromJson(json);
      expect(from.url, equals(original.url));
      expect(from.type, equals(original.type));
      expect(from.name, equals(original.name));
    });

    test('copy creates a new instance with same values', () {
      final action = WebsiteAction(url: 'https://example.com');
      final copied = action.copy() as WebsiteAction;
      expect(copied.url, equals(action.url));
      expect(copied.id, isNot(equals(action.id))); // бо new id генерується
    });

    testWidgets('form calls onUpdate with updated url', (tester) async {
      WebsiteAction? updatedAction;

      final action = WebsiteAction(url: 'https://old.com');

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: action.form(
                  context,
                  onUpdated: (a) => updatedAction = a as WebsiteAction,
                ),
              );
            },
          ),
        ),
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'https://new.com');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(updatedAction, isNotNull);
      expect(updatedAction!.url, equals('https://new.com'));
    });

    test('execute launches URL if valid and launchable', () async {
      final mockUrlLauncher = MockUrlLauncher();
      final uri = Uri.parse('https://example.com');

      when(() => mockUrlLauncher.canLaunchUrl(uri)).thenAnswer((_) async => true);
      when(() => mockUrlLauncher.launchUrl(uri)).thenAnswer((_) async => true);

      final action = WebsiteAction(
        url: uri.toString(),
        urlLauncher: mockUrlLauncher,
      );

      await action.execute();

      verify(() => mockUrlLauncher.canLaunchUrl(uri)).called(1);
      verify(() => mockUrlLauncher.launchUrl(uri)).called(1);
    });
  });
}
