import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdb_copilot/core/theme/mdb_colors.dart';
import 'package:mdb_copilot/core/theme/mdb_dark_theme.dart';
import 'package:mdb_copilot/core/theme/mdb_light_theme.dart';
import 'package:mdb_copilot/core/theme/mdb_tokens.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('MDB Light Theme', () {
    test('uses Material 3', () {
      expect(mdbLightTheme.useMaterial3, isTrue);
    });

    test('has Violet primary color', () {
      expect(
        mdbLightTheme.colorScheme.primary,
        equals(MdbColors.primaryLight),
      );
    });

    test('has Magenta secondary color', () {
      expect(
        mdbLightTheme.colorScheme.secondary,
        equals(MdbColors.accentLight),
      );
    });

    test('input decoration uses border-radius 12', () {
      final border = mdbLightTheme.inputDecorationTheme.border;
      expect(border, isA<OutlineInputBorder>());
      final outlineBorder = border! as OutlineInputBorder;
      expect(
        outlineBorder.borderRadius,
        equals(BorderRadius.circular(MdbTokens.radiusDefault)),
      );
    });

    test('floating label behavior is auto', () {
      expect(
        mdbLightTheme.inputDecorationTheme.floatingLabelBehavior,
        equals(FloatingLabelBehavior.auto),
      );
    });

    test('filled button has 48dp min height', () {
      final style = mdbLightTheme.filledButtonTheme.style;
      final minSize = style?.minimumSize?.resolve({});
      expect(minSize?.height, equals(MdbTokens.minTouchTarget));
    });

    test('snackbar uses floating behavior', () {
      expect(
        mdbLightTheme.snackBarTheme.behavior,
        equals(SnackBarBehavior.floating),
      );
    });
  });

  group('MDB Dark Theme', () {
    test('uses Material 3', () {
      expect(mdbDarkTheme.useMaterial3, isTrue);
    });

    test('has Indigo primary color', () {
      expect(
        mdbDarkTheme.colorScheme.primary,
        equals(MdbColors.primaryDark),
      );
    });

    test('has Orchidée secondary color', () {
      expect(
        mdbDarkTheme.colorScheme.secondary,
        equals(MdbColors.accentDark),
      );
    });

    test('scaffold background is dark', () {
      expect(
        mdbDarkTheme.scaffoldBackgroundColor,
        equals(MdbColors.backgroundDark),
      );
    });

    test('card color uses dark cards color', () {
      expect(
        mdbDarkTheme.cardTheme.color,
        equals(MdbColors.cardsDark),
      );
    });
  });

  group('MDB Tokens', () {
    test('min touch target is 48dp', () {
      expect(MdbTokens.minTouchTarget, equals(48.0));
    });

    test('default radius is 12', () {
      expect(MdbTokens.radiusDefault, equals(12.0));
    });
  });
}
