# CLAUDE.md — Conventions MDB Copilot

## Structure monorepo

```
frontend/                 # Partie applicative (clients)
  apps/
    mobile/               # React Native + Expo — iOS, Android
    web/                  # React + Vite — Web app
  packages/
    shared/               # @mdb/shared — Types, utils, constants partagés
backend-api/              # Laravel 12 + Sanctum — API REST JSON
```

## Stack technique

- **Mobile :** React Native + Expo (managed workflow) / React Navigation / React Native Paper / Zustand (WatermelonDB prévu pour Epic 11)
- **Web :** React + Vite / MUI v5+ / React Router v6 / Dexie.js / Zustand
- **Shared :** TypeScript types, utils, constants via `@mdb/shared`
- **Backend :** Laravel 12 / Sanctum RBAC / Sail (Docker) / MySQL 8
- **Prod :** FrankenPHP + Octane / Docker

## Conventions de nommage

| Contexte | Convention | Exemple |
|----------|-----------|---------|
| DB columns, API JSON keys | snake_case | `created_at`, `user_id` |
| TS/JS variables, functions | camelCase | `userName`, `fetchListings()` |
| React components, classes | PascalCase | `ListingCard`, `UserService` |
| PHP classes | PascalCase | `ListingController`, `UserService` |
| PHP variables, methods | camelCase | `$listing`, `createListing()` |
| Routes API | kebab-case, pluriel | `/api/listings`, `/api/visit-guides` |
| Fichiers TypeScript | kebab-case | `listing-card.tsx`, `user-service.ts` |
| Migrations Laravel | snake_case avec timestamp | `2026_01_28_create_listings_table` |

## Ports développement

Préfixe **4** pour éviter conflits avec autres projets sur ce laptop.

| Service | Port |
|---------|------|
| Backend (Sail HTTP) | 4080 |
| MySQL | 43306 |
| Vite (web) | 45173 |
| Expo (mobile) | 48081 |
| Mailpit SMTP | 41025 |
| Mailpit Dashboard | 48025 |

## Design Tokens

### Light Mode
- Primary: Violet `#7c4dff`
- Secondary: Magenta `#f3419f`

### Dark Mode
- Primary: Indigo `#5750d8`
- Secondary: Orchidée `#d063de`

## Patterns obligatoires

- **Repository pattern** : abstraction local (WatermelonDB/Dexie) / remote (API) pour toutes les entités
- **Zustand stores** : un store par domaine, pas de useState global
- **UUID v4** : pour tous les IDs d'entités (côté client et serveur)
- **Montants en centimes** : tous les montants financiers stockés en `int` (centimes d'euros)
- **folder-by-feature** : chaque feature dans `src/features/<nom>/`
- **React Navigation** (mobile) / React Router (web) : routage déclaratif
- **Sanctum RBAC** : token abilities (`owner`, `guest-read`, `guest-extended`)
- **API REST JSON** : pas de versioning, Scramble OpenAPI auto-doc
- **Sync engine** : delta incrémental via `updated_at`, last-write-wins, `POST /api/sync`

## Anti-patterns à éviter

- Pas de logique métier dans les composants React (utiliser des hooks/services)
- Pas de logique métier dans les controllers Laravel (utiliser des Services/Actions)
- Pas de requêtes SQL directes dans les controllers (utiliser Eloquent/Repository)
- Pas de `int` auto-increment pour les IDs (UUID v4 uniquement)
- Pas de `double` pour les montants financiers (centimes `int` uniquement)
- Pas de données en dur dans le code (utiliser les fichiers de config/env)
- Pas de `any` TypeScript (typage strict obligatoire)

## Commandes utiles

```bash
# Monorepo (depuis la racine)
pnpm install                         # Installer toutes les dépendances
pnpm dev:mobile                      # Lancer l'app mobile (Expo)
pnpm dev:web                         # Lancer l'app web (Vite)
pnpm test                            # Tests tous les packages
pnpm lint                            # Lint tous les packages
pnpm typecheck                       # TypeScript check tous les packages

# Mobile (depuis frontend/apps/mobile/) — port 48081
pnpm dev                             # Démarrer Expo (port 48081)
pnpm ios                             # iOS simulator
pnpm android                         # Android emulator

# Web (depuis frontend/apps/web/) — port 45173
pnpm dev                             # Démarrer Vite (port 45173)
pnpm build                           # Build production
pnpm preview                         # Preview build

# Backend (depuis backend-api/)
./vendor/bin/sail up -d              # Démarrer les conteneurs
./vendor/bin/sail artisan migrate    # Migrations
./vendor/bin/sail artisan test       # Tests PHPUnit
./vendor/bin/pint                    # Formatter PHP (Laravel Pint)
./vendor/bin/phpstan analyse --memory-limit=512M  # Analyse statique
```

## Workspace imports

```typescript
// Import depuis le package shared
import { generateUUID, centsToEuros, LIGHT_THEME } from '@mdb/shared';
```
