# Story 0.1: Initialisation du monorepo et des projets starter

Status: done

## Story

As a développeur,
I want initialiser le monorepo avec le projet React Native (Expo), le projet React Web (Vite), le package shared et le backend Laravel existant,
so that l'environnement de développement est prêt pour l'implémentation des features.

## Acceptance Criteria

1. **Given** un répertoire existant `mdb-tools/` avec `backend-api/` Laravel
   **When** le développeur exécute les commandes d'initialisation
   **Then** le monorepo contient `apps/mobile/` (Expo TypeScript), `apps/web/` (Vite React TypeScript), `packages/shared/` et `backend-api/`

2. **Given** le monorepo initialisé
   **When** le développeur lance `apps/mobile/`
   **Then** l'app compile sans erreur avec Expo Go

3. **Given** le monorepo initialisé
   **When** le développeur lance `apps/web/`
   **Then** l'app démarre sans erreur sur `localhost:5173`

4. **Given** le package `packages/shared/`
   **When** le développeur importe depuis mobile ou web
   **Then** les types TypeScript sont importables via `@mdb/shared`

5. **Given** le fichier `CLAUDE.md` à la racine
   **When** les conventions sont mises à jour
   **Then** le fichier reflète les conventions React (camelCase variables, PascalCase components)

6. **Given** le monorepo
   **When** pnpm workspaces est configuré
   **Then** `pnpm install` installe toutes les dépendances du monorepo

## Tasks / Subtasks

