import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class MenuAchorTheme {
  final BuildContext context;

  MenuAchorTheme(this.context);

  static BorderRadius borderRadius = BorderRadius.circular(8.0);
  static Offset alignmentOffset = const Offset(0, 2);

  Color get textColor => SColors.of(context).onSurface;

  ButtonStyle getButtonStyle({
    bool isSelected = false,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
  }) {
    const maximumSize = Size(140, 56);

    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        isSelected ? SColors.of(context).background.withOpacity(0.7) : SColors.of(context).surface,
      ),
      maximumSize: const WidgetStatePropertyAll(maximumSize),
      padding: const WidgetStatePropertyAll(EdgeInsets.all(16)),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  TextStyle get textStyle {
    return TextStyle(
      fontSize: 16,
      height: 24 / 16,
      letterSpacing: 0.5,
      color: textColor,
    );
  }

  MenuStyle get menuStyle {
    return MenuStyle(
      backgroundColor: WidgetStatePropertyAll(
        SColors.of(context).surface,
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
