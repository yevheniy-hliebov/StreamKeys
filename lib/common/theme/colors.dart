import 'package:flutter/material.dart';

class SColors {
  const SColors._();

  static const Color primary = Color.fromARGB(255, 68, 135, 235);

  static const Color bg = Color(0xFFFFFFFF);
  static const Color bg50 = Color(0xFFF5F5F5);
  static const Color bgInverse = Color(0xFF333333);
  static const Color bgInverse50 = Color(0xFF3E3E3E);

  static const Color text = Color(0xFF2F2F2F);
  static const Color textInverse = Color(0xFFECECEC);

  static const Color icon = Color(0xFF2F2F2F);
  static const Color iconInverse = Color(0xFFECECEC);

  static const Color border = Color(0xFF2F2F2F);
  static const Color border50 = Color(0xFF7E7E7E);
  static const Color borderInverse = Color(0xFFFAFAFA);
  static const Color borderFocused = primary;

  static const Color overlayColor = Color(0xFF9E9E9E);
  static const Color overlayColorInverse = Color(0xFF212121);

  static const BoxShadow shadow = BoxShadow(
    offset: Offset(2, 2),
    blurRadius: 0,
    color: Color(0xFF000000),
  );
}
