import { useColorScheme } from 'react-native';
import type { ColorMode } from '@mdb/shared';

/**
 * Hook to get the current theme mode based on system preferences
 * @returns 'dark' | 'light'
 */
export function useThemeMode(): ColorMode {
  const colorScheme = useColorScheme();
  return colorScheme === 'dark' ? 'dark' : 'light';
}
