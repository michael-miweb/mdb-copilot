# Story 0.1 : Initialisation du monorepo et des projets starter

Status: done

## Story

As a développeur,
I want initialiser le monorepo avec le projet Flutter (Very Good CLI) et le projet Laravel 12,
So that l'environnement de développement est prêt pour l'implémentation des features.

## Acceptance Criteria

1. **Given** un répertoire vide `mdb-copilot/`
   **When** le développeur exécute les commandes d'initialisation
   **Then** le monorepo contient `mobile-app/` (Flutter VGV) et `backend-api/` (Laravel 12)
   **And** `mobile-app/` compile sans erreur avec les flavors dev/staging/production
   **And** `backend-api/` répond sur `localhost:4080` via Sail
   **And** le fichier `CLAUDE.md` est présent à la racine avec les conventions IA

## Tasks / Subtasks

- [x] Task 1 : Créer la structure racine du monorepo (AC: #1)
  - [x] 1.1 Créer le répertoire avec `.gitignore` racine
  - [x] 1.2 Initialiser le dépôt Git
  - [x] 1.3 Créer le `README.md` racine avec description projet
  - [x] ~~1.4 Créer le répertoire `.github/workflows/`~~ — Supprimé : Story 0.3 remplacée par config PHPStorm locale, pas de CI/CD distant

- [x] Task 2 : Initialiser le projet Flutter via Very Good CLI (AC: #1)
  - [x] 2.1 Installer Very Good CLI v0.28.0 : `dart pub global activate very_good_cli`
  - [x] 2.2 Générer le projet : `very_good create flutter_app mdb_copilot --desc "MDB Copilot - Assistant Marchand de Bien" --org "com.mdbcopilot"`
  - [x] 2.3 Renommer le dossier généré `mdb_copilot/` en `mobile-app/`
  - [x] 2.4 Vérifier compilation : `flutter analyze` → 0 issues, `flutter test` → 8/8 pass
  - [x] 2.5 Vérifier les flavors dev/staging/production : entry points main_development.dart, main_staging.dart, main_production.dart présents

- [x] Task 3 : Initialiser le projet Laravel 12 (AC: #1)
  - [x] 3.1 Créer le projet : `composer create-project laravel/laravel backend-api` → Laravel v12.49.0
  - [x] 3.2 Installer l'API Sanctum : `php artisan install:api` → Sanctum v4.3.0
  - [x] 3.3 Configurer Sail : `php artisan sail:install --with=mysql` (Sail déjà inclus dans Laravel 12)
  - [x] 3.4 Configurer les ports Sail (préfixe 4) via `.env`
  - [x] 3.5 Configurer `.env` : APP_NAME, APP_URL, DB_DATABASE, ports préfixe 4
  - [x] 3.6 Démarrer Sail et vérifier : `sail up -d` + `curl localhost:4080` → HTTP 200

- [x] Task 4 : Créer le fichier CLAUDE.md (AC: #1)
  - [x] 4.1 Créer `CLAUDE.md` avec conventions complètes (structure, nommage, stack, ports, patterns, anti-patterns, commandes)

- [x] Task 5 : Validation finale (AC: #1)
  - [x] 5.1 Structure vérifiée : `mobile-app/`, `backend-api/`, `CLAUDE.md`, `README.md`, `.gitignore`, `.git/`
  - [x] 5.2 `mobile-app/` compile sans erreur (analyze + test OK)
  - [x] 5.3 `backend-api/` répond via Sail sur port 4080 (HTTP 200)
  - [ ] 5.4 Commit initial (en attente de review)

## Dev Notes

### Architecture & Contraintes

- **Monorepo** : Le projet utilise un monorepo avec deux codebases distinctes communicant via API REST JSON [Source: architecture.md#Project Structure & Boundaries]
- **Flutter starter** : Very Good CLI (Core) avec Bloc pattern, folder-by-feature, lint strictes (Very Good Analysis), flavors dev/staging/production [Source: architecture.md#Starter Template Evaluation]
- **Laravel starter** : Laravel 12 vanilla + Sanctum (via `php artisan install:api`) [Source: architecture.md#Starter Template Evaluation]
- **Sail ports** : Préfixe 4 pour éviter conflits Docker multi-projets [Source: architecture.md#Environnement de développement]

### Versions techniques confirmées

- **Very Good CLI** : v0.26.1 (latest stable) — `dart pub global activate very_good_cli`
- **Laravel** : 12.x — `composer create-project laravel/laravel`
- **Sanctum** : v4.2.2 (inclus via `php artisan install:api`) — nécessite le trait `HasApiTokens` sur le modèle User
- **PHP** : 8.2+ requis
- **Flutter** : 3.38.x

### Commandes Very Good CLI

```bash
# Installation
dart pub global activate very_good_cli

# Création projet (génère structure VGV complète avec flavors)
very_good create flutter_app mdb_copilot \
  --desc "MDB Copilot - Assistant Marchand de Bien" \
  --org "com.mdbcopilot"
```

Le projet généré inclut automatiquement :
- Flavors `development`, `staging`, `production` avec entry points séparés
- Very Good Analysis (lint strictes)
- Structure Bloc-ready
- Infrastructure de tests
- i18n setup

### Configuration Sail — ports

Dans `backend-api/compose.yaml`, modifier la section `laravel.test` :

```yaml
services:
    laravel.test:
        ports:
            - '${APP_PORT:-4080}:80'
            - '${VITE_PORT:-45173}:${VITE_PORT:-45173}'
    mysql:
        ports:
            - '${FORWARD_DB_PORT:-43306}:3306'
```

Dans `backend-api/.env` :
```
APP_PORT=4080
FORWARD_DB_PORT=43306
VITE_PORT=45173
FORWARD_MAILPIT_PORT=41025
FORWARD_MAILPIT_DASHBOARD_PORT=48025
```

### Project Structure Notes

Structure cible après cette story :

```
mdb-copilot/
├── .github/
│   └── workflows/          # Vide, préparé pour Story 0.3
├── _bmad/                   # Déjà existant
├── _bmad-output/            # Déjà existant
├── backend-api/             # Laravel 12 + Sail
│   ├── compose.yaml         # Sail avec ports préfixe 4
│   ├── .env
│   └── ...
├── mobile-app/              # Flutter VGV
│   ├── pubspec.yaml
│   ├── lib/
│   │   ├── main_development.dart
│   │   ├── main_staging.dart
│   │   └── main_production.dart
│   └── ...
├── CLAUDE.md                # Conventions IA
├── README.md
└── .gitignore
```

- La structure est conforme à l'architecture.md section "Structure racine monorepo" [Source: architecture.md#Project Structure & Boundaries]
- Note : `_bmad/` et `_bmad-output/` existent déjà dans le répertoire courant. Le monorepo sera créé à côté ou englobera le projet existant selon la décision du dev.

### References

- [Source: architecture.md#Starter Template Evaluation] — Sélection Very Good CLI + Laravel 12
- [Source: architecture.md#Environnement de développement] — Configuration Sail ports préfixe 4
- [Source: architecture.md#Project Structure & Boundaries] — Structure monorepo complète
- [Source: architecture.md#Implementation Patterns & Consistency Rules] — Conventions nommage
- [Source: architecture.md#Enforcement Guidelines] — Règles obligatoires agents IA
- [Source: epics.md#Story 0.1] — Acceptance criteria BDD

## Dev Agent Record

### Agent Model Used

Claude Opus 4.5 (claude-opus-4-5-20251101)

### Debug Log References

- MySQL container needed volume recreation after DB_DATABASE change from `laravel` to `mdb_copilot`
- VGV CLI v0.28.0 no longer has `very_good analyze` command — used `flutter analyze` directly
- Task 1.4 (.github/workflows/) skipped — Story 0.3 modified to use local PHPStorm quality tools instead of GitHub Actions CI/CD

### Completion Notes List

- ✅ Monorepo structure created at `/Users/mika/Forge/mdb-tools/` (using existing project root, not a subdirectory)
- ✅ Flutter VGV project generated with 229 files, 3 flavors, 8 passing tests
- ✅ Laravel 12.49.0 installed with Sanctum v4.3.0, Sail with MySQL 8.4
- ✅ Sail ports configured with prefix 4 (APP_PORT=4080, FORWARD_DB_PORT=43306, etc.)
- ✅ CLAUDE.md created with comprehensive conventions
- ⚠️ Task 1.4 (.github/workflows/) intentionally skipped — no longer relevant per Story 0.3 update

### File List

- `.gitignore` — NEW (+ MODIFIED: ajout database.sqlite exclusion)
- `README.md` — NEW
- `CLAUDE.md` — NEW (+ MODIFIED: PHPStan commenté car pas encore installé)
- `mobile-app/` — NEW (Flutter VGV project, 229 files)
- `backend-api/` — NEW (Laravel 12 project)
- `backend-api/.env` — MODIFIED (APP_NAME, APP_URL, APP_PORT, DB_DATABASE, ports prefix 4, locales fr)
- `backend-api/.env.example` — MODIFIED (aligné avec .env : MySQL, ports prefix 4, locales fr)
- `backend-api/compose.yaml` — MODIFIED (fallback ports prefix 4)
- `backend-api/app/Models/User.php` — MODIFIED (ajout HasApiTokens trait)
- `backend-api/routes/api.php` — MODIFIED (ajout route /api/health)

## Senior Developer Review (AI)

**Date :** 2026-01-28
**Reviewer :** Claude Opus 4.5 (code-review adversarial)
**Outcome :** Approve (after fixes)

### Action Items

- [x] [HIGH] Ajouter `HasApiTokens` trait au modèle User (backend-api/app/Models/User.php)
- [x] [HIGH] Mettre à jour `.env.example` avec la config Sail (ports prefix 4, MySQL, APP_NAME)
- [x] [HIGH] `.gitignore` exclut `.env` — `.env.example` doit être la référence correcte
- [x] [MEDIUM] `compose.yaml` fallback ports mis à prefix 4 (4080, 45173, 43306)
- [x] [MEDIUM] Ajouter route `/api/health` pour healthcheck
- [x] [MEDIUM] Exclure `database/database.sqlite` du `.gitignore`
- [x] [LOW] Locales fr/fr_FR dans `.env` et `.env.example`
- [x] [LOW] CLAUDE.md : commenter PHPStan (pas encore installé)
