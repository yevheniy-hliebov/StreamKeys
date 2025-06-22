import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/for.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_template.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_button.dart';

class GridArea extends StatelessWidget {
  final GridTemplate gridTemplate;
  final List<GridKeyData> keyDataList;
  final KeyBindingMap? pageMap;
  final int? currentKeyCode;
  final void Function(int keyCode)? onPressedButton;

  const GridArea({
    super.key,
    required this.gridTemplate,
    required this.keyDataList,
    this.pageMap,
    this.currentKeyCode,
    this.onPressedButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Spacing.keyGrid.btwKey,
      children: For.generateChildren(
        gridTemplate.numberOfRows,
        generator: (int index) {
          return <Widget>[
            Row(
              spacing: Spacing.keyGrid.btwKey,
              children: For.generateChildren(
                gridTemplate.numberOfColumns,
                generator: (int colIndex) {
                  final int itemIndex =
                      index * gridTemplate.numberOfColumns + colIndex;
                  final GridKeyData keyData = keyDataList[itemIndex];
                  return <Widget>[
                    KeyButton(
                      keyData: keyData,
                      keyBindingData: pageMap?[keyData.keyCode.toString()],
                      isSelected: currentKeyCode == keyData.keyCode,
                      onPressed: () {
                        onPressedButton?.call(keyData.keyCode);
                      },
                      size: 60,
                    ),
                  ];
                },
              ),
            ),
          ];
        },
      ),
    );
  }
}
