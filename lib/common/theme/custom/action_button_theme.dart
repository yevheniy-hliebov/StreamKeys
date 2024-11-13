import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class ActionButtonTheme {
  final BuildContext context;

  const ActionButtonTheme({required this.context});

  BorderRadius get borderRadius => BorderRadius.circular(4);
  Color get backgroundColor => SColors.of(context).actionButtonBackground;

  BoxDecoration getDecoration({
    bool isPressed = false,
  }) {
    return BoxDecoration(
      color: SColors.of(context).surface,
      border: Border.all(
        color: SColors.of(context).outline,
        width: 1,
      ),
      boxShadow: getBoxShadow(isPressed),
      borderRadius: BorderRadius.circular(5),
    );
  }

  List<BoxShadow> getBoxShadow(bool isPressed) {
    return isPressed ? [] : [SColors.shadow];
  }
}
