import 'package:flutter/material.dart';

/// MDB Copilot brand color palette.
///
/// Light theme: Violet / Magenta
/// Dark theme: Indigo / Orchidée
abstract final class MdbColors {
  // --- Light theme ---
  static const primaryLight = Color(0xFF7C4DFF);
  static const accentLight = Color(0xFFF3419F);
  static const surfaceLight = Color(0xFFFAFAFA);
  static const backgroundLight = Color(0xFFFFFFFF);
  static const errorLight = Color(0xFFD32F2F);
  static const successLight = Color(0xFF388E3C);

  // --- Dark theme ---
  static const backgroundDark = Color.fromARGB(255, 30, 35, 52);
  static const cardsDark = Color.fromARGB(255, 44, 48, 73);
  static const accentDark = Color.fromARGB(255, 208, 99, 222);
  static const primaryDark = Color.fromARGB(255, 120, 100, 220);
  static const surfaceDark = Color.fromARGB(255, 38, 42, 62);
  static const errorDark = Color(0xFFEF5350);
  static const successDark = Color(0xFF66BB6A);
}
