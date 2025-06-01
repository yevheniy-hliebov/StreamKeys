import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/for.dart';
import 'package:streamkeys/features/keyboards_deck/data/models/keyboard_key.dart';
import 'package:streamkeys/features/keyboards_deck/widgets/keyboard_button_wrapper.dart';

class FunctionBlockMap extends StatelessWidget {
  const FunctionBlockMap({
    super.key,
    required this.block,
  });

  final List<List<KeyboardKey>> block;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: For.generateWidgets(
        block[0].length,
        generator: (i) {
          final indexsAfterSpace = [1, 5, 9];
          final row = block[0];
          return [
            if (indexsAfterSpace.contains(i)) ...[
              const SizedBox(width: 54),
            ] else if (i != 0) ...[
              const SizedBox(width: 12),
            ],
            KeyboardButtonWrapper(keyboardKey: row[i]),
          ];
        },
      ),
    );
  }
}
