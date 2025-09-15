import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/tiles/selectable_tile_list.dart';
import 'package:streamkeys/desktop/features/key_grid_area/data/models/keyboard_type.dart';

class SelectKeyboardType extends StatelessWidget {
  final KeyboardType? selectedType;
  final void Function(KeyboardType type)? onTap;

  const SelectKeyboardType({super.key, this.selectedType, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SelectableTileList<KeyboardType>(
      title: 'Select a keyboard type',
      items: KeyboardType.values,
      selectedItem: selectedType,
      getLabel: (type) => type.name,
      onTap: onTap,
    );
  }
}
