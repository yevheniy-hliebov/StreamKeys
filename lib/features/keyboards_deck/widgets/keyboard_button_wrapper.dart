import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/features/action_library/bloc/drag_status_bloc.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';
import 'package:streamkeys/features/keyboards_deck/bloc/keyboard_map_bloc.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key_data.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/keyboard_button.dart';

class KeyboardButtonWrapper extends StatelessWidget {
  final KeyboardKey keyboardKey;

  const KeyboardButtonWrapper({
    super.key,
    required this.keyboardKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KeyboardMapBloc, KeyboardMapState>(
      builder: (context, state) {
        if (state is KeyboardMapLoaded) {
          KeyboardKeyData? keyData =
              state.keyDataMap[keyboardKey.code.toString()];
          keyData ??= KeyboardKeyData(code: keyboardKey.code, actions: []);
          final isSelected = state.selectedKey?.code == keyboardKey.code;

          return DragTarget<BaseAction>(
            onAcceptWithDetails: (details) {
              final action = details.data;

              keyData ??= KeyboardKeyData(code: keyboardKey.code, actions: []);
              keyData!.actions.add(action.copy());
              context
                  .read<KeyboardMapBloc>()
                  .add(KeyboardMapUpdateKeyData(keyData!));
            },
            onWillAcceptWithDetails: (details) {
              return true;
            },
            builder: (context, candidateData, __) {
              bool isHighlighted = candidateData.isNotEmpty;

              return LongPressDraggable<KeyboardKeyData>(
                data: keyData,
                onDragStarted: () {
                  context.read<DragStatusBloc>().add(const StartDragEvent());
                },
                onDragEnd: (details) {
                  context.read<DragStatusBloc>().add(const EndDragEvent());
                },
                feedback: Material(
                  child: KeyboardButton(
                    keyboardKey: keyboardKey,
                    keyData: keyData,
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: KeyboardButton(
                    keyboardKey: keyboardKey,
                    keyData: keyData,
                    isSelected: isSelected,
                  ),
                ),
                child: DragTarget<KeyboardKeyData>(
                  onAcceptWithDetails: (details) {
                    keyData ??=
                        KeyboardKeyData(code: keyboardKey.code, actions: []);
                    context.read<KeyboardMapBloc>().add(
                          KeyboardMapSwapKeyData(keyData!, details.data),
                        );
                  },
                  onWillAcceptWithDetails: (details) {
                    return details.data.code != keyboardKey.code;
                  },
                  builder: (context, candidateKeyData, __) {
                    isHighlighted = candidateKeyData.isNotEmpty;

                    return KeyboardButton(
                      keyboardKey: keyboardKey,
                      keyData: keyData,
                      isSelected: isSelected,
                      isDragHighlighted: isHighlighted,
                      onTap: () {
                        context
                            .read<KeyboardMapBloc>()
                            .add(KeyboardMapSelectKey(keyboardKey));
                      },
                    );
                  },
                ),
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
