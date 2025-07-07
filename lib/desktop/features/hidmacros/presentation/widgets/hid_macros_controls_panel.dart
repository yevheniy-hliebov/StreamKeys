import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/checkbox_tile.dart';
import 'package:streamkeys/common/widgets/field_label.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/hidmacros/bloc/hidmacros_bloc.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/hidmacros_config.dart';
import 'package:streamkeys/service_locator.dart';

class HidMacrosControlsPanel extends StatelessWidget {
  const HidMacrosControlsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final hidmacros = sl<HidMacrosService>();

    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.all(Spacing.md),
      child: BlocBuilder<HidMacrosBloc, HidMacrosState>(
        builder: (context, state) {
          final bool isLoaded = state is HidMacrosLoaded;
          final bloc = context.read<HidMacrosBloc>();
          final config = isLoaded ? state.hidmacrosConfig : const HidMacrosConfig();
    
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: FieldLabel('HID Macros')),
              const SizedBox(height: Spacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: hidmacros.start,
                    child: const Text('Start'),
                  ),
                  const SizedBox(width: Spacing.xs),
                  OutlinedButton(
                    onPressed: hidmacros.restart,
                    child: const Text('Restart'),
                  ),
                  const SizedBox(width: Spacing.xs),
                  OutlinedButton(
                    onPressed: hidmacros.stop,
                    child: const Text('Stop'),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.md),
              CheckboxTile(
                label: 'Auto start',
                value: config.autoStart,
                onChanged: (value) {
                  bloc.add(HidMacrosToggleAutoStartEvent(value));
                },
              ),
              CheckboxTile(
                label: 'Minimize to tray',
                value: config.minimizeToTray,
                onChanged: (value) {
                  bloc.add(HidMacrosToggleMinimizeToTrayEvent(value));
                },
              ),
              CheckboxTile(
                label: 'Start minimized',
                value: config.startMinimized,
                onChanged: (value) {
                  bloc.add(HidMacrosToggleStartMinizedEvent(value));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
