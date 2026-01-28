# CLAUDE.md — Conventions MDB Copilot

## Structure monorepo

```
mobile-app/     # Flutter (Very Good CLI) — iOS, Android, Web
backend-api/    # Laravel 12 + Sanctum — API REST JSON
```

## Stack technique

- **Frontend :** Flutter 3.38+ / Very Good CLI / Bloc-Cubit / GoRouter / Drift (SQLite + SQLCipher)
- **Backend :** Laravel 12 / Sanctum RBAC / Sail (Docker) / MySQL 8
- **Prod :** FrankenPHP + Octane / Docker

## Conventions de nommage

| Contexte | Convention | Exemple |
|----------|-----------|---------|
| DB columns, API JSON keys | snake_case | `created_at`, `user_id` |
| Dart variables, functions | camelCase | `userName`, `fetchListings()` |
| Dart classes, enums | PascalCase | `ListingRepository`, `PipelineStatus` |
| PHP classes | PascalCase | `ListingController`, `UserService` |
| PHP variables, methods | camelCase | `$listing`, `createListing()` |
| Routes API | kebab-case, pluriel | `/api/listings`, `/api/visit-guides` |
| Fichiers Dart | snake_case | `listing_repository.dart` |
| Migrations Laravel | snake_case avec timestamp | `2026_01_28_create_listings_table` |

## Ports Sail (développement)

Préfixe 4 pour éviter conflits Docker multi-projets.

| Service | Port |
|---------|------|
| App (HTTP) | 4080 |
| MySQL | 43306 |
| Vite | 45173 |
| Mailpit SMTP | 41025 |
| Mailpit Dashboard | 48025 |

## Patterns obligatoires

- **Repository pattern** : abstraction local (Drift) / remote (API) pour toutes les entités
- **Bloc/Cubit** : un Cubit par feature, pas de setState
- **UUID v4** : pour tous les IDs d'entités (côté client et serveur)
- **Montants en centimes** : tous les montants financiers stockés en `int` (centimes d'euros)
- **folder-by-feature** : chaque feature Flutter dans `lib/features/<nom>/`
- **GoRouter** : routage déclaratif, pas de Navigator.push direct
- **Sanctum RBAC** : token abilities (`owner`, `guest-read`, `guest-extended`)
- **API REST JSON** : pas de versioning, Scramble OpenAPI auto-doc
- **Sync engine** : delta incrémental via `updated_at`, last-write-wins, `POST /api/sync`

## Anti-patterns à éviter

- Pas de `setState()` dans les widgets (utiliser Cubit)
- Pas de logique métier dans les controllers Laravel (utiliser des Services/Actions)
- Pas de requêtes SQL directes dans les controllers (utiliser Eloquent/Repository)
- Pas de `int` auto-increment pour les IDs (UUID v4 uniquement)
- Pas de `double` pour les montants financiers (centimes `int` uniquement)
- Pas de `Navigator.push()` direct (utiliser GoRouter)
- Pas de données en dur dans le code (utiliser les fichiers de config/env)

## Commandes utiles

```bash
# Backend (depuis backend-api/)
./vendor/bin/sail up -d              # Démarrer les conteneurs
./vendor/bin/sail artisan migrate    # Migrations
./vendor/bin/sail artisan test       # Tests PHPUnit
./vendor/bin/pint                    # Formatter PHP (Laravel Pint)
./vendor/bin/phpstan analyse --memory-limit=512M  # Analyse statique (niveau max)

# Frontend (depuis mobile-app/)
flutter analyze                      # Lint
flutter test                         # Tests
flutter run --flavor development --target lib/main_development.dart

# Quality check complet (depuis la racine)
./scripts/quality-check.sh
```