- [x] Task 1: Restructurer le répertoire racine (AC: #1)
  - [x] Créer `apps/` et `packages/` directories
  - [x] Déplacer ou lier `backend-api/` à la racine
  - [x] Configurer `pnpm-workspace.yaml`
  - [x] Configurer `package.json` racine avec workspaces

- [x] Task 2: Initialiser Expo React Native (AC: #2)
  - [x] `npx create-expo-app@latest apps/mobile --template blank-typescript`
  - [x] Installer dépendances : `@react-navigation/native`, `@react-navigation/bottom-tabs`, `react-native-paper`
  - [x] Installer Zustand : `zustand`
  - [x] Configurer `tsconfig.json` avec paths pour `@mdb/shared`
  - [x] Vérifier que l'app compile (typecheck pass)

- [x] Task 3: Initialiser Vite React Web (AC: #3)
  - [x] `npm create vite@latest apps/web -- --template react-ts`
  - [x] Installer dépendances : `@mui/material`, `@emotion/react`, `@emotion/styled`, `react-router-dom`
  - [x] Installer Dexie.js : `dexie`, `dexie-react-hooks`
  - [x] Installer Zustand : `zustand`
  - [x] Configurer `vite.config.ts` avec alias pour `@mdb/shared`
  - [x] Configurer `tsconfig.json` avec paths

- [x] Task 4: Initialiser package shared (AC: #4)
  - [x] Créer `packages/shared/package.json` avec name `@mdb/shared`
  - [x] Créer `packages/shared/tsconfig.json`
  - [x] Créer structure `src/types/`, `src/utils/`, `src/constants/`
  - [x] Créer `src/index.ts` avec exports
  - [x] Vérifier l'import depuis mobile et web (symlinks OK)

- [x] Task 5: Mettre à jour CLAUDE.md (AC: #5)
  - [x] Ajouter conventions React/React Native
  - [x] Documenter structure monorepo
  - [x] Ajouter commandes pnpm

- [x] Task 6: Valider pnpm workspaces (AC: #6)
  - [x] `pnpm install` depuis la racine (761 packages)
  - [x] Vérifier que toutes les dépendances s'installent
  - [x] Vérifier les symlinks `@mdb/shared`
  - [x] `pnpm typecheck` passe pour tous les packages

## Dev Notes

### Architecture Reference
- **Monorepo structure**: `apps/mobile`, `apps/web`, `packages/shared`, `backend-api`
- **Package manager**: pnpm avec workspaces
- **Mobile stack**: React Native + Expo managed workflow
- **Web stack**: React + Vite
- **Shared**: TypeScript types, utils, constants

### Commands Reference
```bash
# Initialisation Expo
npx create-expo-app@latest apps/mobile --template blank-typescript

# Initialisation Vite
npm create vite@latest apps/web -- --template react-ts

# Install all workspaces
pnpm install

# Run mobile
cd apps/mobile && npx expo start

# Run web
cd apps/web && pnpm dev
```

### Project Structure Notes
- Le `backend-api/` reste à sa position actuelle (pas dans `apps/`)
- Le package `@mdb/shared` est résolu via workspaces protocol
- TypeScript paths configurés pour permettre imports absolus

### References
- [Source: architecture.md#Starter Template Evaluation]
- [Source: architecture.md#Project Structure & Boundaries]
- [Source: epics.md#Story 0.1]

## Dev Agent Record

### Agent Model Used
Claude Opus 4.5 (claude-opus-4-5-20251101)

### Completion Notes List
- WatermelonDB non installé (nécessite configuration native, à ajouter dans story spécifique sync)
- Expo app créée avec template blank-typescript
- Web app créée avec Vite react-ts template
- Package shared créé avec types de base, utils (generateUUID, centsToEuros), et constants (thèmes, API config)
- CLAUDE.md mis à jour pour refléter le nouveau stack React Native + React Web
- pnpm workspaces validés, 761 packages installés
- TypeScript typecheck passe pour les 3 packages (shared, mobile, web)

### File List
- `/pnpm-workspace.yaml` - Configuration workspaces pnpm
- `/package.json` - Root package.json avec scripts monorepo
- `/apps/mobile/package.json` - Package Expo React Native
- `/apps/mobile/tsconfig.json` - TypeScript config mobile avec paths
- `/apps/mobile/eslint.config.js` - ESLint 9 config pour mobile
- `/apps/mobile/App.tsx` - App component principal
- `/apps/mobile/app.json` - Expo configuration
- `/apps/mobile/index.ts` - Entry point
- `/apps/web/package.json` - Package Vite React Web
- `/apps/web/tsconfig.app.json` - TypeScript config web avec paths
- `/apps/web/tsconfig.node.json` - TypeScript config pour Node
- `/apps/web/vite.config.ts` - Config Vite avec alias @mdb/shared
- `/apps/web/vitest.config.ts` - Configuration Vitest
- `/apps/web/eslint.config.js` - ESLint config pour web
- `/apps/web/src/test/setup.ts` - Setup fichier pour tests
- `/packages/shared/package.json` - Package shared
- `/packages/shared/tsconfig.json` - TypeScript config shared
- `/packages/shared/vitest.config.ts` - Configuration Vitest pour shared
- `/packages/shared/src/index.ts` - Exports publics explicites
- `/packages/shared/src/types/index.ts` - Types de base (BaseEntity, SyncableEntity)
- `/packages/shared/src/utils/index.ts` - Utils (generateUUID crypto-secure, centsToEuros, etc.)
- `/packages/shared/src/utils/index.test.ts` - Tests unitaires utils (9 tests)
- `/packages/shared/src/constants/index.ts` - Constants (thèmes, API config, sync config)
- `/CLAUDE.md` - Conventions mises à jour pour React Native + React Web

## Senior Developer Review (AI)

### Review Date: 2026-02-04
### Reviewer: Claude Opus 4.5

### Issues Found & Fixed
| Sev. | Issue | Fix Applied |
|------|-------|-------------|
| HIGH | ESLint non configuré pour mobile | Créé `eslint.config.js` + ajouté deps ESLint 9 |
| HIGH | Jest non installé pour mobile | Ajouté `jest`, `jest-expo`, `@types/jest` |
| HIGH | UUID generator non-cryptographique | Remplacé `Math.random()` par `crypto.randomUUID()` |
| MED | react-native-gesture-handler manquant | Ajouté à mobile dependencies |
| MED | vitest non configuré pour web | Créé `vitest.config.ts` + setup file |
| MED | Aucun test pour shared | Créé 9 tests unitaires (100% pass) |
| MED | File List incomplète | Liste mise à jour avec tous les fichiers |
| LOW | CLAUDE.md mentionne WatermelonDB | Clarifié: "prévu pour Epic 11" |
| LOW | Exports non explicites | Remplacé `export *` par exports nommés |

### Verification
- `pnpm typecheck` ✅ Pass (3 packages)
- `pnpm test` (shared) ✅ 9 tests pass
- `pnpm lint` (mobile) ✅ ESLint fonctionne
