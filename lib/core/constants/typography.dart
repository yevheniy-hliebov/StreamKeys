import 'package:flutter/material.dart';

/// Defines the standard text styles used throughout the app UI.
class AppTypography {
  /// Smallest text, used for hints, metadata.
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// Smallest text, used for labels.
  static const TextStyle captionStrong = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  /// Default body text.
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  /// Emphasized body text.
  static const TextStyle bodyStrong = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  /// Section or card subtitles.
  static const TextStyle subtitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  /// Page titles or large headers.
  static const TextStyle title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
  );

  /// Prominent titles, used in hero sections.
  static const TextStyle titleLarge = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w500,
  );

  /// Biggest text, typically for logo or splash headers.
  static const TextStyle display = TextStyle(
    fontSize: 68,
    fontWeight: FontWeight.w500,
  );
}
