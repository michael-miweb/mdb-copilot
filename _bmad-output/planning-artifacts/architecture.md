---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
inputDocuments:
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/product-brief-mdb-copilot-2026-01-27.md
  - _bmad-output/planning-artifacts/ux-design-specification.md
revisedAt: '2026-01-29'
revisionNote: 'UX Design integration — Material 3, custom palette, 7 custom components, AdaptiveScaffold, WCAG 2.1 AA'
workflowType: 'architecture'
lastStep: 8
status: 'complete'
completedAt: '2026-01-27'
project_name: 'mdb-tools'
user_name: 'Michael'
date: '2026-01-27'
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements (49 FRs, 13 capability areas) :**

Les FRs se regroupent architecturalement en 4 domaines :

1. **Data Management** (Fiches, Pipeline, Photos) — CRUD, statuts, stockage binaire
2. **Field Operations** (Checklist, Guide visite, Synthèse) — offline-critical, capture terrain
3. **Analysis & Education** (Score, TVA, Fiscalité, Mémos) — logique métier, contenu statique
4. **Collaboration** (Auth, Partage, Rôles) — multi-utilisateur, accès contrôlé

**Non-Functional Requirements architecturalement structurants :**

| NFR | Impact architectural |
|-----|---------------------|
| Offline-first | Base de données locale + sync engine + conflict resolution |
| Performance < 2s | Rendu natif Flutter, pas de surcharge réseau au chargement |
| Sanctum + RBAC | Auth service, middleware de permissions, token abilities, token public pour partage |
| RGPD | Consentement, suppression, chiffrement local |
| 99% disponibilité | Résilience naturelle via offline, backend simple |

**Scale & Complexity :**

- Domaine primaire : Full-stack mobile-first (Flutter front + Laravel back)
- Niveau de complexité : Moyen
- Composants architecturaux estimés : 8-10 (auth, API REST, DB, sync engine, DVF proxy, photo storage, offline DB, business logic)

### Technical Constraints & Dependencies

- **Flutter (Dart)** côté client : mobile natif iOS/Android + web
- **Laravel (PHP)** côté serveur : API REST, auth, business logic serveur, proxy DVF
- **Stack hétérogène** : Flutter ↔ Laravel via API REST JSON
- **OVH serveur privé** : hébergement imposé, Laravel natif sur serveur dédié
- **DVF data.gouv.fr** : API externe, données avec ~6 mois de retard, proxy Laravel
- **Material 3** : design system unique, palette Violet/Magenta (light) + Indigo/Orchidée (dark), Inter font, Material Symbols Rounded, AdaptiveScaffold responsive, WCAG 2.1 AA
- **Développement assisté par agents IA** : architecture claire, conventions strictes, séparation nette des responsabilités pour faciliter le travail des agents

### Cross-Cutting Concerns

| Concern | Composants impactés |
|---------|--------------------|
| **Offline sync** | Toutes les fiches, checklists, guide visite, photos, DVF cache |
| **Auth & permissions** | Laravel API, middleware, partage public, accès invité |
| **Photo management** | Guide visite, fiches annonces, partage artisan |
| **Business logic** | Score d'opportunité (client+serveur), simulateur TVA (client), synthèse post-visite (client) |
| **Contenu statique** | Fiches mémo, guide fiscalité, checklist templates |
| **API contract** | Interface Flutter ↔ Laravel, versioning, validation |

## Starter Template Evaluation

### Domaine technologique principal

**Full-stack hétérogène** : Flutter 3.38.x (multi-platform) + Laravel 12.x (API backend), deux codebases distinctes communicant via API REST JSON.

### Options évaluées — Client Flutter

| Starter | State Mgmt | Architecture | Maintenance | Verdict |
|---------|-----------|-------------|-------------|---------|
| **Very Good CLI (Core)** | Bloc | Clean, folder-by-feature | ✅ Actif (Very Good Ventures) | **Retenu** |
| Momentous Flutter Starter | Riverpod | Clean arch + Material 3 | ⚠️ Community | Non retenu |
| GeekyAnts Flutter Starter | Bloc | Feature-based | ⚠️ Sporadique | Non retenu |
| `flutter create` vanilla | Aucun | Minimale | ✅ Officiel | Trop minimaliste |

