import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';

class SExpansionTileTheme {
  const SExpansionTileTheme._();

  static ExpansionTileThemeData get light {
    return _buildTheme(
      backgroundColor: SColors.backgroundLight,
      textColor: SColors.onBackgroundLight,
      iconColor: SColors.onBackgroundLight,
      collapsedTextColor: SColors.onBackgroundLight,
      collapsedIconColor: SColors.onBackgroundLight,
      borderColor: SColors.outlineVariantLight,
    );
  }

  static ExpansionTileThemeData get dark {
    return _buildTheme(
      backgroundColor: SColors.backgroundDark,
      textColor: SColors.onBackgroundDark,
      iconColor: SColors.onBackgroundDark,
      collapsedTextColor: SColors.onBackgroundDark,
      collapsedIconColor: SColors.onBackgroundDark,
      borderColor: SColors.outlineVariantDark,
    );
  }

  static ExpansionTileThemeData _buildTheme({
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
    required Color collapsedTextColor,
    required Color collapsedIconColor,
    required Color borderColor,
  }) {
    return ExpansionTileThemeData(
      backgroundColor: backgroundColor,
      textColor: textColor,
      iconColor: iconColor,
      collapsedTextColor: collapsedTextColor,
      collapsedIconColor: collapsedIconColor,
      shape: Border(
        bottom: BorderSide(
          color: borderColor,
          width: 4,
        ),
      ),
      collapsedShape: Border(
        bottom: BorderSide(
          color: borderColor,
          width: 4,
        ),
      ),
    );
  }
}
