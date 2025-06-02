import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/constants/colors.dart';
import 'package:streamkeys/features/action_library/data/models/base_action.dart';
import 'package:streamkeys/features/keyboards_deck/bloc/keyboard_map_bloc.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key_data.dart';

class ActionDropZone extends StatelessWidget {
  final KeyboardKeyData keyData;
  final Widget child;

  const ActionDropZone({
    super.key,
    required this.keyData,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<BaseAction>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) {
        keyData.actions.add(details.data.copy());
        context.read<KeyboardMapBloc>().add(KeyboardMapUpdateKeyData(keyData));
      },
      builder: (context, candidateData, _) {
        final isHighlighted = candidateData.isNotEmpty;
        return Stack(
          children: [
            child,
            if (isHighlighted)
              const Positioned.fill(
                child: ColoredBox(color: SColors.primaryWithOpacity),
              ),
          ],
        );
      },
    );
  }
}
