import 'package:streamkeys/core/constants/version.dart';
import 'package:streamkeys/desktop/features/app_update/data/models/version_info.dart';
import 'package:streamkeys/desktop/features/app_update/data/services/app_update_preferences.dart';
import 'package:streamkeys/desktop/features/app_update/data/services/updater_launcher.dart';
import 'package:streamkeys/desktop/features/app_update/data/services/version_checker.dart';

class AppUpdateService {
  final AppUpdatePreferences preferences;
  final VersionChecker versionChecker;
  final UpdaterLauncher updaterLauncher;

  const AppUpdateService({
    required this.preferences,
    required this.versionChecker,
    required this.updaterLauncher,
  });

  String? getIgnoredVersion() {
    return preferences.loadIgnoredVersion();
  }

  Future<void> setIgnoreVersion(String version) async {
    await preferences.saveIgnoredVersion(version);
  }

  Future<VersionInfo?> checkForUpdate() async {
    final currentVersion = getCurrentVersion();
    final currentVersionMode = getCurrentVersionMode();
    final latest = await versionChecker.fetchLatestVersionInfo(mode: currentVersionMode);

    if (latest == null) {
      return null;
    }

    if (latest.version == currentVersion) {
      return null;
    }

    return latest;
  }

  Future<void> launchUpdate(VersionInfo update) async {
    await updaterLauncher.launch(
      mode: update.isPrerelease ? AppVersionMode.beta : AppVersionMode.stable,
      version: update.version,
    );
  }

  String getCurrentVersion() {
    return AppVersion.appVersion;
  }

  AppVersionMode getCurrentVersionMode() {
    return AppVersion.mode;
  }
}