import { createTheme, type Theme, type ThemeOptions } from '@mui/material/styles';
import { colors, borderRadius } from '@mdb/shared';

// Shared component overrides for both themes
const sharedComponents: ThemeOptions['components'] = {
  MuiButton: {
    styleOverrides: {
      root: {
        borderRadius: borderRadius.button,
        textTransform: 'none',
      },
    },
  },
  MuiCard: {
    styleOverrides: {
      root: {
        borderRadius: borderRadius.card,
      },
    },
  },
  MuiTextField: {
    styleOverrides: {
      root: {
        '& .MuiOutlinedInput-root': {
          borderRadius: borderRadius.input,
        },
      },
    },
  },
};

// Shared typography
const sharedTypography: ThemeOptions['typography'] = {
  fontFamily: '"Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
};

// Shared shape
const sharedShape: ThemeOptions['shape'] = {
  borderRadius: borderRadius.input,
};

export const lightTheme: Theme = createTheme({
  palette: {
    mode: 'light',
    primary: {
      main: colors.light.primary,
      contrastText: colors.light.onPrimary,
    },
    secondary: {
      main: colors.light.secondary,
      contrastText: colors.light.onSecondary,
    },
    background: {
      default: colors.light.background,
      paper: colors.light.surface,
    },
    error: {
      main: colors.light.error,
    },
    text: {
      primary: colors.light.onBackground,
      secondary: colors.light.onSurface,
    },
  },
  typography: sharedTypography,
  shape: sharedShape,
  components: sharedComponents,
});

export const darkTheme: Theme = createTheme({
  palette: {
    mode: 'dark',
    primary: {
      main: colors.dark.primary,
      contrastText: colors.dark.onPrimary,
    },
    secondary: {
      main: colors.dark.secondary,
      contrastText: colors.dark.onSecondary,
    },
    background: {
      default: colors.dark.background,
      paper: colors.dark.surface,
    },
    error: {
      main: colors.dark.error,
    },
    text: {
      primary: colors.dark.onBackground,
      secondary: colors.dark.onSurface,
    },
  },
  typography: sharedTypography,
  shape: sharedShape,
  components: sharedComponents,
});
