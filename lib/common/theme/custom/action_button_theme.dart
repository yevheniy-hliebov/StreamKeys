import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/common/theme/theme.dart';

class ActionButtonTheme {
  final BuildContext context;

  const ActionButtonTheme({required this.context});

  bool get isLight => STheme.isLight(context);

  BorderRadius get borderRadius => BorderRadius.circular(5);

  BoxDecoration getDecoration({
    bool isPressed = false,
  }) {
    if (isLight) {
      return _getDecoration(
        color: SColors.bg50,
        borderColor: SColors.border,
        isPressed: isPressed,
      );
    } else {
      return _getDecoration(
        color: SColors.bgInverse50,
        borderColor: SColors.border,
        isPressed: isPressed,
      );
    }
  }

  BoxDecoration _getDecoration({
    required Color color,
    required Color borderColor,
    bool isPressed = false,
  }) {
    return BoxDecoration(
      color: color,
      border: Border.all(
        color: borderColor,
        width: 1,
      ),
      boxShadow: getBoxShadow(isPressed),
      borderRadius: borderRadius,
    );
  }

  List<BoxShadow> getBoxShadow(bool isPressed) {
    return isPressed ? [] : [SColors.shadow];
  }
}
