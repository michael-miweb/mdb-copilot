# Story 0.4: Configuration qualité code et linting

Status: ready-for-dev

## Story

As a développeur,
I want configurer ESLint, Prettier et TypeScript strict sur tous les projets,
so that la qualité du code est garantie et cohérente.

## Acceptance Criteria

1. **Given** les projets `apps/mobile/`, `apps/web/` et `packages/shared/`
   **When** ESLint est configuré
   **Then** ESLint est configuré avec les règles React/React Native appropriées

2. **Given** les projets TypeScript
   **When** Prettier est configuré
   **Then** Prettier formate le code automatiquement on-save

3. **Given** tous les projets
   **When** TypeScript est configuré
   **Then** TypeScript strict mode est activé sur tous les projets

4. **Given** le monorepo
   **When** `pnpm lint` est exécuté
   **Then** le lint s'exécute sur tout le monorepo sans erreur

5. **Given** le monorepo
   **When** `pnpm typecheck` est exécuté
   **Then** les types sont vérifiés sans erreur

6. **Given** le projet `backend-api/`
   **When** les outils PHP sont vérifiés
   **Then** PHPStan (niveau max) et Laravel Pint restent configurés (inchangés)

## Tasks / Subtasks

- [ ] Task 1: Configurer ESLint (AC: #1)
  - [ ] Créer `.eslintrc.cjs` à la racine du monorepo
  - [ ] Configurer `eslint-plugin-react` pour web
  - [ ] Configurer `eslint-plugin-react-native` pour mobile
  - [ ] Configurer `@typescript-eslint/eslint-plugin`
  - [ ] Créer configurations spécifiques par app si nécessaire
  - [ ] Ajouter règles pour imports absolus

- [ ] Task 2: Configurer Prettier (AC: #2)
  - [ ] Créer `.prettierrc` à la racine
  - [ ] Configurer : singleQuote, trailingComma, tabWidth, semi
  - [ ] Créer `.prettierignore`
  - [ ] Intégrer avec ESLint (`eslint-config-prettier`)

- [ ] Task 3: Configurer TypeScript strict (AC: #3)
  - [ ] Créer `tsconfig.base.json` à la racine
  - [ ] Configurer `strict: true`, `noImplicitAny`, `strictNullChecks`
  - [ ] Configurer paths pour `@mdb/shared`
  - [ ] Étendre dans chaque app (`apps/mobile/tsconfig.json`, `apps/web/tsconfig.json`)

- [ ] Task 4: Scripts monorepo (AC: #4, #5)
  - [ ] Ajouter script `lint` dans `package.json` racine
  - [ ] Ajouter script `typecheck` dans `package.json` racine
  - [ ] Ajouter script `format` pour Prettier
  - [ ] Tester `pnpm lint` sans erreur
  - [ ] Tester `pnpm typecheck` sans erreur

- [ ] Task 5: Vérifier backend PHP (AC: #6)
  - [ ] Vérifier que PHPStan est configuré niveau max
  - [ ] Vérifier que Laravel Pint est configuré
  - [ ] Documenter les commandes dans CLAUDE.md

## Dev Notes

### ESLint Configuration

```javascript
// .eslintrc.cjs
module.exports = {
  root: true,
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
    'plugin:react/recommended',
    'plugin:react-hooks/recommended',
    'prettier',
  ],
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint', 'react', 'react-hooks'],
  settings: {
    react: {
      version: 'detect',
    },
  },
  rules: {
    'react/react-in-jsx-scope': 'off', // React 17+
    '@typescript-eslint/no-explicit-any': 'error',
    '@typescript-eslint/explicit-function-return-type': 'off',
  },
};
```

### Prettier Configuration

```json
{
  "singleQuote": true,
  "trailingComma": "es5",
  "tabWidth": 2,
  "semi": true,
  "printWidth": 100
}
```

### TypeScript Base Config

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true
  }
}
```

### Scripts in root package.json

```json
{
  "scripts": {
    "lint": "eslint apps packages --ext .ts,.tsx",
    "lint:fix": "eslint apps packages --ext .ts,.tsx --fix",
    "typecheck": "tsc --noEmit -p apps/web && tsc --noEmit -p apps/mobile",
    "format": "prettier --write .",
    "format:check": "prettier --check ."
  }
}
```

### Project Structure Notes
- Monorepo root owns shared ESLint/Prettier configs
- Each app extends base TypeScript config
- Backend PHP uses separate tools (Pint, PHPStan)

### References
- [Source: architecture.md#Enforcement Guidelines]
- [Source: architecture.md#Implementation Patterns]
- [Source: epics.md#Story 0.4]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
