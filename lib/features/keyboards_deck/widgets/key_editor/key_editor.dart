import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/keyboards_deck/bloc/keyboard_map_bloc.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key_data.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/key_editor/action_drop_zone.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/key_editor/key_action_sequence_editor.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/key_editor/key_settings_panel.dart';

class KeyEditor extends StatelessWidget {
  const KeyEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: SColors.of(context).surface,
      child: BlocBuilder<KeyboardMapBloc, KeyboardMapState>(
        builder: (context, state) {
          if (state is KeyboardMapLoaded && state.selectedKey != null) {
            final keyData =
                state.keyDataMap[state.selectedKey!.code.toString()]?.copy() ??
                    KeyboardKeyData(code: state.selectedKey!.code, actions: []);

            return Row(
              children: [
                SizedBox(
                  width: 318,
                  child: KeySettingsPanel(
                    selectedKey: state.selectedKey!,
                    initialData: keyData,
                  ),
                ),
                VerticalDivider(
                  color: SColors.of(context).outlineVariant,
                  thickness: 4,
                  width: 4,
                ),
                Expanded(
                  child: ActionDropZone(
                    keyData: keyData,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: KeyActionSequenceEditor(
                        actions: keyData.actions,
                        onActionsChanged: () {
                          context
                              .read<KeyboardMapBloc>()
                              .add(KeyboardMapUpdateKeyData(keyData));
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const _EmptyPlaceholder();
        },
      ),
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Select a button',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      ),
    );
  }
}
