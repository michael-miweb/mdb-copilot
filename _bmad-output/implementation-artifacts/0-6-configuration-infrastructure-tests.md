# Story 0.6: Configuration de l'infrastructure de tests

Status: done

## Story

As a développeur,
I want configurer l'infrastructure de tests sur tous les projets,
so that je peux écrire des tests dès la première story.

## Acceptance Criteria

1. **Given** le projet `apps/web/`
   **When** Vitest est configuré
   **Then** Vitest est configuré avec React Testing Library (AC #1 - ADAPTÉ: Vitest remplace Jest pour cohérence Vite)

2. **Given** le projet `apps/mobile/`
   **When** Jest est configuré
   **Then** Jest est configuré avec React Native Testing Library

3. **Given** le package `packages/shared/`
   **When** Vitest est configuré
   **Then** Vitest est configuré pour les utilitaires

4. **Given** le monorepo
   **When** `pnpm test` est exécuté
   **Then** tous les tests du monorepo s'exécutent

5. **Given** chaque projet
   **When** les tests sont initialisés
   **Then** un test example passe sur chaque projet

6. **Given** les tests
   **When** les mocks sont nécessaires
   **Then** les mocks pour `fetch`/API sont configurés dans un fichier partagé

7. **Given** le projet `backend-api/`
   **When** PHPUnit est vérifié
   **Then** PHPUnit reste configuré (inchangé)

## Tasks / Subtasks

- [x] Task 1: Configurer tests pour web (AC: #1)
  - [x] Vitest déjà configuré (vitest.config.ts existant)
  - [x] @testing-library/react et jest-dom installés
  - [x] Setup file configuré (src/test/setup.ts)
  - [x] Créer test example `apps/web/src/App.test.tsx`

- [x] Task 2: Configurer Jest pour mobile (AC: #2)
  - [x] Installer `@testing-library/react-native`
  - [x] Créer `apps/mobile/jest.config.cjs` (ESM compatible)
  - [x] Créer `apps/mobile/babel.config.cjs`
  - [x] Créer `apps/mobile/jest.setup.ts` avec mocks RN Paper
  - [x] Créer test example `apps/mobile/__tests__/App.test.tsx`

- [x] Task 3: Configurer tests pour shared (AC: #3)
  - [x] Vitest déjà configuré (vitest.config.ts existant)
  - [x] 89 tests existants couvrant utils et theme

- [x] Task 4: Configurer scripts monorepo (AC: #4)
  - [x] Scripts `test`, `test:web`, `test:mobile`, `test:shared` déjà configurés
  - [x] `pnpm test` exécute tous les tests des 3 workspaces

- [x] Task 5: Créer tests examples (AC: #5)
  - [x] Test web : 4 tests (render, counter, logos)
  - [x] Test mobile : 3 tests (render, structure, content)
  - [x] Test shared : 89 tests existants
  - [x] Tous les tests passent (96 tests total)

- [x] Task 6: Configurer mocks API (AC: #6)
  - [x] Créer `packages/shared/src/test-utils/mockFetch.ts`
  - [x] Helpers: createMockFetch, mockJsonResponse, mockErrorResponse, mockNetworkError, mockDelayedResponse
  - [x] Export via `@mdb/shared/test-utils`
  - [x] Tests pour mock utilities (14 tests)

- [x] Task 7: Vérifier PHPUnit backend (AC: #7)
  - [x] `phpunit.xml` configuré correctement
  - [x] `./vendor/bin/sail test` fonctionne (69 tests passent)
  - [x] Documenté dans CLAUDE.md

## Dev Notes

### Adaptation technique
Le projet utilise **Vitest** (pas Jest) pour web et shared car:
- Vite est le bundler du projet web
- Vitest offre une meilleure intégration avec Vite (HMR, ESM natif)
- Configuration plus simple et plus rapide

Le mobile utilise **Jest** avec `jest-expo` preset car:
- C'est le standard Expo/React Native
- Meilleure compatibilité avec react-native-paper et les mocks RN

### Configuration Mobile avec pnpm
Défis rencontrés avec pnpm monorepo et React Native 0.81+:
- `"type": "module"` dans package.json nécessite `.cjs` pour les configs
- react-native-web utilisé pour les tests (évite les problèmes ESM)
- Mocks complets pour react-native-paper MD3 themes (incluant tous les surface tokens)

### Limitations connues
1. **react-test-renderer deprecated** — Les tests mobile affichent un warning de deprecation. C'est un problème connu de @testing-library/react-native. À surveiller pour migration future vers les nouvelles APIs React 19.

2. **Tests mobile via react-native-web** — Les tests utilisent le shim react-native-web, ce qui peut masquer certains bugs spécifiques à React Native. Pour des tests plus fidèles à la plateforme, utiliser les tests E2E avec Maestro ou Detox.

### Test Coverage
| Package | Framework | Tests |
|---------|-----------|-------|
| shared  | Vitest    | 89    |
| web     | Vitest    | 4     |
| mobile  | Jest      | 3     |
| **Total** |         | **96**|

Backend PHPUnit: 69 tests (189 assertions)

### Mock Fetch API Usage

```typescript
// IMPORTANT: Always import from subpath to avoid bundling test code in production
import { createMockFetch, mockJsonResponse } from '@mdb/shared/test-utils';

// Mock multiple endpoints
global.fetch = createMockFetch({
  '/api/users': { users: [{ id: '1', name: 'John' }] },
  '/api/properties': { properties: [] },
});

// Individual response (Vitest)
global.fetch = vi.fn().mockResolvedValue(mockJsonResponse({ success: true }));

// Individual response (Jest)
global.fetch = jest.fn().mockResolvedValue(mockJsonResponse({ success: true }));
```

### Project Structure Notes
- Web/Shared: Vitest avec vitest.config.ts
- Mobile: Jest avec jest.config.cjs (ESM compatible)
- Mocks centralisés dans @mdb/shared/test-utils
- Backend: PHPUnit (inchangé)

### References
- [Source: architecture.md#Testability]
- [Source: epics.md#Story 0.6]

## Dev Agent Record

### Agent Model Used
Claude Opus 4.5 (claude-opus-4-5-20251101)

### Completion Notes List
- Infrastructure tests configurée pour les 3 projets frontend
- Web et Shared utilisent Vitest (cohérence Vite), Mobile utilise Jest
- 96 tests frontend passent + 69 tests backend
- Mock utilities créés dans @mdb/shared/test-utils avec tests
- Configuration adaptée pour pnpm monorepo et React Native 0.81+
- Tous les ACs satisfaits

### File List
- frontend/apps/web/src/App.test.tsx (created)
- frontend/apps/web/package.json (modified - @testing-library/user-event)
- frontend/apps/mobile/jest.config.cjs (created)
- frontend/apps/mobile/jest.setup.ts (created)
- frontend/apps/mobile/babel.config.cjs (created)
- frontend/apps/mobile/__tests__/App.test.tsx (created)
- frontend/apps/mobile/package.json (modified - testing deps)
- frontend/apps/mobile/eslint.config.js (modified - ignore *.cjs files)
- frontend/packages/shared/src/test-utils/mockFetch.ts (created)
- frontend/packages/shared/src/test-utils/mockFetch.test.ts (created)
- frontend/packages/shared/src/test-utils/index.ts (created)
- frontend/packages/shared/src/index.ts (modified - add comment about test-utils import path)
- frontend/packages/shared/package.json (modified - export test-utils subpath)
