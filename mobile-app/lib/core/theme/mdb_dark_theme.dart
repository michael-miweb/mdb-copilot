import 'package:flutter/material.dart';
import 'package:mdb_copilot/core/theme/mdb_colors.dart';
import 'package:mdb_copilot/core/theme/mdb_tokens.dart';
/// MDB Copilot dark theme — Indigo / Orchidée palette.
///
/// Typography (Inter) is applied at the MaterialApp level via
/// google_fonts to avoid runtime fetching during theme init.
final ThemeData mdbDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: MdbColors.primaryDark,
    secondary: MdbColors.accentDark,
    surface: MdbColors.surfaceDark,
    error: MdbColors.errorDark,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFFE6E1E5),
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: MdbColors.backgroundDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: MdbColors.backgroundDark,
    foregroundColor: Color(0xFFE6E1E5),
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
      borderSide: BorderSide(color: Colors.white.withValues(alpha: .3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MdbTokens.radiusDefault),
      borderSide: const BorderSide(
        color: MdbColors.primaryDark,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MdbTokens.radiusDefault),
      borderSide: const BorderSide(color: MdbColors.errorDark),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MdbTokens.radiusDefault),
      borderSide: const BorderSide(
        color: MdbColors.errorDark,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: MdbTokens.space16,
      vertical: MdbTokens.space12,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
  ),
  cardTheme: CardThemeData(
    color: MdbColors.cardsDark,
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
    indicatorColor: MdbColors.primaryDark.withValues(alpha: .2),
  ),
  navigationRailTheme: NavigationRailThemeData(
    indicatorShape: const StadiumBorder(),
    indicatorColor: MdbColors.primaryDark.withValues(alpha: .2),
  ),
);
