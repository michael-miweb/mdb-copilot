import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MDB Copilot typography — Inter via Google Fonts on M3 TextTheme.
abstract final class MdbTypography {
  /// Configures the default text style for the app to use Inter.
  ///
  /// Call this once from [MaterialApp] level. In the theme definitions,
  /// we use [fontFamily] instead to avoid runtime fetching issues.
  static TextTheme get textTheme => GoogleFonts.interTextTheme();

  /// The font family string for Inter.
  static String get fontFamily => GoogleFonts.inter().fontFamily ?? 'Inter';
}
