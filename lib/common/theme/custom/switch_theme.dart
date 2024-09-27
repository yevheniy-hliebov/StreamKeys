import 'package:flutter/material.dart';
import 'package:streamkeys/common/theme/colors.dart';

class SSwitchTheme {
  const SSwitchTheme._();

  static SwitchThemeData get light {
    return SwitchThemeData(
      trackOutlineWidth: const WidgetStatePropertyAll(1),
      trackOutlineColor: const WidgetStatePropertyAll(SColors.border),
      overlayColor: WidgetStatePropertyAll(
        SColors.overlayColor.withOpacity(0.3),
      ),
      thumbColor: const WidgetStatePropertyAll(SColors.bgInverse50),
      trackColor: const WidgetStatePropertyAll(SColors.bg),
    );
  }

  static SwitchThemeData get dark {
    return SwitchThemeData(
      trackOutlineWidth: const WidgetStatePropertyAll(1),
      trackOutlineColor: const WidgetStatePropertyAll(SColors.borderInverse),
      overlayColor: WidgetStatePropertyAll(
        SColors.overlayColor.withOpacity(0.3),
      ),
      thumbColor: const WidgetStatePropertyAll(SColors.bg50),
      trackColor: const WidgetStatePropertyAll(SColors.bgInverse),
    );
  }
}