### Options évaluées — Base de données locale (offline-first)

| DB | Type | Offline-first | Maintenance | Verdict |
|----|------|--------------|-------------|---------|
| **Drift** (SQLite) | Relationnel, type-safe | ✅ Excellent | ✅ Actif | **Retenu** |
| Hive | Key-value | ⚠️ Limité | ⚠️ Abandonné par auteur | Non retenu |
| Isar | NoSQL performant | ✅ Bon | ❌ Abandonné, core Rust | Non retenu |
| sqflite | SQL brut | ✅ Bon | ✅ Actif | Trop bas niveau |

### Options évaluées — Authentification backend

| Approche | Type | Maintenu par | Verdict |
|----------|------|-------------|---------|
| **Laravel Sanctum** | Token API, abilities | Laravel (officiel) | **Retenu** |
| php-open-source-saver/jwt-auth | JWT stateless | Communauté | Non retenu |
| Laravel Passport | OAuth2 complet | Laravel | Overkill |

**Rationale Sanctum** : officiel Laravel, révocation simple (delete en DB), token abilities natif pour RBAC (owner/guest/guest-extended), multi-device natif, zéro dépendance tierce.

### Sélection retenue

#### Flutter — Very Good CLI (Core)

```bash
dart pub global activate very_good_cli
very_good create flutter_app mdb_copilot --desc "MDB Copilot - Assistant Marchand de Bien" --org "com.mdbcopilot"
```

**Décisions architecturales fournies :**

- **Langage** : Dart avec lint strictes (Very Good Analysis)
- **State management** : Bloc pattern
- **Structure** : folder-by-feature, packages séparés
- **Build** : flavors dev/staging/production
- **i18n** : support intégré (FR)
- **Tests** : infrastructure 100% coverage

#### Laravel 12 — Sail (dev) + Octane/FrankenPHP (prod)

```bash
composer create-project laravel/laravel mdb-copilot-api
cd mdb-copilot-api
php artisan install:api  # Sanctum inclus
```

**Décisions architecturales fournies :**

- **Langage** : PHP 8.2+
- **Auth** : Sanctum (token API, abilities pour RBAC)
- **API** : routes `api.php`, middleware `auth:sanctum`
- **Structure** : MVC standard Laravel
- **DB serveur** : MySQL 8.x

#### Environnement de développement — Laravel Sail

Convention multi-projet : préfixe port **4** pour éviter les conflits Docker.

| Service | Port interne | Port externe |
|---------|-------------|-------------|
| App (HTTP) | 80 | **4080** |
| MySQL | 3306 | **43306** |
| Vite | 5173 | **45173** |
| Mailpit SMTP | 1025 | **41025** |
| Mailpit Dashboard | 8025 | **48025** |

#### Production — Docker (OVH serveur privé)

Stack de production sur le modèle `meal-planner/backend-api` :

- **Dockerfile** : FrankenPHP + Octane, image Alpine optimisée
- **docker-compose.prod.yml** : app + MySQL + queue worker + scheduler, réseau `docker_internal`
- **deploy.sh** : build multi-tag → push vers `docker-registry.miweb.fr/mdb-copilot-api`
- **Watchtower** : auto-deploy sur le serveur de production
- **docker/php/php.ini** : config production (opcache, JIT, timezone Europe/Paris)

#### DB locale Flutter — Drift

- Données structurées (fiches, checklists, pipeline) avec type-safety
- Chiffrement via `sqlcipher_flutter_libs` (RGPD)
- Migrations type-safe, reactive streams pour le UI
- Synchronisation background avec le backend Laravel

**Note :** L'initialisation des projets (Flutter + Laravel + Docker) fera l'objet d'un **epic DevOps dédié** incluant : setup Sail, Dockerfile prod, scripts de build/deploy, configuration CI.

## Core Architectural Decisions

### Decision Priority Analysis

