import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/services/hidmacros_preferences.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';

void main() {
  late SharedPreferences prefs;
  late HidMacrosPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    preferences = HidMacrosPreferences(prefs);
  });

  group('HidMacrosPreferences', () {
    test('saveSelectedKeyboard / getSelectedKeyboard', () async {
      const keyboard = KeyboardDevice('My Keyboard', 'usb://device-123');
      await preferences.saveKeyboard(keyboard);

      final restored = preferences.getSelectedKeyboard();
      expect(restored, isNotNull);
      expect(restored!.name, 'My Keyboard');
      expect(restored.systemId, 'usb://device-123');
    });

    test('getSelectedKeyboard returns null if data is missing', () {
      final result = preferences.getSelectedKeyboard();
      expect(result, isNull);
    });

    test('saveKeyboardType / getKeyboardType', () async {
      await preferences.saveKeyboardType(KeyboardType.numpad);

      final restored = preferences.getKeyboardType();
      expect(restored, KeyboardType.numpad);
    });

    test('getKeyboardType returns null if unknown or unset', () {
      expect(preferences.getKeyboardType(), isNull);
      prefs.setString('keyboard_type', 'non_existing');
      expect(preferences.getKeyboardType(), isNull);
    });

    test('saveAutoStart / getAutoStart', () async {
      await preferences.saveAutoStart(true);
      expect(preferences.getAutoStart(), isTrue);

      await preferences.saveAutoStart(false);
      expect(preferences.getAutoStart(), isFalse);
    });

    test('getAutoStart returns false if not set', () {
      expect(preferences.getAutoStart(), isFalse);
    });
  });
}
