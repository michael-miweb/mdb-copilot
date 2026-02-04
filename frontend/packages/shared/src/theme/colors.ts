/**
 * MDB Copilot Design Tokens - Colors
 * Centralized color palette for consistent theming across mobile and web
 */

export const colors = {
  light: {
    primary: '#7c4dff', // Violet
    secondary: '#f3419f', // Magenta (accent)
    background: '#ffffff',
    surface: '#f5f5f5',
    error: '#d32f2f',
    onPrimary: '#ffffff',
    onSecondary: '#ffffff',
    onBackground: '#1a1a1a',
    onSurface: '#1a1a1a',
  },
  dark: {
    primary: '#5750d8', // Indigo
    secondary: '#d063de', // Orchidée (accent)
    background: '#1e2334', // rgb(30, 35, 52)
    surface: '#282d3e', // rgb(40, 45, 62)
    error: '#f44336',
    onPrimary: '#ffffff',
    onSecondary: '#ffffff',
    onBackground: '#ffffff',
    onSurface: '#ffffff',
  },
} as const;

export const spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
  xxl: 48,
} as const;

export const borderRadius = {
  pill: 24,
  card: 16,
  input: 12,
  bottomSheet: 24,
  button: 12,
} as const;

export type ColorMode = 'light' | 'dark';
export type Colors = typeof colors;
export type Spacing = typeof spacing;
export type BorderRadius = typeof borderRadius;
