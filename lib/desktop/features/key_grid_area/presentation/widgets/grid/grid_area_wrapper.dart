import 'package:flutter/material.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_key_data.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_template.dart';
import 'package:streamkeys/desktop/features/key_grid_area/presentation/widgets/grid/grid_area.dart';

class GridAreaWrapper extends StatelessWidget {
  static final GridTemplate gridTemplate = GridTemplate.gridTemplates[2];
  final List<GridKeyData> keyDataList = List<GridKeyData>.generate(
    gridTemplate.totalCells,
    (int index) => GridKeyData(keyCode: index, name: index.toString()),
  );

  GridAreaWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return GridArea(
      gridTemplate: gridTemplate,
      keyDataList: keyDataList,
    );
  }
}

