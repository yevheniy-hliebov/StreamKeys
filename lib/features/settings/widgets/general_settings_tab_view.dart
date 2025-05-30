import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/features/theme/bloc/theme_mode_bloc.dart';
import 'package:streamkeys/features/theme/widgets/theme_mode_switch.dart';

class GeneralSettingsTabView extends StatelessWidget {
  static const String tabName = 'General';

  const GeneralSettingsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            BlocBuilder<ThemeModeBloc, ThemeMode>(
              builder: (context, themeMode) {
                return ListTile(
                  title: const Text('Theme mode', style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),),
                  trailing: Transform.scale(
                    scale: 0.8,
                    child: ThemeModeSwitch(
                      themeMode: themeMode,
                      onChanged: (themeMode) {
                        final bloc = context.read<ThemeModeBloc>();
                        bloc.add(ThemeModeChangeEvent(themeMode: themeMode));
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
