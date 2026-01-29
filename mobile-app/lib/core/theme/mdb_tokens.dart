/// MDB Copilot design tokens — spacing, radii, elevation.
abstract final class MdbTokens {
  // Spacing scale (dp)
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space48 = 48;

  // Border radius
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;

  /// Standard input / card / button radius.
  static const double radiusDefault = 12;

  // Elevation
  static const double elevationFlat = 0;
  static const double elevationCard = 1;
  static const double elevationModal = 2;

  // Touch targets (WCAG 2.1 AA)
  static const double minTouchTarget = 48;
}
