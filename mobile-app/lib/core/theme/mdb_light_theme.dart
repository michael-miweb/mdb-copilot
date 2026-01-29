import 'package:flutter/material.dart';
import 'package:mdb_copilot/core/theme/mdb_colors.dart';
import 'package:mdb_copilot/core/theme/mdb_tokens.dart';
/// MDB Copilot light theme — Violet / Magenta palette.
///
/// Typography (Inter) is applied at the MaterialApp level via
/// google_fonts to avoid runtime fetching during theme init.
final ThemeData mdbLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: MdbColors.primaryLight,
    secondary: MdbColors.accentLight,
    surface: MdbColors.surfaceLight,
    error: MdbColors.errorLight,
    onSurface: Color(0xFF1C1B1F),
  ),
  scaffoldBackgroundColor: MdbColors.backgroundLight,
  appBarTheme: const AppBarTheme(
    backgroundColor: MdbColors.backgroundLight,
    foregroundColor: Color(0xFF1C1B1F),
    elevation: MdbTokens.elevationFlat,
    centerTitle: false,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(MdbTokens.minTouchTarget),
      shape: const StadiumBorder(),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(MdbTokens.minTouchTarget),
      shape: const StadiumBorder(),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: const Size(0, MdbTokens.minTouchTarget),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MdbTokens.radiusDefault),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MdbTokens.radiusDefault),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MdbTokens.radiusDefault),
      borderSide: const BorderSide(
        color: MdbColors.primaryLight,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MdbTokens.radiusDefault),
      borderSide: const BorderSide(color: MdbColors.errorLight),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MdbTokens.radiusDefault),
      borderSide: const BorderSide(
        color: MdbColors.errorLight,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: MdbTokens.space16,
      vertical: MdbTokens.space12,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
  ),
  cardTheme: CardThemeData(
    elevation: MdbTokens.elevationFlat,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(MdbTokens.radiusDefault),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(MdbTokens.radiusSmall),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    indicatorShape: const StadiumBorder(),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    indicatorColor: MdbColors.primaryLight.withValues(alpha: .15),
  ),
  navigationRailTheme: NavigationRailThemeData(
    indicatorShape: const StadiumBorder(),
    indicatorColor: MdbColors.primaryLight.withValues(alpha: .15),
  ),
);
