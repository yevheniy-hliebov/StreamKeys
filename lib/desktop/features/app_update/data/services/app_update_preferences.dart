import 'package:shared_preferences/shared_preferences.dart';

class AppUpdatePreferences {
  final SharedPreferences prefs;

  static const _ignoredVersionKey = 'ignored_update_version';

  const AppUpdatePreferences(this.prefs);

  Future<void> saveIgnoredVersion(String version) async {
    await prefs.setString(_ignoredVersionKey, version);
  }

  String? loadIgnoredVersion() {
    return prefs.getString(_ignoredVersionKey);
  }

  Future<void> clearIgnoredVersion() async {
    await prefs.remove(_ignoredVersionKey);
  }
}
