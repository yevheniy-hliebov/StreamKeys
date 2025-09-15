import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/tiles/checkbox_tile.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/hidmacros_startup_options.dart';
import 'package:streamkeys/desktop/features/hidmacros/presentation/widgets/hid_macros_controls_panel.dart';

class HidMacrosLeftSide extends StatelessWidget {
  final bool autoStart;
  final HidMacrosStartupOptions startupOptions;
  final void Function(bool)? onAutoStartChanged;
  final void Function(bool)? onMinimizeChanged;
  final void Function(bool)? onStartMinimizeChanged;

  const HidMacrosLeftSide({
    super.key,
    this.autoStart = false,
    this.startupOptions = const HidMacrosStartupOptions(),
    this.onAutoStartChanged,
    this.onMinimizeChanged,
    this.onStartMinimizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HidMacrosControlPanel(),
          const SizedBox(height: Spacing.md),
          CheckboxTile(
            label: 'Auto start',
            value: autoStart,
            onChanged: onAutoStartChanged,
          ),
          CheckboxTile(
            label: 'Minimize to tray',
            value: startupOptions.minimizeToTray,
            onChanged: onMinimizeChanged,
          ),
          CheckboxTile(
            label: 'Start minimized',
            value: startupOptions.startMinimized,
            onChanged: onStartMinimizeChanged,
          ),
        ],
      ),
    );
  }
}
