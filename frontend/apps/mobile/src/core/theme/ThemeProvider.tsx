import { type ReactNode, useMemo } from 'react';
import { useColorScheme } from 'react-native';
import { PaperProvider } from 'react-native-paper';
import { lightTheme, darkTheme } from './theme';

interface ThemeProviderProps {
  children: ReactNode;
}

export function ThemeProvider({ children }: ThemeProviderProps) {
  const colorScheme = useColorScheme();
  const theme = useMemo(
    () => (colorScheme === 'dark' ? darkTheme : lightTheme),
    [colorScheme]
  );

  return <PaperProvider theme={theme}>{children}</PaperProvider>;
}
