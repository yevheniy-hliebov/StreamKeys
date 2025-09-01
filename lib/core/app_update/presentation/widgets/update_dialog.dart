import 'package:flutter/material.dart';
import 'package:github_updater/github_updater.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/service_locator.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class UpdateDialog extends StatelessWidget {
  final GitHubReleaseInfo update;

  const UpdateDialog(this.update, {super.key});

  @override
  Widget build(BuildContext context) {
    final appUpdateService = sl<AppUpdateService>();

    return AlertDialog(
      title: Text(
        'New Version Available (${update.tagName})',
        style: TextTheme.of(context).titleMedium,
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (update.prerelease)
                const Padding(
                  padding: EdgeInsets.only(bottom: Spacing.xs),
                  child: Text(
                    'This is a beta release.',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              if (update.body.isNotEmpty)
                Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: Markdown(padding: EdgeInsets.zero, data: update.body),
                ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            appUpdateService.setIgnoreVersion(update.tagName);
            Navigator.of(context).pop();
          },
          child: Text('Ignore this version', style: TextTheme.of(context).bodyMedium),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Remind me later', style: TextTheme.of(context).bodyMedium),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await appUpdateService.launchUpdate(update);
          },
          child: Text('Update', style: TextTheme.of(context).bodyMedium),
        ),
      ],
    );
  }

  static Future<void> showUpdateDialog(
    BuildContext context,
    GitHubReleaseInfo versionInfo,
  ) async {
    return showDialog(
      context: context,
      builder: (_) => UpdateDialog(versionInfo),
    );
  }

  static Future<void> showNoUpdatesDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('No Updates', style: TextTheme.of(context).titleMedium),
        content: Text(
          'You have the latest version.',
          style: TextTheme.of(context).bodyMedium,
        ),
      ),
    );
  }
}
