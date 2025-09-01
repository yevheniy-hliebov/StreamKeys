import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_updater/github_updater.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/mobile/features/app_update/bloc/apk_download_bloc.dart';
import 'package:streamkeys/mobile/features/dashboard/presentation/widgets/app_shell.dart';

class UpdateScreen extends StatefulWidget {
  final GitHubReleaseInfo releaseInfo;
  final void Function()? onInit;
  final void Function()? onUpdated;

  const UpdateScreen({
    super.key,
    required this.releaseInfo,
    this.onInit,
    this.onUpdated,
  });

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  void initState() {
    super.initState();
    widget.onInit?.call();
  }

  @override
  Widget build(BuildContext context) {
    final content = BlocBuilder<ApkDownloadBloc, ApkDownloadState>(
      builder: (context, state) {
        return Center(
          child: Column(
            spacing: Spacing.xs,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Download apk file',
                textAlign: TextAlign.center,
                style: TextTheme.of(context).bodyLarge,
              ),
              Text(
                'Progress: ${state.progress ?? 0}%',
                textAlign: TextAlign.center,
              ),
              if (state.progress == 100) ...[
                FilledButton(
                  onPressed: widget.onUpdated,
                  child: const Text('Install'),
                ),
              ],
            ],
          ),
        );
      },
    );

    return AppShell(
      title: 'Download APK ${widget.releaseInfo.tagName}',
      builder: (appShell, isAppBar, isLandscapeLeft) {
        return Scaffold(
          appBar: isAppBar ? (appShell as AppBar) : null,
          body: content,
        );
      },
    );
  }
}
