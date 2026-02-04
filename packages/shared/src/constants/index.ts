// Shared constants for MDB Copilot

/**
 * API configuration
 * Note: BASE_URL should be set via app-specific environment config
 */
export const API_CONFIG = {
  DEFAULT_BASE_URL: 'http://localhost:4080/api',
  TIMEOUT: 30000,
} as const;

/**
 * Design tokens - Light Mode
 */
export const LIGHT_THEME = {
  primary: '#7c4dff', // Violet
  secondary: '#f3419f', // Magenta
  background: '#ffffff',
  surface: '#f5f5f5',
  text: '#212121',
  textSecondary: '#757575',
} as const;

/**
 * Design tokens - Dark Mode
 */
export const DARK_THEME = {
  primary: '#5750d8', // Indigo
  secondary: '#d063de', // Orchidée
  background: '#121212',
  surface: '#1e1e1e',
  text: '#ffffff',
  textSecondary: '#b0b0b0',
} as const;

/**
 * Sync configuration
 */
export const SYNC_CONFIG = {
  DEBOUNCE_MS: 500,
  RETRY_ATTEMPTS: 3,
  RETRY_DELAY_MS: 1000,
} as const;
