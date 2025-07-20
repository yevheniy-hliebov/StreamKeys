import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkeys/desktop/features/app_update/data/services/app_update_preferences.dart';

void main() {
  late SharedPreferences prefs;
  late AppUpdatePreferences updatePrefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    updatePrefs = AppUpdatePreferences(prefs);
  });

  group('AppUpdatePreferences', () {
    test('saveIgnoredVersion stores the version', () async {
      await updatePrefs.saveIgnoredVersion('v1.2.3');
      expect(prefs.getString('ignored_update_version'), 'v1.2.3');
    });

    test('loadIgnoredVersion returns stored version', () async {
      await prefs.setString('ignored_update_version', 'v1.2.3');
      expect(updatePrefs.loadIgnoredVersion(), 'v1.2.3');
    });

    test('clearIgnoredVersion removes the version', () async {
      await prefs.setString('ignored_update_version', 'v1.2.3');
      await updatePrefs.clearIgnoredVersion();
      expect(prefs.getString('ignored_update_version'), isNull);
    });
  });
}
