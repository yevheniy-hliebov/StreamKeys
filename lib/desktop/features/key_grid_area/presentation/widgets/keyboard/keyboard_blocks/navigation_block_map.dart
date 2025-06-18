import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/for.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_button.dart';

class NavigationBlockMap extends StatelessWidget {
  final KeyboardKeyBlock block;

  const NavigationBlockMap({
    super.key,
    required this.block,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: For.generateChildren(
        block.length,
        generator: (int i) {
          final List<KeyboardKeyData> row = block[i];

          return <Widget>[
            if (i == 1) ...<Widget>[
              SizedBox(height: Spacing.keyGrid.btwBlock),
            ] else if (i == 3) ...<Widget>[
              const Spacer(),
            ] else if (i != 0) ...<Widget>[
              SizedBox(height: Spacing.keyGrid.btwKey),
            ],
            Row(
              spacing: Spacing.keyGrid.btwKey,
              children: For.generateChildren(
                row.length,
                generator: (int colIndex) => <Widget>[
                  KeyButton(keyData: row[colIndex]),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}
