import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/mobile/features/api_connection/presentation/widgets/api_connection_gate.dart';
import 'package:streamkeys/mobile/features/buttons/bloc/buttons_bloc.dart';
import 'package:streamkeys/mobile/features/buttons/presentation/screens/grid_deck_screen.dart';
import 'package:streamkeys/mobile/features/dashboard/presentation/widgets/app_shell.dart';
import 'package:streamkeys/mobile/features/settings/presentation/screens/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  final void Function(BuildContext context)? onInit;

  const DashboardScreen({super.key, this.onInit});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onInit?.call(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = SafeArea(
      child: ApiConnectionGate(
        builder: () {
          context.read<ButtonsBloc>().add(ButtonsLoad());
          return const GridDeckScreen();
        },
      ),
    );

    return AppShell(
      leading: IconButton(
        onPressed: () {
          context.read<ButtonsBloc>().add(ButtonsRefresh());
        },
        icon: const Icon(Icons.refresh),
      ),
      title: 'StreamKeys',
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          icon: const Icon(Icons.settings),
        ),
      ],
      builder: (appShell, isAppBar, isLandscapeLeft) {
        Widget body;

        if (isAppBar) {
          body = content;
        } else {
          body = Row(
            children: [
              if (isLandscapeLeft) appShell,
              content,
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
