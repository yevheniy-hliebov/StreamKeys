import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class ActionButtonTheme {
  final BuildContext context;

  const ActionButtonTheme({required this.context});

  BorderRadius get borderRadius => BorderRadius.circular(4);

  BoxDecoration getDecoration({
    bool isPressed = false,
    bool isSelected = false,
  }) {
    return BoxDecoration(
      // color: SColors.of(context).surface,
      border: Border.all(
        color: isSelected ? SColors.primary : SColors.of(context).outline,
        width: isSelected ? 3 : 1,
      ),
      boxShadow: getBoxShadow(isPressed),
      borderRadius: BorderRadius.circular(5),
    );
  }

  List<BoxShadow> getBoxShadow(bool isPressed) {
    return isPressed ? [] : [SColors.shadow];
  }
}
