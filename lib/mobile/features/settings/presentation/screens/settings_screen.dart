import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/theme/theme_switch_tile.dart';
import 'package:streamkeys/core/app_update/presentation/widgets/app_version_tile.dart';
import 'package:streamkeys/mobile/features/api_connection/bloc/api_connection_bloc.dart';
import 'package:streamkeys/mobile/features/api_connection/presentation/widgets/api_connection_tile.dart';
import 'package:streamkeys/mobile/features/app_update/presentation/widgets/show_release_dialog.dart';
import 'package:streamkeys/mobile/features/dashboard/presentation/widgets/app_shell.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final content = SafeArea(
      child: Column(
        children: [
          const ThemeSwitchTile(),
          BlocBuilder<ApiConnectionBloc, ApiConnectionState>(
            builder: (context, state) {
              return ApiConnectionTile(
                initialData: state is ApiConnectionLoaded ? state.data : null,
                onUpdated: (data) {
                  context.read<ApiConnectionBloc>().add(
                    ApiConnectionSave(data),
                  );
                },
              );
            },
          ),
          AppVersionTile(
            onTap: () {
              showReleaseDialog(context, showDialogForce: true);
            },
          ),
        ],
      ),
    );

    return AppShell(
      title: 'Settings',
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back),
      ),
      actions: const [SizedBox()],
      builder: (appShell, isAppBar, isLandscapeLeft) {
        Widget body;

        if (isAppBar) {
          body = content;
        } else {
          body = Row(
            children: [
              if (isLandscapeLeft) appShell,
              Flexible(child: content),
              if (!isLandscapeLeft) appShell,
            ],
          );
        }

        return Scaffold(
          appBar: isAppBar ? (appShell as AppBar) : null,
          body: body,
        );
      },
    );
  }
}
