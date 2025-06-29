import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/page_tab.dart';
import 'package:streamkeys/common/widgets/theme_mode_switch.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/core/theme/bloc/theme_mode_bloc.dart';

class GeneralSettingsScreen extends StatelessWidget with PageTab {
  const GeneralSettingsScreen({super.key});

  @override
  Widget get pageView => this;

  @override
  String get label => 'General';

  @override
  Widget get icon => const Icon(Icons.settings_applications_sharp, size: 18);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(Spacing.md),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          spacing: Spacing.xs,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ThemeModeBloc, ThemeMode>(
              builder: (context, themeMode) {
                return ListTile(
                  title: const Text(
                    'Theme mode',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Transform.scale(
                    scale: 0.8,
                    child: ThemeModeSwitch(
                      themeMode: themeMode,
                      onChanged: (themeMode) {
                        final bloc = context.read<ThemeModeBloc>();
                        bloc.add(ThemeModeChange(themeMode));
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
