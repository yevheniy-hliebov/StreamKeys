import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/tiles/selectable_tile_list.dart';
import 'package:streamkeys/desktop/features/hidmacros/data/models/keyboard_device.dart';

class SelectKeyboard extends StatelessWidget {
  final List<KeyboardDevice> keyboards;
  final KeyboardDevice? selectedKeyboard;
  final void Function(KeyboardDevice keyboard)? onTap;

  const SelectKeyboard({
    super.key,
    required this.keyboards,
    this.selectedKeyboard,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableTileList<KeyboardDevice>(
      title: 'Select a keyboard',
      items: keyboards,
      selectedItem: selectedKeyboard,
      getLabel: (k) => k.name,
      getTooltip: (k) => k.systemId,
      onTap: onTap,
    );
  }
}
