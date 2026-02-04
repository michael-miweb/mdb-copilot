# Story 0.5: Configuration du Design System et Theme

Status: done

## Story

As a développeur,
I want configurer le Design System Material 3 avec les tokens MDB Copilot,
so that l'UI est cohérente sur mobile et web dès le premier écran.

## Acceptance Criteria

1. **Given** les projets `apps/mobile/` et `apps/web/` initialisés
   **When** le développeur configure les themes
   **Then** MUI theme est configuré dans `apps/web/` avec palette Light/Dark MDB

2. **Given** le theme web
   **When** les tokens sont appliqués
   **Then** les valeurs sont :
   - Light: Primary #7c4dff, Accent #f3419f
   - Dark: Primary #5750d8, Accent #d063de, Background rgb(30,35,52)
   - Typography: Inter via @fontsource/inter
   - Shape: borderRadius pills 24px, cards 16px, inputs 12px

3. **Given** le projet mobile
   **When** React Native Paper theme est configuré
   **Then** les mêmes tokens MDB sont appliqués

4. **Given** les apps mobile et web
   **When** un ThemeProvider est ajouté
   **Then** un composant `ThemeProvider` wrappe l'app sur les deux plateformes

5. **Given** les préférences système
   **When** l'utilisateur a configuré dark mode
   **Then** le dark mode switch fonctionne (suit les préférences système)

6. **Given** le package shared
   **When** les couleurs sont centralisées
   **Then** un fichier `packages/shared/src/theme/colors.ts` centralise les constantes couleur

## Tasks / Subtasks

