# Story 0.5: Configuration du Design System et Theme

Status: ready-for-dev

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

- [ ] Task 1: Créer les tokens partagés (AC: #6)
  - [ ] Créer `packages/shared/src/theme/colors.ts`
  - [ ] Définir palette Light mode (Violet #7c4dff, Magenta #f3419f)
  - [ ] Définir palette Dark mode (Indigo #5750d8, Orchidée #d063de, bg rgb(30,35,52))
  - [ ] Définir spacing (base 8px, multiples 4-8-16-24-32-48)
  - [ ] Définir border radius (pills 24px, cards 16px, inputs 12px, bottom sheets 24px)
  - [ ] Exporter depuis `packages/shared/src/index.ts`

- [ ] Task 2: Configurer MUI theme web (AC: #1, #2)
  - [ ] Installer `@fontsource/inter`
  - [ ] Créer `apps/web/src/core/theme/theme.ts`
  - [ ] Configurer palette mode light avec tokens MDB
  - [ ] Configurer palette mode dark avec tokens MDB
  - [ ] Configurer typography avec Inter
  - [ ] Configurer shape avec borderRadius
  - [ ] Créer `apps/web/src/core/theme/ThemeProvider.tsx`

- [ ] Task 3: Configurer React Native Paper theme mobile (AC: #3)
  - [ ] Installer `expo-google-fonts` pour Inter
  - [ ] Créer `apps/mobile/src/core/theme/theme.ts`
  - [ ] Configurer MD3LightTheme avec tokens MDB
  - [ ] Configurer MD3DarkTheme avec tokens MDB
  - [ ] Créer `apps/mobile/src/core/theme/ThemeProvider.tsx`

- [ ] Task 4: Intégrer ThemeProvider (AC: #4)
  - [ ] Wrapper App.tsx mobile avec PaperProvider + theme
  - [ ] Wrapper App.tsx web avec MUI ThemeProvider
  - [ ] Vérifier que les composants utilisent le theme

- [ ] Task 5: Implémenter dark mode auto (AC: #5)
  - [ ] Web: utiliser `useMediaQuery('(prefers-color-scheme: dark)')`
  - [ ] Mobile: utiliser `useColorScheme()` de React Native
  - [ ] Créer hook `useThemeMode()` pour gérer le mode
  - [ ] Tester le switch automatique

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
{{agent_model_name_version}}

### Completion Notes List

### File List
