import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class SSwitchTheme {
  const SSwitchTheme._();

  static SwitchThemeData get light {
    return SwitchThemeData(
      trackOutlineWidth: const WidgetStatePropertyAll(1),
      trackOutlineColor: const WidgetStatePropertyAll(SColors.outlineLight),
      overlayColor: WidgetStatePropertyAll(
        SColors.overlayLight.withValues(alpha: 0.3),
      ),
      thumbColor: const WidgetStatePropertyAll(SColors.surfaceDark),
      trackColor: const WidgetStatePropertyAll(SColors.backgroundLight),
    );
  }

  static SwitchThemeData get dark {
    return SwitchThemeData(
      trackOutlineWidth: const WidgetStatePropertyAll(1),
      trackOutlineColor: const WidgetStatePropertyAll(SColors.outlineDark),
      overlayColor: WidgetStatePropertyAll(
        SColors.overlayDark.withValues(alpha: 0.3),
      ),
      thumbColor: const WidgetStatePropertyAll(SColors.surfaceLight),
      trackColor: const WidgetStatePropertyAll(SColors.backgroundDark),
    );
  }
}
