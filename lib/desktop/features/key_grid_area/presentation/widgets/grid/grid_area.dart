import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/for.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_bindings/data/models/key_binding_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/base_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_template.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_drag_wrapper.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_button.dart';

class GridArea extends StatelessWidget {
  final GridTemplate gridTemplate;
  final List<GridKeyData> keyDataList;
  final KeyBindingMap? pageMap;
  final int? currentKeyCode;
  final void Function(BaseKeyData keyData)? onPressedButton;
  final void Function(int firstCode, int secondCode)? onSwapBindingData;

  const GridArea({
    super.key,
    required this.gridTemplate,
    required this.keyDataList,
    this.pageMap,
    this.currentKeyCode,
    this.onPressedButton,
    this.onSwapBindingData,
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
                    KeyDragWrapper(
                      keyCode: keyData.keyCode,
                      width: 60,
                      height: 60,
                      onSwapBindingData: onSwapBindingData,
                      childBuilder: (isHighlighted, feedbackButtonsSize) {
                        return KeyButton(
                          keyData: keyData,
                          keyBindingData: pageMap?[keyData.keyCode.toString()],
                          isSelected: currentKeyCode == keyData.keyCode,
                          isHighlighted: isHighlighted,
                          onPressed: () {
                            onPressedButton?.call(keyData);
                          },
                          width: feedbackButtonsSize ?? 60,
                          height: feedbackButtonsSize ?? 60,
                        );
                      },
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
