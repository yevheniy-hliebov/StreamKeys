import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/for.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_template.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/keybutton/key_button.dart';

class GridArea extends StatelessWidget {
  final GridTemplate gridTemplate;
  final List<GridKeyData> keyDataList;

  const GridArea({
    super.key,
    required this.gridTemplate,
    required this.keyDataList,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Spacing.keyGrid.btwKey,
      children: For.generateChildren(
        gridTemplate.numberOfColumns,
        generator: (int index) {
          return <Widget>[
            Column(
              spacing: Spacing.keyGrid.btwKey,
              children: For.generateChildren(
                gridTemplate.numberOfRows,
                generator: (int colIndex) {
                  final int itemIndex =
                      index * gridTemplate.numberOfRows + colIndex;
                  return <Widget>[
                    KeyButton(
                      keyData: keyDataList[itemIndex],
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
