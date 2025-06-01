import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';
import 'package:streamkeys/features/keyboards_deck/bloc/keyboard_map_bloc.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key_data.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/key_editor/key_action_sequence_editor.dart';

class KeyEditor extends StatelessWidget {
  const KeyEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: SColors.of(context).surface,
      child: BlocBuilder<KeyboardMapBloc, KeyboardMapState>(
        builder: (context, state) {
          KeyboardKey? selectedKey;
          if (state is KeyboardMapLoaded) {
            selectedKey = state.selectedKey;

            if (selectedKey != null) {
              final keyData = _extractKeyData(selectedKey, state);

              return Row(
                children: [
                  Expanded(child: _KeyInfo(selectedKey: selectedKey)),
                  VerticalDivider(
                    color: SColors.of(context).outlineVariant,
                    thickness: 4,
                    width: 4,
                  ),
                  Expanded(
                    child: _ActionsDropArea(
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
            } else {
              return const _EmptyPlaceholder();
            }
          } else {
            return const _EmptyPlaceholder();
          }
        },
      ),
    );
  }

  KeyboardKeyData _extractKeyData(
    KeyboardKey selectedKey,
    KeyboardMapLoaded state,
  ) {
    return state.keyDataMap[selectedKey.code.toString()] ??
        KeyboardKeyData(code: selectedKey.code, actions: []);
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

class _KeyInfo extends StatelessWidget {
  final KeyboardKey selectedKey;

  const _KeyInfo({required this.selectedKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Bind key: ${selectedKey.name}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ActionsDropArea extends StatelessWidget {
  final KeyboardKeyData keyData;
  final Widget child;

  const _ActionsDropArea({
    required this.keyData,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: DragTarget<BaseAction>(
            onWillAcceptWithDetails: (_) => true,
            onAcceptWithDetails: (details) {
              final action = details.data;
              keyData.actions.add(action.copy());
              context
                  .read<KeyboardMapBloc>()
                  .add(KeyboardMapUpdateKeyData(keyData));
            },
            builder: (context, candidateData, __) {
              final isHighlighted = candidateData.isNotEmpty;
              return Stack(
                children: [
                  child,
                  if (isHighlighted)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: SColors.primaryWithOpacity,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
