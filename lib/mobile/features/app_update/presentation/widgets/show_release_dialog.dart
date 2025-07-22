import 'package:flutter/material.dart';
import 'package:github_apk_updater/widgets/show_update_dialog.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:streamkeys/core/constants/version.dart';
import 'package:streamkeys/mobile/features/app_update/presentation/screens/update_screen.dart';
import 'package:streamkeys/service_locator.dart';

void showReleaseDialog(BuildContext context, {bool showDialogForce = false}) {
  final appUpdate = sl<AppUpdateService>();

  final ignoredVersion = appUpdate.preferences.loadIgnoredVersion();
  showUpdateDialog(
    context,
    apkUpdater: appUpdate.githubApkUpdater,
    currentVersion: AppVersion.appVersion,
    ignoredVersion: showDialogForce == true ? null : ignoredVersion,
    onUpdate: (releaseInfo) async {
      final dir = await getExternalStorageDirectory();
      final asset = releaseInfo.assets.firstWhere(
        (asset) => asset.fileExtensions == '.apk',
      );
      final filePath = p.join(dir?.path ?? '', asset.name);

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => UpdateScreen(
              releaseInfo: releaseInfo,
              onInit: () {
                appUpdate.githubApkUpdater.apkDownloader.start(
                  asset.browserDownloadUrl,
                  filePath,
                );
              },
              onUpdated: () {
                appUpdate.githubApkUpdater.installApk(filePath);
              },
            ),
          ),
        );
      }
    },
  );
}
