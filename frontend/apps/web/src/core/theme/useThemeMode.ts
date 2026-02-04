import useMediaQuery from '@mui/material/useMediaQuery';
import type { ColorMode } from '@mdb/shared';

/**
 * Hook to get the current theme mode based on system preferences
 * @returns 'dark' | 'light'
 */
export function useThemeMode(): ColorMode {
  const prefersDarkMode = useMediaQuery('(prefers-color-scheme: dark)');
  return prefersDarkMode ? 'dark' : 'light';
}