- [x] Task 1: Créer les tokens partagés (AC: #6)
  - [x] Créer `packages/shared/src/theme/colors.ts`
  - [x] Définir palette Light mode (Violet #7c4dff, Magenta #f3419f)
  - [x] Définir palette Dark mode (Indigo #5750d8, Orchidée #d063de, bg rgb(30,35,52))
  - [x] Définir spacing (base 8px, multiples 4-8-16-24-32-48)
  - [x] Définir border radius (pills 24px, cards 16px, inputs 12px, bottom sheets 24px)
  - [x] Exporter depuis `packages/shared/src/index.ts`

- [x] Task 2: Configurer MUI theme web (AC: #1, #2)
  - [x] Installer `@fontsource/inter`
  - [x] Créer `apps/web/src/core/theme/theme.ts`
  - [x] Configurer palette mode light avec tokens MDB
  - [x] Configurer palette mode dark avec tokens MDB
  - [x] Configurer typography avec Inter
  - [x] Configurer shape avec borderRadius
  - [x] Créer `apps/web/src/core/theme/ThemeProvider.tsx`

- [x] Task 3: Configurer React Native Paper theme mobile (AC: #3)
  - [x] Installer `@expo-google-fonts/inter` et `expo-font`
  - [x] Créer `apps/mobile/src/core/theme/theme.ts`
  - [x] Configurer MD3LightTheme avec tokens MDB
  - [x] Configurer MD3DarkTheme avec tokens MDB
  - [x] Créer `apps/mobile/src/core/theme/ThemeProvider.tsx`

- [x] Task 4: Intégrer ThemeProvider (AC: #4)
  - [x] Wrapper App.tsx mobile avec PaperProvider + theme
  - [x] Wrapper App.tsx web avec MUI ThemeProvider
  - [x] Vérifier que les composants utilisent le theme

- [x] Task 5: Implémenter dark mode auto (AC: #5)
  - [x] Web: utiliser `useMediaQuery('(prefers-color-scheme: dark)')`
  - [x] Mobile: utiliser `useColorScheme()` de React Native
  - [x] Créer hook `useThemeMode()` pour gérer le mode
  - [x] Tester le switch automatique

## Dev Notes

### Color Tokens

```typescript
// packages/shared/src/theme/colors.ts
export const colors = {
  light: {
    primary: '#7c4dff',      // Violet
    secondary: '#f3419f',    // Magenta (accent)
    background: '#ffffff',
    surface: '#f5f5f5',
    error: '#d32f2f',
    onPrimary: '#ffffff',
    onSecondary: '#ffffff',
    onBackground: '#1a1a1a',
    onSurface: '#1a1a1a',
  },
  dark: {
    primary: '#5750d8',      // Indigo
    secondary: '#d063de',    // Orchidée (accent)
    background: 'rgb(30, 35, 52)',
    surface: 'rgb(40, 45, 62)',
    error: '#f44336',
    onPrimary: '#ffffff',
    onSecondary: '#ffffff',
    onBackground: '#ffffff',
    onSurface: '#ffffff',
  },
};

export const spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
  xxl: 48,
};

export const borderRadius = {
  pill: 24,
  card: 16,
  input: 12,
  bottomSheet: 24,
  button: 12,
};
```

### MUI Theme Structure

```typescript
// apps/web/src/core/theme/theme.ts
import { createTheme } from '@mui/material/styles';
import { colors, borderRadius } from '@mdb/shared';

export const lightTheme = createTheme({
  palette: {
    mode: 'light',
    primary: { main: colors.light.primary },
    secondary: { main: colors.light.secondary },
  },
  typography: {
    fontFamily: '"Inter", sans-serif',
  },
  shape: {
    borderRadius: borderRadius.input,
  },
});
```

### React Native Paper Theme

```typescript
// apps/mobile/src/core/theme/theme.ts
import { MD3LightTheme, MD3DarkTheme } from 'react-native-paper';
import { colors } from '@mdb/shared';

export const lightTheme = {
  ...MD3LightTheme,
  colors: {
    ...MD3LightTheme.colors,
    primary: colors.light.primary,
    secondary: colors.light.secondary,
  },
};
```

### Project Structure Notes
- Colors defined once in shared package
- Each platform adapts to its UI kit (MUI/Paper)
- Dark mode follows system preference by default

### References
- [Source: ux-design-specification.md#Design Tokens]
- [Source: architecture.md#Frontend Architecture]
- [Source: epics.md#Story 0.5]

## Dev Agent Record

### Agent Model Used
Claude Opus 4.5 (claude-opus-4-5-20251101)

### Completion Notes List
- Design tokens centralisés dans @mdb/shared (colors, spacing, borderRadius)
- MUI theme web configuré avec palette Light/Dark et Inter font
- React Native Paper theme mobile configuré avec MD3 themes
- ThemeProvider wrapping App.tsx sur les deux plateformes
- Dark mode auto fonctionne via système (prefers-color-scheme / useColorScheme)
- Hook useThemeMode() créé pour les deux plateformes
- Tous les tests passent (75 tests shared incluant 18 tests design tokens)
- Lint et typecheck passent sur tous les packages

### Code Review Fixes (Post-Implementation)
- Fixed: Mobile App.tsx uses useTheme() colors instead of hardcoded values
- Fixed: Refactored web theme.ts with shared config (sharedComponents, sharedTypography, sharedShape)
- Fixed: Added useFonts hook to load Inter font on mobile (Inter_400Regular, Inter_500Medium, Inter_600SemiBold, Inter_700Bold)
- Fixed: Added useMemo to mobile ThemeProvider for performance
- Fixed: Converted dark mode RGB colors to HEX format (#1e2334, #282d3e)
- Fixed: Added comprehensive tests for design tokens (colors.test.ts)

### File List
- frontend/packages/shared/src/theme/colors.ts (created, modified - HEX colors)
- frontend/packages/shared/src/theme/colors.test.ts (created - design token tests)
- frontend/packages/shared/src/theme/index.ts (created)
- frontend/packages/shared/src/index.ts (modified - export theme)
- frontend/packages/shared/package.json (modified - export theme)
- frontend/apps/web/src/core/theme/theme.ts (created, modified - shared config)
- frontend/apps/web/src/core/theme/ThemeProvider.tsx (created)
- frontend/apps/web/src/core/theme/useThemeMode.ts (created)
- frontend/apps/web/src/core/theme/index.ts (created)
- frontend/apps/web/src/main.tsx (modified - ThemeProvider + Inter fonts)
- frontend/apps/web/package.json (modified - @fontsource/inter)
- frontend/apps/mobile/src/core/theme/theme.ts (created)
- frontend/apps/mobile/src/core/theme/ThemeProvider.tsx (created, modified - useMemo)
- frontend/apps/mobile/src/core/theme/useThemeMode.ts (created)
- frontend/apps/mobile/src/core/theme/index.ts (created)
- frontend/apps/mobile/App.tsx (modified - ThemeProvider + useFonts + useTheme)
- frontend/apps/mobile/package.json (modified - @expo-google-fonts/inter)
