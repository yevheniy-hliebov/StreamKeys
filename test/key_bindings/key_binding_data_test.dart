import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/action_registry.dart';
import 'package:streamkeys/desktop/features/action_library/data/models/library/system/website_action.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';

void main() {
  registerBindingActions();

  group('KeyBindingData', () {
    test('create() generates unique id when not provided', () {
      final data1 = KeyBindingData.create();
      final data2 = KeyBindingData.create();

      expect(data1.id, isNotEmpty);
      expect(data1.id, isNot(data2.id));
    });

    test('copyWith updates fields correctly', () {
      final original = KeyBindingData.create(name: 'Original');
      final updated = original.copyWith(name: 'Updated');

      expect(updated.name, 'Updated');
      expect(updated.id, original.id);
    });

    test('clear() returns empty KeyBindingData with new id', () {
      final original = KeyBindingData.create(name: 'Something');
      final cleared = original.clear();

      expect(cleared.name, '');
      expect(cleared.id, isNot(original.id));
    });

    test('toJson/fromJson roundtrip', () {
      final data = KeyBindingData.create(
        name: 'Test',
        backgroundColor: const Color(0xFFF44336),
        imagePath: 'assets/icon.png',
        actions: [
          WebsiteAction(url: 'https://example.com'),
        ],
      );

      final json = data.toJson();
      final from = KeyBindingData.fromJson(json);

      expect(from.name, data.name);
      expect(from.backgroundColor, data.backgroundColor);
      expect(from.imagePath, data.imagePath);
      expect(from.actions.length, 1);
      expect(from.actions.first, isA<WebsiteAction>());
      expect((from.actions.first as WebsiteAction).url, 'https://example.com');
    });
  });
}
