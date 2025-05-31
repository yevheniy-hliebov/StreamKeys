import 'package:flutter/material.dart';
import 'package:streamkeys/common/constants/colors.dart';

class STabTheme {
  const STabTheme._();

  static TabBarTheme get light {
    return const TabBarTheme(
      dividerColor: Colors.transparent,
      dividerHeight: 0,
      labelColor: SColors.primary,
      unselectedLabelColor: SColors.onSurfaceLight,
      tabAlignment: TabAlignment.fill,
      indicatorSize: TabBarIndicatorSize.tab,
    );
  }

  static TabBarTheme get dark {
    return const TabBarTheme(
      dividerColor: Colors.transparent,
      dividerHeight: 0,
      labelColor: SColors.primary,
      unselectedLabelColor: SColors.onSurfaceDark,
      tabAlignment: TabAlignment.fill,
      indicatorSize: TabBarIndicatorSize.tab,
    );
  }
}
