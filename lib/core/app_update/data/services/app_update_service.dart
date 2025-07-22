import 'package:streamkeys/core/constants/version.dart';
import 'package:streamkeys/core/app_update/data/services/app_update_preferences.dart';
import 'package:streamkeys/core/app_update/data/services/windows_updater_launcher.dart';
import 'package:github_apk_updater/github_apk_updater.dart';

class AppUpdateService {
  final AppUpdatePreferences preferences;
  final WindowsUpdaterLauncher windowsUpdaterLauncher;
  final GithubApkUpdater githubApkUpdater;

  const AppUpdateService({
    required this.preferences,
    required this.windowsUpdaterLauncher,
    required this.githubApkUpdater,
  });

  String? getIgnoredVersion() {
    return preferences.loadIgnoredVersion();
  }

  Future<void> setIgnoreVersion(String version) async {
    await preferences.saveIgnoredVersion(version);
  }

  Future<GitHubReleaseInfo?> checkForUpdate() async {
    final currentVersion = getCurrentVersion();
    final currentVersionMode = getCurrentVersionMode();

    final latest = await githubApkUpdater.releaseService.fetchLatestRelease(
      mode: currentVersionMode,
    );

    if (latest == null) {
      return null;
    }

    if (latest.tagName == currentVersion) {
      return null;
    }

    return latest;
  }

  Future<void> launchUpdate(GitHubReleaseInfo update) async {
    await windowsUpdaterLauncher.launch(
      mode: update.prerelease ? AppVersionMode.beta : AppVersionMode.stable,
      version: update.tagName,
    );
  }

  String getCurrentVersion() {
    return AppVersion.appVersion;
  }

  AppVersionMode getCurrentVersionMode() {
    return AppVersion.mode;
  }
}
