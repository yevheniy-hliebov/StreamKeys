import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      int? selectedKeyCode;
      KeyboardKeyData? keyData;
      if (state is KeyboardMapLoaded) {
        selectedKeyCode = state.selectedKey?.code;
        keyData = state.keyDataMap[keyboardKey.code.toString()] ??
            KeyboardKeyData(code: keyboardKey.code, actions: []);
      }

      return DragTarget<BaseAction>(
        onAcceptWithDetails: (details) {
          final action = details.data;

          keyData!.actions.add(action.copy());
          context
              .read<KeyboardMapBloc>()
              .add(KeyboardMapUpdateKeyData(keyData));
        },
        onWillAcceptWithDetails: (details) {
          return true;
        },
        builder: (context, candidateData, __) {
          final isHighlighted = candidateData.isNotEmpty;
          return KeyboardButton(
            keyboardKey: keyboardKey,
            isSelected: selectedKeyCode == keyboardKey.code,
            isDragHighlighted: isHighlighted,
            onTap: () => context.read<KeyboardMapBloc>().add(
                  KeyboardMapSelectKey(keyboardKey),
                ),
          );
        },
      );
    });
  }
}
