import 'package:flutter/material.dart';
import 'package:streamkeys/core/app_update/presentation/widgets/update_dialog.dart';
import 'package:streamkeys/core/app_update/presentation/widgets/version_status_menu.dart';
import 'package:streamkeys/service_locator.dart';

class AppVersionStatus extends StatelessWidget {
  final AppUpdateService appUpdateService;

  const AppVersionStatus({super.key, required this.appUpdateService});

  @override
  Widget build(BuildContext context) {
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
        style: TextTheme.of(context).labelSmall,
      ),
    );
  }
}
