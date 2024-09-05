import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/theme.dart';

class ActionButtonTheme {
  final BuildContext context;

  const ActionButtonTheme({required this.context});

  bool get isLight => STheme.isLight(context);

  BoxDecoration getDecoration({
    bool isPressed = false,
  }) {
    if (isLight) {
      return _getDecoration(
        color: const Color(0xFFF5F5F5),
        borderColor: const Color(0xFF2F2F2F),
        isPressed: isPressed,
      );
    } else {
      return _getDecoration(
        color: const Color(0xFF3E3E3E),
        borderColor: const Color(0xFF3E3E3E),
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
      borderRadius: BorderRadius.circular(5),
    );
  }

  List<BoxShadow> getBoxShadow(bool isPressed) {
    const boxShadow = BoxShadow(
      offset: Offset(2, 2),
      blurRadius: 0,
      color: Colors.black,
    );
    return isPressed ? [] : [boxShadow];
  }
}