**Décisions critiques (bloquent l'implémentation) :**
- Data sync strategy (last-write-wins, delta incrémental)
- Auth Sanctum + RBAC + partage public
- Drift + SQLCipher pour offline-first
- API REST v1 avec endpoint sync batch

**Décisions importantes (structurent l'architecture) :**
- Repository pattern (abstraction local/remote)
- Package UI dédié (mdb_ui) pour design system
- OpenAPI auto-doc via Scramble
- Qualité code locale via PHPStorm (PHPStan, Pint, PHPUnit, Very Good CLI)

**Décisions différées (post-MVP) :**
- Monitoring avancé (Sentry, metrics)
- Scaling horizontal
- WebSocket / real-time (si collaboration live nécessaire)

### Data Architecture

| Décision | Choix | Rationale |
|----------|-------|-----------|
| DB serveur | MySQL 8.x | Standard Laravel, OVH compatible |
| DB locale | Drift (SQLite) + SQLCipher | Type-safe, chiffré, RGPD |
| Sync | Delta incrémental via `updated_at` | Simple, adapté mono-utilisateur |
| Conflit | Last-write-wins | Risque quasi nul (usage solo principal) |
| Cache DVF | Cache DB Laravel, TTL 24h | Pas besoin Redis à cette échelle |
| Soft deletes | Oui, entités principales | RGPD : purge programmée |
| Photos | Upload queue background, placeholder local | UX fluide offline |

### Authentication & Security

| Décision | Choix | Rationale |
|----------|-------|-----------|
| Auth | Laravel Sanctum | Officiel, token abilities, révocation simple |
| RBAC | Token abilities : `owner`, `guest-read`, `guest-extended` | Natif Sanctum |
| Partage public | Token signé durée limitée, abilities restreintes | Pas de compte pour artisan |
| Chiffrement local | SQLCipher + flutter_secure_storage | Keychain/Keystore natif |
| API security | HTTPS, validation request classes, rate limit 60/min | Défenses standard Laravel |
| RGPD | Endpoint suppression, purge données, consentement | Conformité réglementaire |

### API & Communication Patterns

| Décision | Choix | Rationale |
|----------|-------|-----------|
| Style API | REST JSON | Simple, suffisant, bien outillé |
| Versioning | Pas de versioning, routes `/api/*` directes | Projet mono-client, simplicité |
| Erreurs | JSON standardisé `{ message, errors, code }` | Cohérence, parsing client simple |
| Documentation | Scramble (OpenAPI auto) | Auto-généré, utile pour agents IA |
| Sync | `POST /api/sync` batch | Delta up + down en une requête |

### Frontend Architecture

| Décision | Choix | Rationale |
|----------|-------|-----------|
| State management | Bloc / Cubit par feature | Very Good CLI standard |
| Data layer | Repository pattern (local + remote) | Abstraction offline/online |
| Routing | GoRouter | Standard VGV, déclaratif |
| Design system | Material 3 + `flutter_adaptive_scaffold` + package `mdb_ui` | M3 pur, NavBar < 600dp / NavRail ≥ 600dp, 7 composants custom MDB |
| Photos | image_picker + compression + upload queue | UX fluide offline |

### Infrastructure & Deployment

| Décision | Choix | Rationale |
|----------|-------|-----------|
| Dev local | Laravel Sail, préfixe port 4 | Convention multi-projet Docker |
| Prod | Octane + FrankenPHP, image Docker Alpine | Performance, OVH dédié |
| Deploy | deploy.sh → registry privé → Watchtower | Auto-deploy sur push |
| Qualité code | PHPStorm (PHPStan, Pint, PHPUnit, VGV) | Tout en local, pas de CI distant |
| Environnements | dev / staging / prod | Staging sur même OVH |
| Monitoring V1 | Logs Laravel (fichier + stderr) | Suffisant pour démarrer |

### Decision Impact Analysis

**Séquence d'implémentation :**
1. Epic DevOps : Sail + Docker + deploy + CI
2. Auth Sanctum + modèle User + RBAC
3. Modèle de données + migrations MySQL
4. Drift schema local + sync engine
5. API REST v1 endpoints
6. Features métier (fiches, pipeline, checklists...)
7. Package mdb_ui + intégration design system

**Dépendances cross-composants :**
- Sync engine dépend de : schema Drift + API endpoints + Auth
- Repository pattern dépend de : Drift + API client
- Partage public dépend de : Auth tokens + API endpoints
- Design system dépend de : aucune autre décision (parallélisable)

## Implementation Patterns & Consistency Rules

### Naming Patterns

**Base de données (Laravel/MySQL) :**
- Tables : `snake_case`, pluriel → `properties`, `checklist_items`, `visit_guide_responses`
- Colonnes : `snake_case` → `created_at`, `property_id`, `sale_urgency`
- Foreign keys : `{table_singulier}_id` → `property_id`, `user_id`
- Index : `{table}_{colonnes}_index` → `properties_status_index` (convention Laravel par défaut)
- Pivot tables : alphabétique singulier → `property_user`

**API (JSON entre Flutter ↔ Laravel) :**
- Endpoints : pluriel, `snake_case` → `/api/properties`, `/api/checklist_items`
- Paramètres route : `{property}` (convention Laravel resource)
- Query params : `snake_case` → `?page=1&per_page=20&sort_by=created_at`
- JSON fields : `snake_case` (convention Laravel API Resource, Dart les accepte nativement)

**Code Dart (Flutter) :**
- Classes : `PascalCase` → `PropertyRepository`, `ChecklistCubit`
- Fichiers : `snake_case` → `property_repository.dart`, `checklist_cubit.dart`
- Variables/fonctions : `camelCase` → `propertyId`, `getVisitGuide()`
- Constantes : `camelCase` → `defaultPageSize`
- Enums : `PascalCase.camelCase` → `PropertyStatus.underAnalysis`

**Code PHP (Laravel) :**
- Classes : `PascalCase` → `PropertyController`, `ChecklistService`
- Fichiers : `PascalCase` → `PropertyController.php` (PSR-4)
- Variables/fonctions : `camelCase` → `$propertyId`, `getVisitGuide()`
- Config keys : `snake_case` → `config('mdb.dvf_cache_ttl')`

### Structure Patterns

**Flutter (folder-by-feature, VGV) :**

```
lib/
├── app/                    # App-level (routing, theme, DI)
├── features/
│   ├── auth/
│   │   ├── data/           # Repository, data sources, models
│   │   ├── domain/         # Entities, use cases (si nécessaire)
│   │   └── presentation/   # Cubits, widgets, pages
│   ├── properties/
│   ├── checklist/
│   ├── visit_guide/
│   ├── pipeline/
│   ├── dvf/
│   ├── memo_cards/
│   └── sharing/
├── core/                   # Shared : sync engine, API client, DB
└── l10n/                   # Traductions
packages/
└── mdb_ui/                 # Design system Material 3 + 7 composants custom
test/
├── features/               # Miroir de lib/features/
└── core/
```

**Laravel :**

```
app/
├── Http/
│   ├── Controllers/Api/V1/   # Un controller par resource
│   ├── Requests/              # Form requests validation
│   └── Resources/             # API Resources (JSON transform)
├── Models/                    # Eloquent models
├── Services/                  # Business logic (DVF proxy, scoring)
├── Repositories/              # Si abstraction DB nécessaire
└── Events/                    # Domain events
database/migrations/
routes/api.php                 # Toutes les routes API v1
tests/Feature/                 # Tests API
tests/Unit/                    # Tests unitaires services
docker/                        # Config Docker prod
```

### Format Patterns

**Réponse API succès :**

```json
{
  "data": { "..." },
  "meta": { "current_page": 1, "total": 42 }
}
```

**Réponse API erreur :**

```json
{
  "message": "La fiche n'existe pas.",
  "errors": { "property_id": ["Ce champ est invalide."] },
  "code": "VALIDATION_ERROR"
}
```

**Conventions data :**
- Dates : ISO 8601 string `"2026-01-27T14:30:00Z"` partout
- Booleans : `true`/`false` (jamais 1/0)
- Null : explicite, jamais string vide pour représenter absence
- IDs : UUID v4 string (pour sync offline sans collision)
- Monnaie : integer centimes `150000` = 1500,00 €

### Communication Patterns

**Bloc/Cubit (Flutter) :**
- States : `{Feature}State` avec `{Feature}Initial`, `{Feature}Loading`, `{Feature}Loaded`, `{Feature}Error`
- Events (si Bloc) : `{Feature}{Action}` → `PropertiesLoadRequested`, `PropertyCreated`
- Un Cubit par feature sauf si event-driven complexe → Bloc

**Laravel Events :**
- Naming : `PascalCase` → `PropertyCreated`, `VisitGuideCompleted`
- Payload : l'entité Eloquent complète
- Listeners dans `EventServiceProvider`

### Process Patterns

**Error handling Flutter :**
- Repository catch les exceptions réseau → retourne `Either<Failure, T>` ou lance `AppException` typée
- Cubit catch → émet `{Feature}Error(message)`
- UI affiche via `BlocListener`

**Error handling Laravel :**
- Form Request pour validation → 422 auto
- Exceptions custom dans `app/Exceptions/` → `PropertyNotFoundException`
- Handler global → JSON formaté

**Loading states :**
- Flutter : toujours via Bloc state (`isLoading` dans le state, ou state dédié `Loading`)
- Skeleton/shimmer UI pendant chargement, pas de spinner plein écran

**Sync offline :**
- Chaque write local marque l'entité `syncStatus: pending`
- Background isolate tente sync quand connectivité détectée
- En cas d'échec réseau : retry avec backoff exponentiel
- UI affiche indicateur sync status discret

### Enforcement Guidelines

**Tous les agents IA DOIVENT :**
1. Suivre les conventions de nommage exactes (snake_case API/DB, camelCase Dart, PascalCase classes)
2. Utiliser les UUID v4 pour tous les IDs d'entités
3. Créer les tests correspondants à chaque feature (test/ miroir de lib/)
4. Utiliser le Repository pattern pour tout accès données
5. Ne jamais accéder directement à l'API ou à Drift depuis les Cubits
6. Formatter les montants en centimes integer
7. Documenter les endpoints via API Resources Laravel (Scramble les introspect)

**Anti-patterns à éviter :**
- ❌ Logique métier dans les Controllers (→ Services)
- ❌ Accès DB direct dans les Cubits (→ Repository)
- ❌ Dates en format custom (→ ISO 8601 uniquement)
- ❌ IDs auto-increment côté client (→ UUID v4)
- ❌ Strings pour les montants (→ int centimes)
- ❌ Catch silencieux sans log ni state error

## Project Structure & Boundaries

### Structure racine monorepo

```
mdb-copilot/
├── _bmad/
├── _bmad-output/
├── backend-api/                    # Laravel 12 API
├── mobile-app/                     # Flutter multi-platform
├── CLAUDE.md                       # Conventions pour agents IA
└── README.md
```

### Structure Flutter — `mobile-app/`

```
mobile-app/
├── pubspec.yaml
├── analysis_options.yaml
├── l10n.yaml
├── lib/
│   ├── main_development.dart
│   ├── main_staging.dart
│   ├── main_production.dart
│   ├── app/
│   │   ├── app.dart
│   │   ├── routes.dart
│   │   └── di.dart
│   ├── core/
│   │   ├── api/
│   │   │   ├── api_client.dart
│   │   │   ├── api_interceptors.dart
│   │   │   └── api_endpoints.dart
│   │   ├── db/
│   │   │   ├── app_database.dart
│   │   │   ├── app_database.g.dart
│   │   │   └── tables/
│   │   │       ├── properties_table.dart
│   │   │       ├── checklists_table.dart
│   │   │       ├── visit_guides_table.dart
│   │   │       ├── photos_table.dart
│   │   │       ├── memo_cards_table.dart
│   │   │       └── pipeline_stages_table.dart
│   │   ├── sync/
│   │   │   ├── sync_engine.dart
│   │   │   ├── sync_status.dart
│   │   │   └── connectivity_monitor.dart
│   │   ├── error/
│   │   │   ├── app_exception.dart
│   │   │   └── failure.dart
│   │   └── constants/
│   │       └── app_constants.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── auth_repository.dart
│   │   │   │   ├── auth_remote_source.dart
│   │   │   │   └── models/
│   │   │   │       └── user_model.dart
│   │   │   └── presentation/
│   │   │       ├── cubit/
│   │   │       │   ├── auth_cubit.dart
│   │   │       │   └── auth_state.dart
│   │   │       └── pages/
│   │   │           └── login_page.dart
│   │   ├── properties/
│   │   │   ├── data/
│   │   │   │   ├── property_repository.dart
│   │   │   │   ├── property_local_source.dart
│   │   │   │   ├── property_remote_source.dart
│   │   │   │   └── models/
│   │   │   │       └── property_model.dart
│   │   │   └── presentation/
│   │   │       ├── cubit/
│   │   │       ├── pages/
│   │   │       └── widgets/
│   │   ├── pipeline/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   ├── checklist/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   ├── visit_guide/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   ├── post_visit_summary/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   ├── dvf/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   ├── memo_cards/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   ├── scoring/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   ├── vat_simulator/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   ├── tax_guide/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   └── sharing/
│   │       ├── data/
│   │       └── presentation/
│   └── l10n/
│       ├── arb/
│       │   └── app_fr.arb
│       └── l10n.dart
├── packages/
│   └── mdb_ui/
│       ├── pubspec.yaml              # depends on flutter_adaptive_scaffold, google_fonts, material_symbols_icons
│       ├── lib/
│       │   ├── mdb_ui.dart
│       │   ├── theme/
│       │   │   ├── mdb_theme.dart          # ColorScheme.fromSeed + dark overrides
│       │   │   ├── mdb_light_theme.dart    # Violet/Magenta palette
│       │   │   └── mdb_dark_theme.dart     # Indigo/Orchidée palette custom
│       │   ├── tokens/
│       │   │   ├── colors.dart             # Full scales light + dark
│       │   │   ├── typography.dart         # Inter font, M3 type scale
│       │   │   └── spacing.dart            # 4/8/12/16/24px
│       │   └── widgets/
│       │       ├── mdb_score_card.dart
│       │       ├── mdb_kanban_board.dart
│       │       ├── mdb_kanban_column.dart
│       │       ├── mdb_kanban_card.dart
│       │       ├── mdb_visit_guide_category.dart
│       │       ├── mdb_guided_question.dart
│       │       ├── mdb_post_visit_summary.dart
│       │       ├── mdb_dvf_comparator.dart
│       │       ├── mdb_offline_sync_indicator.dart
│       │       └── mdb_property_card.dart
│       └── test/
├── test/
│   ├── features/
│   │   ├── auth/
│   │   ├── properties/
│   │   ├── pipeline/
│   │   ├── checklist/
│   │   ├── visit_guide/
│   │   ├── dvf/
│   │   ├── scoring/
│   │   └── sharing/
│   ├── core/
│   │   ├── sync/
│   │   └── api/
│   └── helpers/
│       ├── mock_api_client.dart
│       └── test_helpers.dart
└── integration_test/
```

### Structure Laravel — `backend-api/`

```
backend-api/
├── composer.json
├── artisan
├── phpunit.xml
├── compose.yaml
├── docker-compose.prod.yml
├── Dockerfile
├── deploy.sh
├── .env.example
├── docker/
│   └── php/
│       └── php.ini
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       ├── AuthController.php
│   │   │       ├── PropertyController.php
│   │   │       ├── ChecklistController.php
│   │   │       ├── VisitGuideController.php
│   │   │       ├── PipelineController.php
│   │   │       ├── DvfController.php
│   │   │       ├── MemoCardController.php
│   │   │       ├── PhotoController.php
│   │   │       ├── ScoringController.php
│   │   │       ├── ShareController.php
│   │   │       └── SyncController.php
│   │   ├── Requests/
│   │   │   ├── StorePropertyRequest.php
│   │   │   ├── UpdatePropertyRequest.php
│   │   │   ├── StoreChecklistRequest.php
│   │   │   └── ...
│   │   ├── Resources/
│   │   │   ├── PropertyResource.php
│   │   │   ├── ChecklistResource.php
│   │   │   ├── VisitGuideResource.php
│   │   │   └── ...
│   │   └── Middleware/
│   │       └── EnsureTokenAbility.php
│   ├── Models/
│   │   ├── User.php
│   │   ├── Property.php
│   │   ├── Checklist.php
│   │   ├── ChecklistItem.php
│   │   ├── VisitGuide.php
│   │   ├── VisitGuideResponse.php
│   │   ├── Photo.php
│   │   ├── PipelineStage.php
│   │   ├── MemoCard.php
│   │   └── ShareToken.php
│   ├── Services/
│   │   ├── DvfService.php
│   │   ├── ScoringService.php
│   │   ├── SyncService.php
│   │   ├── ShareService.php
│   │   └── PhotoService.php
│   ├── Events/
│   │   ├── PropertyCreated.php
│   │   ├── VisitGuideCompleted.php
│   │   └── SyncCompleted.php
│   └── Exceptions/
│       ├── PropertyNotFoundException.php
│       └── DvfUnavailableException.php
├── database/
│   ├── migrations/
│   ├── seeders/
│   │   └── MemoCardSeeder.php
│   └── factories/
├── routes/
│   ├── api.php
│   └── console.php
├── storage/
│   └── app/
│       └── photos/
├── tests/
│   ├── Feature/
│   │   ├── Auth/
│   │   ├── Property/
│   │   ├── Checklist/
│   │   ├── Dvf/
│   │   ├── Sync/
│   │   └── Share/
│   └── Unit/
│       ├── Services/
│       └── Models/
└── vendor/
```

### Architectural Boundaries

**API Boundary** : `routes/api.php` — toute communication Flutter ↔ Laravel passe par `/api/*`. Aucun accès direct DB depuis Flutter.

**Data Boundary** :
- Flutter : Drift (local) ↔ Repository ↔ Cubit ↔ UI
- Laravel : Eloquent (MySQL) ↔ Service ↔ Controller ↔ API Resource → JSON

**Sync Boundary** : `POST /api/sync` est l'unique point d'échange de données. Le `SyncEngine` Flutter et le `SyncService` Laravel sont les seuls composants qui gèrent la synchronisation.

**Auth Boundary** : Sanctum middleware sur toutes les routes API sauf `/api/auth/login`, `/api/auth/register`, et `/api/share/{token}` (accès public).

**Photo Boundary** : Upload via `POST /api/photos`, stockage `storage/app/photos/`, accès via signed URL Laravel. Côté Flutter, photos en cache local + upload queue.

### Requirements → Structure Mapping

| Feature (PRD) | Flutter feature/ | Laravel Controller | Drift Table |
|---------------|-----------------|-------------------|-------------|
| Auth | `auth/` | `AuthController` | — |
| Fiches annonces | `properties/` | `PropertyController` | `properties_table` |
| Pipeline Kanban | `pipeline/` | `PipelineController` | `pipeline_stages_table` |
| Checklist pré-visite | `checklist/` | `ChecklistController` | `checklists_table` |
| Guide visite | `visit_guide/` | `VisitGuideController` | `visit_guides_table` |
| Synthèse post-visite | `post_visit_summary/` | — (client-only) | — |
| Fiches mémo | `memo_cards/` | `MemoCardController` | `memo_cards_table` |
| Score d'opportunité | `scoring/` | `ScoringController` | — |
| DVF | `dvf/` | `DvfController` | — (cache Laravel) |
| Simulateur TVA | `vat_simulator/` | — (client-only) | — |
| Guide fiscalité | `tax_guide/` | — (client-only) | — |
| Partage | `sharing/` | `ShareController` | — |
| Mode offline | `core/sync/` | `SyncController` | toutes tables |
| Photos | (dans visit_guide + properties) | `PhotoController` | `photos_table` |

### External Integrations

| Service | Point d'intégration | Boundary |
|---------|-------------------|----------|
| DVF data.gouv.fr | `DvfService` → API HTTP | Laravel proxy + cache 24h |
| Docker Registry | `deploy.sh` → `docker-registry.miweb.fr` | Build & push |
| Watchtower | Prod server | Auto-pull images |

## Architecture Validation Results

### Coherence Validation ✅

**Compatibilité des décisions :**
- Flutter 3.38 + Dart ↔ Laravel 12 + PHP 8.2 via REST JSON : stack hétérogène standard, aucun conflit
- Drift (SQLite) côté client + MySQL côté serveur : sync via delta endpoint, cohérent
- Sanctum tokens + RBAC abilities : compatible Flutter (stockage token via `flutter_secure_storage`)
- Bloc/Cubit + Repository pattern + Drift : chaîne bien définie, pas de court-circuit
- Sail dev + FrankenPHP prod : même codebase Laravel, environnements isolés
- Material 3 + `flutter_adaptive_scaffold` : NavigationBar (mobile < 600dp) / NavigationRail (desktop ≥ 600dp), palette custom Violet/Magenta light + Indigo/Orchidée dark, Inter font, Material Symbols Rounded, WCAG 2.1 AA

**Consistance patterns :** snake_case DB/API/JSON, camelCase Dart, PascalCase classes — conventions standard des deux écosystèmes. Aucune friction.

**Alignement structure :** Monorepo `mdb-copilot/` avec `mobile-app/` + `backend-api/`, CI séparée, deploy indépendant — calqué sur meal-planner.

### Requirements Coverage ✅

**49 FRs couverts par les 13 features mappées :**

| Domaine PRD | Features Flutter | Support backend | Status |
|-------------|-----------------|----------------|--------|
| Data Management | properties, pipeline, photos | PropertyController, PipelineController, PhotoController | ✅ |
| Field Operations | checklist, visit_guide, post_visit_summary | ChecklistController, VisitGuideController | ✅ |
| Analysis & Education | scoring, vat_simulator, tax_guide, memo_cards | ScoringController, MemoCardController | ✅ |
| Collaboration | auth, sharing | AuthController, ShareController | ✅ |

3 features client-only (post_visit_summary, vat_simulator, tax_guide) : logique embarquée, cohérent offline-first.

**NFRs couverts :**
- Offline-first : Drift + SyncEngine + connectivity monitor ✅
- Performance < 2s : rendu natif Flutter, données locales ✅
- Sanctum + RBAC : token abilities owner/guest-read/guest-extended ✅
- RGPD : SQLCipher, endpoint suppression, soft deletes + purge ✅
- 99% disponibilité : offline-first = résilience naturelle ✅

### Implementation Readiness ✅

- Toutes les décisions critiques documentées avec choix + version + rationale
- Arbre projet détaillé pour les deux codebases
- Patterns naming/structure/format/communication/process complets avec exemples et anti-patterns
- Epic DevOps identifié pour bootstrap de l'environnement

### Gap Analysis

**Gaps critiques :** Aucun.

**Gaps importants (à détailler dans les epics) :**
- Schéma Drift détaillé (colonnes exactes) → epic Data Model
- Contenu exact des fiches mémo → epic Memo Cards
- ~~Design tokens MDB précis~~ → **Résolu** : UX Design Specification complète (palette, typo, spacing, composants)

**Gaps nice-to-have (post-MVP) :**
- Monitoring Sentry
- Rate limiting custom par endpoint
- WebSocket pour collaboration real-time

### Architecture Completeness Checklist

- [x] Contexte projet analysé
- [x] Contraintes techniques identifiées
- [x] Stack technologique complet (Flutter 3.38 + Laravel 12 + Drift + Sanctum + Sail + FrankenPHP + Material 3 + AdaptiveScaffold)
- [x] UX Design Specification intégrée (palette, composants custom, responsive, accessibilité WCAG 2.1 AA)
- [x] Décisions critiques documentées avec versions
- [x] Patterns d'implémentation définis
- [x] Conventions de nommage établies
- [x] Structure projet complète (monorepo, deux codebases)
- [x] Boundaries architecturales définies
- [x] Mapping requirements → structure
- [x] Intégrations externes documentées
- [x] Epic DevOps identifié (Sail + Docker + deploy + CI)

### Architecture Readiness Assessment

**Status : READY FOR IMPLEMENTATION**

**Confiance : Haute**

**Forces :**
- Stack éprouvée, pas de technologie expérimentale
- Conventions alignées sur les standards des deux écosystèmes
- Offline-first bien structuré (Drift + SyncEngine)
- DevOps calqué sur un projet existant (meal-planner)
- Material 3 pur + AdaptiveScaffold (NavBar < 600dp / NavRail ≥ 600dp)
- UX Design Specification complète : palette custom, 7 composants, WCAG 2.1 AA
- Patterns clairs pour les agents IA

**Améliorations futures :**
- Monitoring et alerting (Sentry, metrics)
- Tests E2E cross-platform
- Scaling si commercialisation
