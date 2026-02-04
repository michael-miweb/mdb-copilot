# Story 0.4: Configuration qualité code et linting

Status: done

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

- [x] Task 1: Configurer ESLint (AC: #1)
  - [x] Configurer ESLint 9 flat config dans chaque package (moderne vs `.eslintrc.cjs`)
  - [x] Configurer `eslint-plugin-react-hooks` pour web
  - [x] Configurer `eslint-plugin-react-hooks` pour mobile
  - [x] Configurer `typescript-eslint`
  - [x] Ajouter ESLint au package shared
  - [x] Règles cohérentes : `no-explicit-any: error`, `no-unused-vars` avec argsIgnorePattern

- [x] Task 2: Configurer Prettier (AC: #2)
  - [x] Créer `.prettierrc` à la racine
  - [x] Configurer : singleQuote, trailingComma, tabWidth, semi, printWidth
  - [x] Créer `.prettierignore`
  - [x] Intégrer avec ESLint (`eslint-config-prettier`)

- [x] Task 3: Configurer TypeScript strict (AC: #3)
  - [x] Créer `frontend/tsconfig.base.json`
  - [x] Configurer `strict: true`, `noImplicitAny`, `strictNullChecks`, `noFallthroughCasesInSwitch`
  - [x] Paths `@mdb/shared` configurés dans chaque app
  - [x] Shared package étend `tsconfig.base.json`
  - [x] Mobile étend `expo/tsconfig.base` (requis par Expo) avec `strict: true` ajouté
  - [x] Web utilise `tsconfig.app.json` avec options strict (structure Vite)

- [x] Task 4: Scripts monorepo (AC: #4, #5)
  - [x] Script `lint` dans `package.json` racine (`pnpm -r lint`)
  - [x] Script `lint:fix` ajouté
  - [x] Script `typecheck` dans `package.json` racine
  - [x] Script `format` pour Prettier
  - [x] Tester `pnpm lint` sans erreur ✓
  - [x] Tester `pnpm typecheck` sans erreur ✓

- [x] Task 5: Vérifier backend PHP (AC: #6)
  - [x] PHPStan configuré niveau max (`phpstan.neon`)
  - [x] Laravel Pint configuré et fonctionnel
  - [x] Commandes documentées dans CLAUDE.md

## Dev Notes

### ESLint Configuration (ESLint 9 Flat Config)

```javascript
// eslint.config.js (exemple pour shared package)
import js from '@eslint/js';
import tseslint from 'typescript-eslint';
import eslintConfigPrettier from 'eslint-config-prettier';

export default tseslint.config(
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    rules: {
      '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
      '@typescript-eslint/no-explicit-any': 'error',
    },
  },
  { ignores: ['node_modules/', 'dist/'] },
  eslintConfigPrettier
);
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
    "lint": "pnpm -r lint",
    "lint:fix": "pnpm -r lint -- --fix",
    "typecheck": "pnpm -r typecheck",
    "format": "prettier --write .",
    "format:check": "prettier --check ."
  }
}
```

### VSCode Settings (format-on-save)

Pour activer le format-on-save, créer `.vscode/settings.json` :

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "[typescript]": { "editor.defaultFormatter": "esbenp.prettier-vscode" },
  "[typescriptreact]": { "editor.defaultFormatter": "esbenp.prettier-vscode" }
}
```

### Project Structure Notes
- Monorepo utilise `pnpm -r` pour exécuter les scripts dans chaque package
- Chaque app a son propre `eslint.config.js` (ESLint 9 flat config)
- `frontend/tsconfig.base.json` définit les options strictes partagées
- Mobile étend `expo/tsconfig.base` (requis par Expo) avec `strict: true`
- Web étend notre base via `tsconfig.app.json`
- Backend PHP uses separate tools (Pint, PHPStan)

### References
- [Source: architecture.md#Enforcement Guidelines]
- [Source: architecture.md#Implementation Patterns]
- [Source: epics.md#Story 0.4]

## Dev Agent Record

### Agent Model Used
Claude Opus 4.5 (claude-opus-4-5-20251101)

### Completion Notes List
- ESLint configuré avec ESLint 9 flat config (plus moderne que .eslintrc.cjs suggéré)
- typescript-eslint intégré dans tous les packages
- eslint-config-prettier ajouté pour éviter conflits ESLint/Prettier
- Prettier configuré avec .prettierrc et .prettierignore à la racine
- tsconfig.base.json créé dans frontend/ pour partager config strict
- Tous les scripts monorepo fonctionnels : lint, lint:fix, typecheck, format, format:check
- PHPStan niveau max et Laravel Pint vérifiés dans backend
- 57 tests passent dans @mdb/shared
- Web app test script fixé avec --passWithNoTests

**Code Review Fixes (2026-02-04):**
- [HIGH] Dev Notes mis à jour avec ESLint 9 flat config syntax (au lieu de .eslintrc.cjs)
- [HIGH] .vscode/settings.json créé pour format-on-save (AC #2)
- [HIGH] File List complété avec tous les fichiers modifiés
- [MEDIUM] eslint-plugin-react-hooks aligné sur ^7.0.1 (mobile et web)
- [MEDIUM] Dev Notes clarifiés sur architecture tsconfig (Expo vs Vite constraints)
- [MEDIUM] Scripts examples mis à jour (`pnpm -r lint` au lieu de direct eslint)
- [LOW] .prettierignore nettoyé (supprimé pnpm-lock.yaml redondant)
- [LOW] tsconfig.base.json ajouté noFallthroughCasesInSwitch
- [LOW] TypeScript versions alignées sur ~5.9.x

### File List
- .prettierrc (created)
- .prettierignore (created)
- .vscode/settings.json (created - format-on-save)
- package.json (modified - added lint:fix)
- frontend/tsconfig.base.json (created)
- frontend/packages/shared/eslint.config.js (created)
- frontend/packages/shared/package.json (modified - added lint script, eslint deps)
- frontend/packages/shared/tsconfig.json (modified - extends tsconfig.base.json)
- frontend/apps/web/eslint.config.js (modified - added prettier, rules)
- frontend/apps/web/package.json (modified - test script fix, eslint-config-prettier)
- frontend/apps/web/tsconfig.json (formatted by Prettier)
- frontend/apps/mobile/eslint.config.js (modified - added prettier, rules)
- frontend/apps/mobile/package.json (modified - eslint-config-prettier, aligned versions)
- frontend/apps/mobile/tsconfig.json (formatted by Prettier)
