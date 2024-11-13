import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class SProgressIndicatorTheme {
  const SProgressIndicatorTheme._();

  static ProgressIndicatorThemeData get light {
    return ProgressIndicatorThemeData(
      color: SColors.primary,
      circularTrackColor: Colors.transparent,
      refreshBackgroundColor: SColors.surfaceLight,
      linearTrackColor: SColors.primary.withOpacity(0.2),
      linearMinHeight: 4,
    );
  }

  static ProgressIndicatorThemeData get dark {
    return ProgressIndicatorThemeData(
      color: SColors.onBackgroundDark,
      circularTrackColor: Colors.transparent,
      refreshBackgroundColor: SColors.surfaceDark,
      linearTrackColor: SColors.primary.withOpacity(0.2),
      linearMinHeight: 4,
    );
  }
}
