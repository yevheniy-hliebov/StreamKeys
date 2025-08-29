import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/theme/theme_mode_switch.dart';
import 'package:streamkeys/core/theme/bloc/theme_mode_bloc.dart';

class ThemeSwitchTile extends StatelessWidget {
  const ThemeSwitchTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeBloc, ThemeMode>(
      builder: (context, themeMode) {
        return ListTile(
          title: const Text(
            'Theme mode',
            style: TextStyle(fontWeight: FontWeight.w500),
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
    );
  }
}
