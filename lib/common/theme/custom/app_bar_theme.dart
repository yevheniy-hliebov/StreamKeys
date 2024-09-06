import 'package:flutter/material.dart';

class SAppBarTheme {
  const SAppBarTheme._();

  static AppBarTheme get light {
    return const AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      titleSpacing: 0,
    );
  }

  static AppBarTheme get dark {
    return const AppBarTheme(
      backgroundColor: Color(0xFF333333),
      surfaceTintColor: Color(0xFF333333),
      titleSpacing: 0,
    );
  }
}
