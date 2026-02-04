# Story 0.6: Configuration de l'infrastructure de tests

Status: ready-for-dev

## Story

As a développeur,
I want configurer l'infrastructure de tests sur tous les projets,
so that je peux écrire des tests dès la première story.

## Acceptance Criteria

1. **Given** le projet `apps/web/`
   **When** Jest est configuré
   **Then** Jest est configuré avec React Testing Library

2. **Given** le projet `apps/mobile/`
   **When** Jest est configuré
   **Then** Jest est configuré avec React Native Testing Library

3. **Given** le package `packages/shared/`
   **When** Jest est configuré
   **Then** Jest est configuré pour les utilitaires

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

- [ ] Task 1: Configurer Jest pour web (AC: #1)
  - [ ] Installer `jest`, `@testing-library/react`, `@testing-library/jest-dom`
  - [ ] Installer `ts-jest`, `jest-environment-jsdom`
  - [ ] Créer `apps/web/jest.config.js`
  - [ ] Créer `apps/web/jest.setup.ts` avec jest-dom
  - [ ] Créer test example `apps/web/__tests__/App.test.tsx`

- [ ] Task 2: Configurer Jest pour mobile (AC: #2)
  - [ ] Installer `jest`, `@testing-library/react-native`
  - [ ] Utiliser preset `jest-expo`
  - [ ] Créer `apps/mobile/jest.config.js`
  - [ ] Créer `apps/mobile/jest.setup.ts`
  - [ ] Créer test example `apps/mobile/__tests__/App.test.tsx`

- [ ] Task 3: Configurer Jest pour shared (AC: #3)
  - [ ] Installer `jest`, `ts-jest`
  - [ ] Créer `packages/shared/jest.config.js`
  - [ ] Créer test example `packages/shared/__tests__/utils.test.ts`

- [ ] Task 4: Configurer scripts monorepo (AC: #4)
  - [ ] Ajouter script `test` dans `package.json` racine
  - [ ] Configurer pour exécuter tests de tous les workspaces
  - [ ] Ajouter script `test:web`, `test:mobile`, `test:shared`
  - [ ] Tester `pnpm test`

- [ ] Task 5: Créer tests examples (AC: #5)
  - [ ] Test web : render App, vérifier présence élément
  - [ ] Test mobile : render App, vérifier présence élément
  - [ ] Test shared : tester formatMoney utility
  - [ ] Tous les tests passent

- [ ] Task 6: Configurer mocks API (AC: #6)
  - [ ] Créer `packages/shared/src/test-utils/mockFetch.ts`
  - [ ] Créer helpers pour mocker les réponses API
  - [ ] Documenter l'utilisation dans les tests

- [ ] Task 7: Vérifier PHPUnit backend (AC: #7)
  - [ ] Vérifier `phpunit.xml` configuré
  - [ ] Vérifier que `./vendor/bin/sail test` fonctionne
  - [ ] Documenter dans CLAUDE.md

## Dev Notes

### Jest Config Web

```javascript
// apps/web/jest.config.js
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.ts'],
  moduleNameMapper: {
    '^@mdb/shared$': '<rootDir>/../../packages/shared/src',
  },
  transform: {
    '^.+\\.tsx?$': 'ts-jest',
  },
};
```

### Jest Config Mobile

```javascript
// apps/mobile/jest.config.js
module.exports = {
  preset: 'jest-expo',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.ts'],
  moduleNameMapper: {
    '^@mdb/shared$': '<rootDir>/../../packages/shared/src',
  },
  transformIgnorePatterns: [
    'node_modules/(?!((jest-)?react-native|@react-native(-community)?)|expo(nent)?|@expo(nent)?/.*|@expo-google-fonts/.*|react-navigation|@react-navigation/.*|@unimodules/.*|unimodules|sentry-expo|native-base|react-native-svg)',
  ],
};
```

### Example Test Web

```typescript
// apps/web/__tests__/App.test.tsx
import { render, screen } from '@testing-library/react';
import App from '../src/App';

describe('App', () => {
  it('renders without crashing', () => {
    render(<App />);
    expect(screen.getByText(/MDB Copilot/i)).toBeInTheDocument();
  });
});
```

### Mock Fetch Helper

```typescript
// packages/shared/src/test-utils/mockFetch.ts
export const createMockFetch = (responses: Record<string, unknown>) => {
  return jest.fn((url: string) => {
    const response = responses[url];
    return Promise.resolve({
      ok: true,
      json: () => Promise.resolve(response),
    });
  });
};
```

### Scripts in root package.json

```json
{
  "scripts": {
    "test": "pnpm -r test",
    "test:web": "pnpm --filter @mdb/web test",
    "test:mobile": "pnpm --filter @mdb/mobile test",
    "test:shared": "pnpm --filter @mdb/shared test"
  }
}
```

### Project Structure Notes
- Each workspace has its own Jest config
- Shared test utilities in packages/shared
- Backend uses PHPUnit (unchanged)

### References
- [Source: architecture.md#Testability]
- [Source: epics.md#Story 0.6]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
