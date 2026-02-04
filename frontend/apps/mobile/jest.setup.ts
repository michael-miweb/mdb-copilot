// Mock react-native-safe-area-context
jest.mock('react-native-safe-area-context', () => {
  const inset = { top: 0, right: 0, bottom: 0, left: 0 };
  return {
    SafeAreaProvider: ({ children }: { children: React.ReactNode }) => children,
    SafeAreaView: ({ children }: { children: React.ReactNode }) => children,
    useSafeAreaInsets: () => inset,
    useSafeAreaFrame: () => ({ x: 0, y: 0, width: 390, height: 844 }),
  };
});

// Mock expo-status-bar
jest.mock('expo-status-bar', () => ({
  StatusBar: () => null,
}));

// Mock expo-font
jest.mock('expo-font', () => ({
  useFonts: () => [true, null],
  isLoaded: () => true,
}));

// Mock @expo-google-fonts/inter
jest.mock('@expo-google-fonts/inter', () => ({
  useFonts: () => [true, null],
  Inter_400Regular: 'Inter_400Regular',
  Inter_500Medium: 'Inter_500Medium',
  Inter_600SemiBold: 'Inter_600SemiBold',
  Inter_700Bold: 'Inter_700Bold',
}));

// Mock react-native-paper with full MD3 theme structure
jest.mock('react-native-paper', () => {
  const mockColors = {
    primary: '#6200ee',
    onPrimary: '#ffffff',
    primaryContainer: '#eaddff',
    onPrimaryContainer: '#21005e',
    secondary: '#625b71',
    onSecondary: '#ffffff',
    secondaryContainer: '#e8def8',
    onSecondaryContainer: '#1e192b',
    tertiary: '#7d5260',
    onTertiary: '#ffffff',
    tertiaryContainer: '#ffd8e4',
    onTertiaryContainer: '#31101d',
    error: '#b3261e',
    onError: '#ffffff',
    errorContainer: '#f9dedc',
    onErrorContainer: '#410e0b',
    background: '#fffbfe',
    onBackground: '#1c1b1f',
    surface: '#fffbfe',
    onSurface: '#1c1b1f',
    surfaceVariant: '#e7e0ec',
    onSurfaceVariant: '#49454e',
    outline: '#79747e',
    outlineVariant: '#cac4d0',
    shadow: '#000000',
    scrim: '#000000',
    inverseSurface: '#313033',
    inverseOnSurface: '#f4eff4',
    inversePrimary: '#d0bcff',
    // MD3 surface tones (added for full spec compliance)
    surfaceBright: '#fdf8fd',
    surfaceDim: '#ded8de',
    surfaceContainer: '#f3edf7',
    surfaceContainerHigh: '#ece6f0',
    surfaceContainerHighest: '#e6e0e9',
    surfaceContainerLow: '#f7f2fa',
    surfaceContainerLowest: '#ffffff',
    elevation: {
      level0: 'transparent',
      level1: '#f7f2fa',
      level2: '#f3edf7',
      level3: '#efe9f4',
      level4: '#ece7f3',
      level5: '#e9e4f0',
    },
    surfaceDisabled: 'rgba(28, 27, 31, 0.12)',
    onSurfaceDisabled: 'rgba(28, 27, 31, 0.38)',
    backdrop: 'rgba(50, 47, 55, 0.4)',
  };

  const mockTheme = {
    dark: false,
    version: 3,
    isV3: true,
    mode: 'exact',
    roundness: 4,
    animation: { scale: 1.0 },
    colors: mockColors,
    fonts: {
      displayLarge: { fontFamily: 'System', fontSize: 57, fontWeight: '400', letterSpacing: 0, lineHeight: 64 },
      displayMedium: { fontFamily: 'System', fontSize: 45, fontWeight: '400', letterSpacing: 0, lineHeight: 52 },
      displaySmall: { fontFamily: 'System', fontSize: 36, fontWeight: '400', letterSpacing: 0, lineHeight: 44 },
      headlineLarge: { fontFamily: 'System', fontSize: 32, fontWeight: '400', letterSpacing: 0, lineHeight: 40 },
      headlineMedium: { fontFamily: 'System', fontSize: 28, fontWeight: '400', letterSpacing: 0, lineHeight: 36 },
      headlineSmall: { fontFamily: 'System', fontSize: 24, fontWeight: '400', letterSpacing: 0, lineHeight: 32 },
      titleLarge: { fontFamily: 'System', fontSize: 22, fontWeight: '400', letterSpacing: 0, lineHeight: 28 },
      titleMedium: { fontFamily: 'System', fontSize: 16, fontWeight: '500', letterSpacing: 0.15, lineHeight: 24 },
      titleSmall: { fontFamily: 'System', fontSize: 14, fontWeight: '500', letterSpacing: 0.1, lineHeight: 20 },
      labelLarge: { fontFamily: 'System', fontSize: 14, fontWeight: '500', letterSpacing: 0.1, lineHeight: 20 },
      labelMedium: { fontFamily: 'System', fontSize: 12, fontWeight: '500', letterSpacing: 0.5, lineHeight: 16 },
      labelSmall: { fontFamily: 'System', fontSize: 11, fontWeight: '500', letterSpacing: 0.5, lineHeight: 16 },
      bodyLarge: { fontFamily: 'System', fontSize: 16, fontWeight: '400', letterSpacing: 0.5, lineHeight: 24 },
      bodyMedium: { fontFamily: 'System', fontSize: 14, fontWeight: '400', letterSpacing: 0.25, lineHeight: 20 },
      bodySmall: { fontFamily: 'System', fontSize: 12, fontWeight: '400', letterSpacing: 0.4, lineHeight: 16 },
      default: { fontFamily: 'System', fontWeight: '400', letterSpacing: 0 },
    },
  };

  const mockDarkColors = {
    ...mockColors,
    background: '#1c1b1f',
    onBackground: '#e6e1e5',
    surface: '#1c1b1f',
    onSurface: '#e6e1e5',
    // MD3 dark surface tones
    surfaceBright: '#3b383e',
    surfaceDim: '#141316',
    surfaceContainer: '#201f22',
    surfaceContainerHigh: '#2b292d',
    surfaceContainerHighest: '#363438',
    surfaceContainerLow: '#1c1b1f',
    surfaceContainerLowest: '#0f0d11',
  };

  const mockDarkTheme = {
    ...mockTheme,
    dark: true,
    colors: mockDarkColors,
  };

  return {
    PaperProvider: ({ children }: { children: React.ReactNode }) => children,
    useTheme: () => mockTheme,
    MD3LightTheme: mockTheme,
    MD3DarkTheme: mockDarkTheme,
  };
});

// Mock useColorScheme
jest.mock('react-native/Libraries/Utilities/useColorScheme', () => ({
  default: jest.fn(() => 'light'),
}));
