import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class SIconButtonTheme {
  const SIconButtonTheme._();

  static IconButtonThemeData get light {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: SColors.icon,
      ),
    );
  }

  static IconButtonThemeData get dark {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: SColors.iconInverse,
      ),
    );
  }
}