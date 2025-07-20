import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/app_update/data/models/version_info.dart';
import 'package:streamkeys/service_locator.dart';

class UpdateDialog extends StatelessWidget {
  final VersionInfo update;

  const UpdateDialog(this.update, {super.key});

  @override
  Widget build(BuildContext context) {
    final appUpdateService = sl<AppUpdateService>();

    return AlertDialog(
      title: Text('New Version Available (${update.version})'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (update.isPrerelease)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'This is a beta release.',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            Text(update.changelog),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            appUpdateService.setIgnoreVersion(update.version);
            Navigator.of(context).pop();
          },
          child: const Text('Ignore this version'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Remind me later'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await appUpdateService.launchUpdate(update);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }

  static Future<void> showUpdateDialog(BuildContext context, VersionInfo versionInfo) async {
    return showDialog(
      context: context,
      builder: (_) => UpdateDialog(versionInfo),
    );
  }

  static Future<void> showNoUpdatesDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => const AlertDialog(
      title: Text('No Updates'),
      content: Text('You have the latest version.'),
    ),
  );
}
}
