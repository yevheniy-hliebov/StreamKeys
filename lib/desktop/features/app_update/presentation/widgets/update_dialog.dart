import 'package:flutter/material.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/core/constants/typography.dart';
import 'package:streamkeys/desktop/features/app_update/data/models/version_info.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class UpdateDialog extends StatelessWidget {
  final VersionInfo update;

  const UpdateDialog(this.update, {super.key});

  @override
  Widget build(BuildContext context) {
    final appUpdateService = sl<AppUpdateService>();

    return AlertDialog(
      title: Text(
        'New Version Available (${update.version})',
        style: AppTypography.title,
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 500,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (update.isPrerelease)
                const Padding(
                  padding: EdgeInsets.only(bottom: Spacing.xs),
                  child: Text(
                    'This is a beta release.',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              if (update.changelog.isNotEmpty)
                Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: Markdown(
                    padding: EdgeInsets.zero,
                    data: update.changelog,
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            appUpdateService.setIgnoreVersion(update.version);
            Navigator.of(context).pop();
          },
          child: const Text(
            'Ignore this version',
            style: AppTypography.body,
          ),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Remind me later',
            style: AppTypography.body,
          ),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await appUpdateService.launchUpdate(update);
          },
          child: const Text(
            'Update',
            style: AppTypography.body,
          ),
        ),
      ],
    );
  }

  static Future<void> showUpdateDialog(
      BuildContext context, VersionInfo versionInfo) async {
    return showDialog(
      context: context,
      builder: (_) => UpdateDialog(versionInfo),
    );
  }

  static Future<void> showNoUpdatesDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text(
          'No Updates',
          style: AppTypography.title,
        ),
        content: Text(
          'You have the latest version.',
          style: AppTypography.body,
        ),
      ),
    );
  }
}
