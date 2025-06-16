import 'package:flutter/material.dart';
import 'package:streamkeys/common/widgets/small_icon_button.dart';

class DeckPageListActions extends StatelessWidget {
  final VoidCallback? onPressedAdd;
  final VoidCallback? onPressedEdit;
  final VoidCallback? onPressedDelete;

  const DeckPageListActions({
    super.key,
    this.onPressedEdit,
    this.onPressedAdd,
    this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SmallIconButton(onPressed: onPressedAdd, icon: Icons.add),
        SmallIconButton(onPressed: onPressedEdit, icon: Icons.edit),
        SmallIconButton(onPressed: onPressedDelete, icon: Icons.delete),
      ],
    );
  }
}
