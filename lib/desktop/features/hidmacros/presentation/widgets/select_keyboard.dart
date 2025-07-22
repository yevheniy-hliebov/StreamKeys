import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamkeys/common/widgets/tiles/selectable_tile_list.dart';
import 'package:streamkeys/desktop/features/hidmacros/bloc/hidmacros_bloc.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';

class SelectKeyboard extends StatelessWidget {
  const SelectKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HidMacrosBloc, HidMacrosState>(
      builder: (context, state) {
        if (state is! HidMacrosLoaded) return const SizedBox();

        return SelectableTileList<KeyboardDevice>(
          title: 'Select a keyboard',
          items: state.keyboards,
          selectedItem: state.selectedKeyboard,
          getLabel: (k) => k.name,
          getTooltip: (k) => k.systemId,
          onTap: (keyboard) {
            context.read<HidMacrosBloc>().add(
              HidMacrosSelectKeyboardEvent(keyboard),
            );
          },
        );
      },
    );
  }
}
