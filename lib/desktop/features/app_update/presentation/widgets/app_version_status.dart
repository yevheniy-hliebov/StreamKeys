import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/typography.dart';
import 'package:streamkeys/desktop/features/app_update/presentation/widgets/update_dialog.dart';
import 'package:streamkeys/desktop/features/app_update/presentation/widgets/version_status_menu.dart';
import 'package:streamkeys/service_locator.dart';

class AppVersionStatus extends StatelessWidget {
  const AppVersionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final appUpdateService = sl<AppUpdateService>();

    Future<void> checkUpdateHandler() async {
      final updateVersion = await appUpdateService.checkForUpdate();

      if (updateVersion == null) {
        if (context.mounted) {
          await UpdateDialog.showNoUpdatesDialog(context);
        }
      } else {
        if (context.mounted) {
          await UpdateDialog.showUpdateDialog(context, updateVersion);
        }
      }
    }

    return VersionStatusMenu(
      onCheckUpdate: checkUpdateHandler,
      child: Text(
        appUpdateService.getCurrentVersion(),
        style: AppTypography.captionStrong,
      ),
    );
  }
}
