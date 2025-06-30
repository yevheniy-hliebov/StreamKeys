import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/selectable_tile_list.dart';
import 'package:streamkeys/desktop/features/hidmacros/bloc/hidmacros_bloc.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';

class SelectKeyboardType extends StatelessWidget {
  const SelectKeyboardType({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HidMacrosBloc, HidMacrosState>(
      builder: (context, state) {
        if (state is! HidMacrosLoaded) return const SizedBox();

        return SelectableTileList<KeyboardType>(
          title: 'Select a keyboard type',
          items: KeyboardType.values,
          selectedItem: state.selectedKeyboardType,
          getLabel: (type) => type.name,
          onTap: (type) {
            context
                .read<HidMacrosBloc>()
                .add(HidMacrosSelectKeyboardTypeEvent(type));
          },
        );
      },
    );
  }
}
