import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/theme.dart';

// class SColors {
//   const SColors._();

//   static const Color primary = Color(0xFF5B5EFE);

//   static const Color primary = Color(0xFF5B5EFE);

//   // static const Color bg = Color(0xFFFFFFFF);
//   // static const Color bg50 = Color(0xFFF5F5F5);
//   // static const Color bgInverse = Color(0xFF333333);
//   // static const Color bgInverse50 = Color(0xFF3E3E3E);

//   // static const Color text = Color(0xFF2F2F2F);
//   // static const Color textInverse = Color(0xFFECECEC);

//   // static const Color icon = Color(0xFF2F2F2F);
//   // static const Color iconInverse = Color(0xFFECECEC);

//   // static const Color border = Color(0xFF2F2F2F);
//   // static const Color border50 = Color(0xFF7E7E7E);
//   // static const Color borderInverse = Color(0xFFFAFAFA);
//   // static const Color borderFocused = primary;

//   // static const Color overlayColor = Color(0xFF9E9E9E);
//   // static const Color overlayColorInverse = Color(0xFF212121);
// }

class SColors {
  final BuildContext context;

  SColors(this.context);

  static SColors of(BuildContext context) {
    return SColors(context);
  }

  bool get _isLight => STheme.isLight(context);

  static const Color primary = Color(0xFF5B5EFE);
  static const Color overlayLight = Color(0xFF9E9E9E);
  static const Color overlayDark = Color(0xFF212121);
  Color get overlay => _getColor(overlayLight, overlayDark);

  static const Color backgroundLight = Color(0xFFF1F1F1);
  static const Color backgroundDark = Color(0xFF333333);
  Color get background => _getColor(backgroundLight, backgroundDark);

  static const Color onBackgroundLight = Color(0xFF333333);
  static const Color onBackgroundDark = Color(0xFFF1F1F1);
  Color get onBackground => _getColor(onBackgroundLight, onBackgroundDark);

  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF282828);
  Color get surface => _getColor(surfaceLight, surfaceDark);

  static const Color onSurfaceLight = Color(0xFF333333);
  static const Color onSurfaceDark = Color(0xFFF1F1F1);
  Color get onSurface => _getColor(onSurfaceLight, onSurfaceDark);

  static const Color outlineLight = Color(0xFF797979);
  static const Color outlineDark = Color(0xFF202020);
  Color get outline => _getColor(outlineLight, outlineDark);

  static const Color outlineVariantLight = Color(0xFFF1F1F1);
  static const Color outlineVariantDark = Color(0xFF333333);
  Color get outlineVariant =>
      _getColor(outlineVariantLight, outlineVariantDark);

  static const Color actionButtonBackgroundLight = Color(0xFFF5F5F5);
  static const Color actionButtonBackgroundDark = Color(0xFF3E3E3E);
  Color get actionButtonBackground => _getColor(
        actionButtonBackgroundLight,
        actionButtonBackgroundDark,
      );

  static const BoxShadow shadow = BoxShadow(
    offset: Offset(2, 2),
    blurRadius: 0,
    color: Color(0xFF000000),
  );

  Color _getColor(Color lightColor, Color darkColor) {
    if (_isLight) {
      return lightColor;
    } else {
      return darkColor;
    }
  }
}
