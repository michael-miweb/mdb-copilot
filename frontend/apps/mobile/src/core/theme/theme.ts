import { MD3LightTheme, MD3DarkTheme, type MD3Theme } from 'react-native-paper';
import { colors, borderRadius } from '@mdb/shared';

export const lightTheme: MD3Theme = {
  ...MD3LightTheme,
  colors: {
    ...MD3LightTheme.colors,
    primary: colors.light.primary,
    onPrimary: colors.light.onPrimary,
    secondary: colors.light.secondary,
    onSecondary: colors.light.onSecondary,
    background: colors.light.background,
    onBackground: colors.light.onBackground,
    surface: colors.light.surface,
    onSurface: colors.light.onSurface,
    error: colors.light.error,
  },
  roundness: borderRadius.input,
};

export const darkTheme: MD3Theme = {
  ...MD3DarkTheme,
  colors: {
    ...MD3DarkTheme.colors,
    primary: colors.dark.primary,
    onPrimary: colors.dark.onPrimary,
    secondary: colors.dark.secondary,
    onSecondary: colors.dark.onSecondary,
    background: colors.dark.background,
    onBackground: colors.dark.onBackground,
    surface: colors.dark.surface,
    onSurface: colors.dark.onSurface,
    error: colors.dark.error,
  },
  roundness: borderRadius.input,
};
