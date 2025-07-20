import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/colors.dart';
import 'package:streamkeys/core/constants/typography.dart';
import 'package:streamkeys/core/app_update/presentation/widgets/update_dialog.dart';
import 'package:streamkeys/service_locator.dart';

class AppVersionTile extends StatelessWidget {
  const AppVersionTile({super.key});

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

    return ListTile(
      onTap: checkUpdateHandler,
      title: const Text(
        'Check For Update',
        style: AppTypography.bodyStrong,
      ),
      trailing: Text(
        appUpdateService.getCurrentVersion(),
        style: AppTypography.captionStrong.copyWith(
          color: AppColors.of(context).onSurface,
        ),
      ),
    );
  }
}
