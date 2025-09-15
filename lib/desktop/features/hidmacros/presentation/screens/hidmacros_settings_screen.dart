import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/tabs/page_tab.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/hidmacros/bloc/hidmacros_bloc.dart';
import 'package:streamkeys/desktop/features/hidmacros/presentation/widgets/hid_macros_keyboard_panel.dart';
import 'package:streamkeys/desktop/features/hidmacros/presentation/widgets/hid_macros_left_side.dart';

class HidMacrosSettingsScreen extends StatelessWidget with PageTab {
  const HidMacrosSettingsScreen({super.key});

  @override
  Widget get pageView => this;

  @override
  String get label => 'HID Macros';

  @override
  Widget get icon {
    return SizedBox(
      width: 18,
      height: 18,
      child: Image.asset('assets/action_icons/hidmacros.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HidMacrosBloc, HidMacrosState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HidMacrosLeftSide(
                            autoStart: state.autoStart,
                            startupOptions: state.options,
                            onAutoStartChanged: (value) {
                              context.read<HidMacrosBloc>().add(
                                HidMacrosToggleAutoStartEvent(value),
                              );
                            },
                            onMinimizeChanged: (value) {
                              context.read<HidMacrosBloc>().add(
                                HidMacrosToggleMinimizeToTrayEvent(value),
                              );
                            },
                            onStartMinimizeChanged: (value) {
                              context.read<HidMacrosBloc>().add(
                                HidMacrosToggleStartMinizedEvent(value),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [HidMacrosKeyboardPanel()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Row(
                spacing: Spacing.xs,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: state.hasChanges
                        ? () {
                            context.read<HidMacrosBloc>().add(
                              HidMacrosCancelChangesEvent(),
                            );
                          }
                        : null,
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: state.hasChanges
                        ? () {
                            context.read<HidMacrosBloc>().add(
                              HidMacrosApplyChangesEvent(),
                            );
                          }
                        : null,
                    child: const Text('Apply Changes'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
