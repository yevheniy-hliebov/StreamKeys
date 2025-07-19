import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:streamkeys/common/widgets/helpers/for.dart';
import 'package:streamkeys/core/constants/spacing.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/grid_template.dart';
import 'package:streamkeys/mobile/features/buttons/data/models/button_data.dart';
import 'package:streamkeys/mobile/features/buttons/presentation/widgets/deck_button.dart';

class GridDeck extends StatelessWidget {
  final GridTemplate grid;
  final Map<String, ButtonData> buttons;
  final Future<Uint8List?> Function(String keyCode) getImage;
  final void Function(String keyCode)? onTap;

  const GridDeck({
    super.key,
    required this.grid,
    this.buttons = const {},
    required this.getImage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isPortrait =
          MediaQuery.of(context).orientation == Orientation.portrait;

      final rows = isPortrait ? grid.numberOfColumns : grid.numberOfRows;
      final columns = isPortrait ? grid.numberOfRows : grid.numberOfColumns;

      final spacing = Spacing.keyGrid.btwKey;

      final totalRowGaps = (columns - 1) * spacing;
      final width = (constraints.maxWidth - totalRowGaps) / columns;

      final totalColumnGaps = (rows - 1) * spacing;
      final height =
          ((constraints.maxHeight - totalColumnGaps) / rows) - Spacing.xxs;

      final buttonSize = Size.square(min(width, height));

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            spacing: spacing,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: For.generateChildren(
              rows,
              generator: (rowIndex) => [
                Row(
                  spacing: spacing,
                  children: For.generateChildren(
                    columns,
                    generator: (colIndex) {
                      final itemIndex = rowIndex * columns + colIndex;
                      final keyCode = itemIndex.toString();
                      return [
                        DeckButton(
                          size: buttonSize,
                          keyCode: keyCode,
                          buttonData: buttons[keyCode],
                          getImage: getImage,
                          onTap: onTap,
                        ),
                      ];
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
