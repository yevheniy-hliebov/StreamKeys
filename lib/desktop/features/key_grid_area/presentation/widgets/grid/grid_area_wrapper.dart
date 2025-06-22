import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/desktop/features/key_bindings/bloc/key_bindings_bloc.dart';
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
    return BlocBuilder<GridKeyBindingsBloc, KeyBindingsState>(
      builder: (context, state) {
        final currentKeyCode =
            state is KeyBindingsLoaded ? state.currentKeyCode : null;
        return GridArea(
          gridTemplate: gridTemplate,
          keyDataList: keyDataList,
          pageMap: state is KeyBindingsLoaded ? state.map : {},
          currentKeyCode: currentKeyCode,
          onPressedButton: (keyCode) {
            if (keyCode != currentKeyCode) {
              context
                  .read<GridKeyBindingsBloc>()
                  .add(KeyBindingsSelectKey(keyCode));
            }
          },
        );
      },
    );
  }
}
