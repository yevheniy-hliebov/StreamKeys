import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/theme_mode_switch.dart';
import 'package:streamkeys/core/theme/bloc/theme_mode_bloc.dart';
import 'package:streamkeys/desktop/features/dashboard/presentation/widgets/page_tab.dart';

class SettingsScreen extends StatelessWidget with PageTab {
  const SettingsScreen({super.key});

  @override
  Widget get pageView => this;

  @override
  String get label => 'Settings';

  @override
  IconData get iconData => Icons.settings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BlocBuilder<ThemeModeBloc, ThemeMode>(
            builder: (BuildContext context, ThemeMode themeMode) {
              return ThemeModeSwitch(
                themeMode: themeMode,
                onChanged: (ThemeMode themeMode) {
                  context.read<ThemeModeBloc>().add(ThemeModeChange(themeMode));
                },
              );
            },
          ),
          Text(label),
        ],
      ),
    );
  }
}
