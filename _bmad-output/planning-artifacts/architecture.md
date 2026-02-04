---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
inputDocuments:
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/product-brief-mdb-copilot-2026-01-27.md
  - _bmad-output/planning-artifacts/ux-design-specification.md
revisedAt: '2026-02-03'
revisionNote: 'Pivot technologique Flutter → React Native + React Web'
previousRevision:
  date: '2026-01-29'
  note: 'UX Design integration — Material 3, custom palette, 7 custom components, AdaptiveScaffold, WCAG 2.1 AA'
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

**Functional Requirements (63 FRs, 14 capability areas) :**

Les FRs se regroupent architecturalement en 4 domaines :

1. **Data Management** (Fiches, Pipeline, Photos, Contacts) — CRUD, statuts, stockage binaire
2. **Field Operations** (Checklist, Guide visite, Synthèse) — offline-critical, capture terrain
3. **Analysis & Education** (Score, TVA, Fiscalité, Mémos) — logique métier, contenu statique
4. **Collaboration & Onboarding** (Auth, Partage, Rôles, Import lien, Tour guidé) — multi-utilisateur, accès contrôlé

**Non-Functional Requirements architecturalement structurants :**

| NFR | Impact architectural |
|-----|---------------------|
| Offline-first | Base de données locale (mobile + web) + sync engine + conflict resolution |
| Performance < 2s | Rendu natif React Native, données locales au chargement |
| Sanctum + RBAC | Auth service, middleware de permissions, token abilities, token public pour partage |
| RGPD | Consentement, suppression, chiffrement local |
| 99% disponibilité | Résilience naturelle via offline, backend simple |

**Scale & Complexity :**

- Domaine primaire : Full-stack mobile-first (React Native + React front, Laravel back)
- Niveau de complexité : Moyen
- Composants architecturaux estimés : 10-12 (auth, API REST, DB serveur, sync engine mobile, sync engine web, DVF proxy, scraping service, photo storage, offline DB mobile, offline DB web, business logic, shared packages)

### Technical Constraints & Dependencies

- **React Native + Expo** côté mobile : iOS/Android natif via Expo managed workflow
- **React + Vite** côté web : SPA, même logique métier, UI adaptée
- **Laravel (PHP)** côté serveur : API REST, auth, business logic serveur, proxy DVF, **scraping annonces**
- **Stack hétérogène** : React/React Native ↔ Laravel via API REST JSON
- **OVH serveur privé** : hébergement imposé, Laravel natif sur serveur dédié
- **DVF data.gouv.fr** : API externe, données avec ~6 mois de retard, proxy Laravel
- **Scraping annonces** : Backend proxy pour LeBonCoin, SeLoger, PAP, Logic-Immo
- **Material 3** : via MUI (web) + React Native Paper (mobile), palette Violet/Magenta (light) + Indigo/Orchidée (dark), Inter font, Material Symbols, WCAG 2.1 AA
- **Développement assisté par agents IA** : architecture claire, conventions strictes, séparation nette des responsabilités

### Cross-Cutting Concerns

| Concern | Composants impactés |
|---------|--------------------|
| **Offline sync** | Toutes les fiches, checklists, guide visite, photos, DVF cache |
| **Auth & permissions** | Laravel API, middleware, partage public, accès invité |
| **Photo management** | Guide visite, fiches annonces, partage artisan |
| **Business logic** | Score d'opportunité (client+serveur), simulateur TVA (client), synthèse post-visite (client) |
| **Contenu statique** | Fiches mémo, guide fiscalité, checklist templates |
| **API contract** | Interface React ↔ Laravel, validation |
| **Code sharing** | Logique métier partagée entre mobile et web via packages communs |
| **Scraping** | Import annonces via backend proxy (LeBonCoin, SeLoger, PAP, Logic-Immo) |

## Starter Template Evaluation

### Domaine technologique principal

**Full-stack hétérogène** : React Native + Expo (mobile multi-platform) + React + Vite (web SPA) + Laravel 12.x (API backend), trois codebases dans un monorepo communicant via API REST JSON.

### Options évaluées — Mobile React Native

| Starter | Expo | Navigation | Offline | Maintenance | Verdict |
|---------|------|------------|---------|-------------|---------|
| **Expo (managed)** | ✅ Natif | React Navigation | Via libs | ✅ Actif (Expo team) | **Retenu** |
| Ignite (Infinite Red) | ✅ | React Navigation | MobX-State-Tree | ⚠️ Opinionated | Non retenu |
| Create React Native App | ❌ Deprecated | — | — | ❌ | Non retenu |

### Options évaluées — Web React

| Starter | Build | Router | Maintenance | Verdict |
|---------|-------|--------|-------------|---------|
| **Vite + React** | ✅ Rapide | React Router | ✅ Actif | **Retenu** |
| Create React App | ⚠️ Lent | React Router | ❌ Deprecated | Non retenu |
| Next.js | SSR/SSG | App Router | ✅ Actif | Overkill (pas de SEO requis) |

### Options évaluées — State Management

| Lib | Type | Bundle size | DX | Verdict |
|-----|------|-------------|-----|---------|
| **Zustand** | Minimal, hooks | ~1KB | ✅ Simple | **Retenu** |
| Redux Toolkit | Full-featured | ~10KB | ⚠️ Boilerplate | Non retenu |
| Jotai | Atomic | ~2KB | ✅ Simple | Alternative viable |
| MobX | Observable | ~15KB | ⚠️ Complexe | Non retenu |

**Rationale Zustand** : Minimaliste, API hooks intuitive, pas de boilerplate, fonctionne identiquement React et React Native, persist middleware pour offline.

### Options évaluées — Base de données locale mobile

| DB | Type | Offline-first | Sync | Maintenance | Verdict |
|----|------|--------------|------|-------------|---------|
| **WatermelonDB** | SQLite, lazy | ✅ Excellent | ✅ Sync primitives | ✅ Actif | **Retenu** |
| expo-sqlite | SQLite brut | ✅ Bon | ❌ Manuel | ✅ Expo team | Alternative |
| MMKV | Key-value | ⚠️ Simple data | ❌ | ✅ Actif | Non retenu (pas relationnel) |
| Realm | NoSQL | ✅ Bon | ⚠️ Device Sync payant | ⚠️ | Non retenu |

**Rationale WatermelonDB** : Conçu pour offline-first, lazy loading, sync primitives intégrées, modèle relationnel, performance sur grandes collections.

### Options évaluées — Base de données locale web

| DB | Type | API | Maintenance | Verdict |
|----|------|-----|-------------|---------|
| **Dexie.js** | IndexedDB wrapper | Promise + hooks | ✅ Actif | **Retenu** |
| idb | IndexedDB wrapper | Promise | ✅ Actif | Plus bas niveau |
| localForage | Multi-backend | Callback/Promise | ⚠️ Maintenance réduite | Non retenu |
| PouchDB | CouchDB-like | Sync intégré | ⚠️ | Overkill |

**Rationale Dexie.js** : API intuitive, `useLiveQuery` hook pour React, performant, bien documenté.

### Options évaluées — UI Kit

| Mobile | Web | M3 Support | Verdict |
|--------|-----|------------|---------|
| **React Native Paper** | **MUI v5+** | ✅ Natif | **Retenu** |
| NativeBase | Chakra UI | ⚠️ Partiel | Non retenu |
| Tamagui | Tamagui | ⚠️ Custom | Non retenu |

### Options évaluées — Authentification backend (inchangé)

| Approche | Type | Maintenu par | Verdict |
|----------|------|-------------|---------|
| **Laravel Sanctum** | Token API, abilities | Laravel (officiel) | **Retenu** |
| php-open-source-saver/jwt-auth | JWT stateless | Communauté | Non retenu |
| Laravel Passport | OAuth2 complet | Laravel | Overkill |

**Rationale Sanctum** : officiel Laravel, révocation simple (delete en DB), token abilities natif pour RBAC (owner/guest/guest-extended), multi-device natif, zéro dépendance tierce.

### Sélection retenue

#### Mobile — React Native + Expo

```bash
npx create-expo-app@latest mobile-app --template blank-typescript
cd mobile-app
npx expo install @react-navigation/native @react-navigation/bottom-tabs react-native-paper
npx expo install @nozbe/watermelondb
```

**Décisions architecturales fournies :**

- **Langage** : TypeScript strict
- **State management** : Zustand avec persist middleware
- **Navigation** : React Navigation (bottom tabs + stack)
- **UI** : React Native Paper (Material 3)
- **Offline DB** : WatermelonDB
- **Build** : Expo EAS (managed workflow)

#### Web — React + Vite

```bash
npm create vite@latest web-app -- --template react-ts
cd web-app
npm install @mui/material @emotion/react @emotion/styled react-router-dom zustand dexie dexie-react-hooks
```

**Décisions architecturales fournies :**

- **Langage** : TypeScript strict
- **State management** : Zustand (même que mobile)
- **Navigation** : React Router v6
- **UI** : MUI v5+ (Material 3)
- **Offline DB** : Dexie.js (IndexedDB)
- **Build** : Vite

#### Backend — Laravel 12 (inchangé)

```bash
# Déjà en place, pas de changement
cd backend-api
php artisan install:api  # Sanctum inclus
```

**Ajout pour scraping :**

```bash
composer require symfony/dom-crawler symfony/css-selector guzzlehttp/guzzle
```

**Décisions architecturales fournies :**

- **Langage** : PHP 8.2+
- **Auth** : Sanctum (token API, abilities pour RBAC)
- **API** : routes `api.php`, middleware `auth:sanctum`
- **Structure** : MVC standard Laravel + Actions/Services
- **DB serveur** : MySQL 8.x
- **Scraping** : Symfony DomCrawler + Guzzle

#### Environnement de développement — Laravel Sail (inchangé)

Convention multi-projet : préfixe port **4** pour éviter les conflits Docker.

| Service | Port interne | Port externe |
|---------|-------------|-------------|
| App (HTTP) | 80 | **4080** |
| MySQL | 3306 | **43306** |
| Vite | 5173 | **45173** |
| Mailpit SMTP | 1025 | **41025** |
| Mailpit Dashboard | 8025 | **48025** |

#### Production

**Backend (inchangé) :**

- **Dockerfile** : FrankenPHP + Octane, image Alpine optimisée
- **docker-compose.prod.yml** : app + MySQL + queue worker + scheduler
- **deploy.sh** : build multi-tag → push vers registry privé
- **Watchtower** : auto-deploy sur le serveur de production

**Web :**

- Build Vite statique (`npm run build`)
- Hébergement : même serveur OVH (nginx static) ou CDN
- Deploy : rsync ou Docker nginx

**Mobile :**

- Expo EAS Build pour iOS et Android
- Publication App Store / Play Store via EAS Submit

**Note :** L'initialisation des projets (React Native + React + Laravel + Docker) fera l'objet d'un **epic DevOps dédié** incluant : setup Expo, setup Vite, Sail, Dockerfile prod, scripts de build/deploy.

## Core Architectural Decisions

### Decision Priority Analysis

**Décisions critiques (bloquent l'implémentation) :**
- Data sync strategy (last-write-wins, delta incrémental) — **mobile ET web**
- Auth Sanctum + RBAC + partage public
- WatermelonDB (mobile) + Dexie.js (web) pour offline-first
- API REST avec endpoint sync batch
- **Scraping service backend** (import annonces)

**Décisions importantes (structurent l'architecture) :**
- Zustand stores partagés (logique commune mobile/web)
- Package shared pour types et utilitaires (`@mdb/shared`)
- OpenAPI auto-doc via Scramble
- Qualité code locale (ESLint, Prettier, TypeScript strict)

**Décisions différées (post-MVP) :**
- Monitoring avancé (Sentry, metrics)
- Scaling horizontal
- WebSocket / real-time (si collaboration live nécessaire)

### Data Architecture

| Décision | Choix | Rationale |
|----------|-------|-----------|
| DB serveur | MySQL 8.x | Standard Laravel, OVH compatible |
| DB locale mobile | **WatermelonDB** (SQLite) | Lazy loading, sync primitives, performant |
| DB locale web | **Dexie.js** (IndexedDB) | API hooks, performant, bien documenté |
| Chiffrement mobile | SQLCipher via WatermelonDB | RGPD |
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
| Chiffrement mobile | SQLCipher + SecureStore (Expo) | Keychain/Keystore natif |
| Chiffrement web | — (IndexedDB non chiffré, données moins sensibles) | Acceptable pour web |
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
| **Scraping** | `POST /api/scrape` | Backend proxy, évite CORS, gère changements structure |

### Frontend Architecture

| Décision | Choix | Rationale |
|----------|-------|-----------|
| State management | **Zustand** | Minimaliste, même API mobile/web, persist middleware |
| Data layer mobile | WatermelonDB models + sync | Offline-first natif |
| Data layer web | Dexie.js tables + useLiveQuery | Réactif, offline |
| Routing mobile | React Navigation | Standard React Native |
| Routing web | React Router v6 | Standard React |
| Design system | Material 3 via Paper (mobile) + MUI (web) | M3 natif, même palette |
| Photos mobile | expo-image-picker + compression + upload queue | UX fluide offline |
| Photos web | File input + compression + upload | Simplifié |
| Code sharing | Package `@mdb/shared` (types, utils, API client) | DRY, cohérence |

### Infrastructure & Deployment

| Décision | Choix | Rationale |
|----------|-------|-----------|
| Dev local backend | Laravel Sail, préfixe port 4 | Convention multi-projet Docker |
| Dev local mobile | Expo Go | Hot reload, pas de build natif |
| Dev local web | Vite dev server | HMR rapide |
| Prod backend | Octane + FrankenPHP, image Docker Alpine | Performance, OVH dédié |
| Prod web | Vite build statique → nginx ou CDN | Simple, performant |
| Prod mobile | Expo EAS Build → App Store / Play Store | Managed workflow |
| Qualité code | ESLint + Prettier + TypeScript strict | Standards JS/TS |
| Environnements | dev / staging / prod | Staging sur même OVH |
| Monitoring V1 | Logs Laravel (fichier + stderr) | Suffisant pour démarrer |

### Decision Impact Analysis

**Séquence d'implémentation :**
1. Epic DevOps : Monorepo setup, Expo, Vite, Sail, Docker, deploy
2. Auth Sanctum + modèle User + RBAC (backend existant)
3. Modèle de données + migrations MySQL
4. Package shared (types, API client)
5. WatermelonDB schema mobile + Dexie schema web
6. Sync engine (mobile + web)
7. API REST endpoints + Scraping service
8. Features métier (fiches, pipeline, checklists...)
9. Design system (theme MUI + Paper)

**Dépendances cross-composants :**
- Sync engine dépend de : schemas DB locales + API endpoints + Auth
- Package shared dépend de : types API définis
- Scraping dépend de : API endpoints + modèle Property
- Design system : parallélisable (pas de dépendance)

## Implementation Patterns & Consistency Rules

### Architecture modulaire React

| Couche | Responsabilité | Équivalent autres frameworks |
|--------|----------------|------------------------------|
| **Components** | UI pure, rendu, pas de logique | Views / Templates |
| **Hooks** | Logique réutilisable avec état | Services (stateful) |
| **Services** | Logique métier pure, sans état | Services (stateless) |
| **API** | Communication HTTP | Gateway |
| **Repositories** | Abstraction accès DB locale | Repository |
| **Stores (Zustand)** | État global partagé | State Container |
| **Types** | Définition des entités | Models / DTOs |
| **Utils** | Fonctions pures utilitaires | Helpers |

### Naming Patterns

**Base de données (Laravel/MySQL) — inchangé :**
- Tables : `snake_case`, pluriel → `properties`, `checklist_items`, `visit_guide_responses`
- Colonnes : `snake_case` → `created_at`, `property_id`, `sale_urgency`
- Foreign keys : `{table_singulier}_id` → `property_id`, `user_id`
- Pivot tables : alphabétique singulier → `property_user`

**API (JSON entre React ↔ Laravel) :**
- Endpoints : pluriel, kebab-case → `/api/properties`, `/api/checklist-items`
- Paramètres route : `{property}` (convention Laravel resource)
- Query params : `snake_case` → `?page=1&per_page=20&sort_by=created_at`
- JSON fields : `snake_case` (convention Laravel API Resource)

**Code TypeScript (React / React Native) :**
- Fichiers composants : `PascalCase.tsx` → `PropertyCard.tsx`, `ScoreCard.tsx`
- Fichiers utilitaires : `camelCase.ts` → `apiClient.ts`, `syncEngine.ts`
- Composants : `PascalCase` → `PropertyCard`, `VisitGuideCategory`
- Hooks : `useCamelCase` → `useProperties`, `useSyncStatus`
- Variables/fonctions : `camelCase` → `propertyId`, `getVisitGuide()`
- Constantes : `SCREAMING_SNAKE_CASE` → `DEFAULT_PAGE_SIZE`, `API_BASE_URL`
- Types/Interfaces : `PascalCase` → `Property`, `VisitGuideResponse`
- Enums : `PascalCase` → `PropertyStatus.UnderAnalysis`
- Zustand stores : `use{Feature}Store` → `usePropertyStore`, `useAuthStore`
- Services : `{feature}Service` → `propertyService`, `scoringService`
- API : `{feature}Api` → `propertyApi`, `scrapingApi`
- Repositories : `{Feature}Repository` → `PropertyRepository`

**Code PHP (Laravel) — inchangé :**
- Classes : `PascalCase` → `PropertyController`, `ScrapingService`
- Fichiers : `PascalCase` → `PropertyController.php` (PSR-4)
- Variables/fonctions : `camelCase` → `$propertyId`, `getVisitGuide()`
- Config keys : `snake_case` → `config('mdb.dvf_cache_ttl')`

### Structure Patterns

**Feature structure (mobile et web) :**

```
features/
└── properties/
    ├── screens/              # Pages/écrans (routing entry points)
    │   └── PropertyListScreen.tsx
    ├── components/           # UI pure, sans logique métier
    │   ├── PropertyCard.tsx
    │   └── PropertyForm.tsx
    ├── hooks/                # Orchestration, logique avec état React
    │   ├── useProperties.ts
    │   └── usePropertyForm.ts
    ├── services/             # Logique métier pure (testable sans mock)
    │   ├── propertyService.ts
    │   └── scoringService.ts
    ├── api/                  # Appels HTTP spécifiques à la feature
    │   └── propertyApi.ts
    ├── types/                # Types locaux à la feature
    │   └── index.ts
    └── index.ts              # Export public de la feature
```

**Core structure :**

```
core/
├── api/                      # Client HTTP générique
│   ├── client.ts             # Axios/fetch configuré
│   ├── interceptors.ts       # Auth, error handling
│   └── types.ts
├── db/                       # Base de données locale
│   ├── schema.ts
│   ├── models/               # WatermelonDB models (mobile) / Dexie tables (web)
│   └── repositories/         # Abstraction accès data
│       ├── PropertyRepository.ts
│       └── BaseRepository.ts
├── sync/                     # Sync engine
│   ├── syncEngine.ts
│   ├── syncService.ts
│   └── conflictResolver.ts
├── stores/                   # État global Zustand
│   ├── authStore.ts
│   └── syncStore.ts
├── services/                 # Services globaux
│   └── storageService.ts
└── theme/                    # Design system
    ├── theme.ts
    └── colors.ts
```

**Laravel (ajout scraping) :**

```
app/
├── Http/
│   ├── Controllers/Api/
│   │   ├── PropertyController.php
│   │   ├── ScrapingController.php      # Nouveau
│   │   └── ...
│   ├── Requests/
│   └── Resources/
├── Models/
├── Actions/                            # Logique métier unitaire
│   ├── CreatePropertyAction.php
│   └── ...
├── Services/
│   ├── DvfService.php
│   ├── ScoringService.php
│   ├── SyncService.php
│   └── Scraping/                       # Nouveau
│       ├── ScrapingService.php
│       ├── Scrapers/
│       │   ├── ScraperInterface.php
│       │   ├── LeBonCoinScraper.php
│       │   ├── SeLogerScraper.php
│       │   ├── PapScraper.php
│       │   └── LogicImmoScraper.php
│       └── ScrapingResult.php
└── Events/
```

### Dependency Rules (imports autorisés)

| Couche | Peut importer | Ne peut PAS importer |
|--------|---------------|----------------------|
| **Types** | Rien | — |
| **Utils** | Types | Tout le reste |
| **Services** | Types, Utils | API, Hooks, Components, Stores |
| **API** | Types | Services, Hooks, Components |
| **Repositories** | Types, DB Models | API, Hooks, Components |
| **Stores** | Types, API, Services | Hooks, Components |
| **Hooks** | Types, API, Services, Stores, Repos | Components |
| **Components** | Types uniquement | API, Services, Hooks, Stores |
| **Screens** | Tout | — |

### Format Patterns (inchangé)

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

**Zustand stores :**

```typescript
interface PropertyState {
  properties: Property[];
  isLoading: boolean;
  error: string | null;
  fetchProperties: () => Promise<void>;
  createProperty: (data: CreatePropertyInput) => Promise<Property>;
}

export const usePropertyStore = create<PropertyState>()(
  persist(
    (set, get) => ({
      properties: [],
      isLoading: false,
      error: null,
      fetchProperties: async () => { /* ... */ },
      createProperty: async (data) => { /* ... */ },
    }),
    { name: 'property-store' }
  )
);
```

**Hooks pattern :**
- Un hook par feature pour encapsuler la logique : `useProperties()`, `useVisitGuide()`
- Hooks retournent : `{ data, isLoading, error, actions }`
- Composition de hooks pour logique complexe

**Laravel Events (inchangé) :**
- Naming : `PascalCase` → `PropertyCreated`, `VisitGuideCompleted`
- Payload : l'entité Eloquent complète
- Listeners dans `EventServiceProvider`

### Process Patterns

**Error handling React/React Native :**
- API client throw des erreurs typées (`ApiError`)
- Stores/hooks catch et set `error` state
- UI affiche via conditional rendering ou toast/snackbar

**Error handling Laravel (inchangé) :**
- Form Request pour validation → 422 auto
- Exceptions custom dans `app/Exceptions/`
- Handler global → JSON formaté

**Loading states :**
- Zustand store : `isLoading` boolean dans le state
- React : skeleton/shimmer pendant chargement
- Pas de spinner plein écran bloquant

**Sync offline :**
- Chaque write local marque l'entité `syncStatus: 'pending'`
- Background sync quand connectivité détectée (NetInfo mobile, navigator.onLine web)
- En cas d'échec réseau : retry avec backoff exponentiel
- UI affiche indicateur sync status discret

### Testability

| Couche | Test type | Mocks nécessaires |
|--------|-----------|-------------------|
| **Services** | Unit | Aucun (fonctions pures) |
| **API** | Unit | HTTP client mocké |
| **Repositories** | Integration | DB in-memory |
| **Stores** | Unit | API + Services mockés |
| **Hooks** | Unit | Stores mockés |
| **Components** | Snapshot + Unit | Props uniquement |
| **Screens** | Integration | Hooks mockés |

### Enforcement Guidelines

**Tous les agents IA DOIVENT :**
1. Suivre les conventions de nommage exactes (snake_case API/DB, camelCase TS, PascalCase composants)
2. Utiliser les UUID v4 pour tous les IDs d'entités
3. Créer les tests correspondants à chaque feature (`__tests__/` miroir)
4. Respecter les règles d'import entre couches (dependency rules)
5. Mettre la logique métier dans les Services (pas dans hooks/components)
6. Utiliser les Repositories pour tout accès DB locale
7. Ne jamais accéder directement à l'API depuis les composants (→ hooks)
8. Formatter les montants en centimes integer
9. Utiliser le package `@mdb/shared` pour types et utils communs
10. Documenter les endpoints via API Resources Laravel

**Anti-patterns à éviter :**
- ❌ Logique métier dans les Controllers Laravel (→ Actions/Services)
- ❌ Logique métier dans les Components React (→ Services)
- ❌ Appels API directs dans les composants (→ hooks)
- ❌ Dates en format custom (→ ISO 8601 uniquement)
- ❌ IDs auto-increment côté client (→ UUID v4)
- ❌ Strings pour les montants (→ int centimes)
- ❌ `any` en TypeScript (→ types explicites)
- ❌ Duplication de types entre mobile et web (→ `@mdb/shared`)
- ❌ Import de Components dans Services/API/Stores

## Project Structure & Boundaries

### Structure racine monorepo

```
mdb-copilot/
├── apps/
│   ├── mobile/                    # React Native + Expo
│   └── web/                       # React + Vite
├── packages/
│   └── shared/                    # Types, utils, API client partagés
├── backend-api/                   # Laravel 12 API
├── _bmad/
├── _bmad-output/
├── package.json                   # Workspaces config (npm/yarn/pnpm)
├── tsconfig.base.json             # TypeScript config partagée
├── CLAUDE.md
└── README.md
```

### Structure Mobile — `apps/mobile/`

```
apps/mobile/
├── app.json
├── package.json
├── tsconfig.json
├── babel.config.js
├── metro.config.js
├── src/
│   ├── app/
│   │   ├── App.tsx
│   │   ├── navigation/
│   │   │   ├── RootNavigator.tsx
│   │   │   ├── MainTabs.tsx
│   │   │   ├── AuthStack.tsx
│   │   │   └── types.ts
│   │   └── providers/
│   │       └── AppProviders.tsx
│   ├── features/
│   │   ├── auth/
│   │   │   ├── screens/
│   │   │   │   ├── LoginScreen.tsx
│   │   │   │   ├── RegisterScreen.tsx
│   │   │   │   └── ForgotPasswordScreen.tsx
│   │   │   ├── components/
│   │   │   ├── hooks/
│   │   │   ├── services/
│   │   │   ├── api/
│   │   │   └── types/
│   │   ├── properties/
│   │   │   ├── screens/
│   │   │   │   ├── PropertyListScreen.tsx
│   │   │   │   ├── PropertyDetailScreen.tsx
│   │   │   │   └── CreatePropertyScreen.tsx
│   │   │   ├── components/
│   │   │   │   ├── PropertyCard.tsx
│   │   │   │   ├── PropertyForm.tsx
│   │   │   │   └── LinkImportInput.tsx
│   │   │   ├── hooks/
│   │   │   ├── services/
│   │   │   ├── api/
│   │   │   └── types/
│   │   ├── pipeline/
│   │   ├── contacts/
│   │   ├── checklist/
│   │   ├── visit-guide/
│   │   ├── post-visit-summary/
│   │   ├── memo-cards/
│   │   ├── scoring/
│   │   ├── vat-simulator/
│   │   ├── tax-guide/
│   │   ├── sharing/
│   │   └── onboarding/
│   ├── core/
│   │   ├── api/
│   │   │   ├── client.ts
│   │   │   ├── interceptors.ts
│   │   │   └── types.ts
│   │   ├── db/
│   │   │   ├── schema.ts
│   │   │   ├── models/
│   │   │   │   ├── PropertyModel.ts
│   │   │   │   ├── ContactModel.ts
│   │   │   │   ├── ChecklistModel.ts
│   │   │   │   ├── VisitGuideModel.ts
│   │   │   │   ├── PhotoModel.ts
│   │   │   │   └── MemoCardModel.ts
│   │   │   └── repositories/
│   │   │       ├── BaseRepository.ts
│   │   │       ├── PropertyRepository.ts
│   │   │       └── ...
│   │   ├── sync/
│   │   │   ├── syncEngine.ts
│   │   │   ├── syncService.ts
│   │   │   ├── conflictResolver.ts
│   │   │   └── useSyncStatus.ts
│   │   ├── stores/
│   │   │   ├── authStore.ts
│   │   │   ├── syncStore.ts
│   │   │   └── settingsStore.ts
│   │   ├── theme/
│   │   │   ├── theme.ts
│   │   │   ├── colors.ts
│   │   │   └── spacing.ts
│   │   └── services/
│   │       └── secureStorage.ts
│   └── shared/
│       └── components/
│           ├── ScoreCard.tsx
│           ├── OfflineBanner.tsx
│           ├── LoadingSkeleton.tsx
│           └── StatusBanner.tsx
├── assets/
│   ├── images/
│   └── fonts/
└── __tests__/
    ├── features/
    └── core/
```

### Structure Web — `apps/web/`

```
apps/web/
├── package.json
├── vite.config.ts
├── tsconfig.json
├── index.html
├── src/
│   ├── main.tsx
│   ├── App.tsx
│   ├── routes/
│   │   ├── index.tsx
│   │   ├── ProtectedRoute.tsx
│   │   └── routes.ts
│   ├── features/
│   │   ├── auth/
│   │   │   ├── pages/
│   │   │   │   ├── LoginPage.tsx
│   │   │   │   ├── RegisterPage.tsx
│   │   │   │   └── ForgotPasswordPage.tsx
│   │   │   ├── components/
│   │   │   ├── hooks/
│   │   │   ├── services/
│   │   │   ├── api/
│   │   │   └── types/
│   │   ├── properties/
│   │   ├── pipeline/
│   │   ├── contacts/
│   │   ├── checklist/
│   │   ├── visit-guide/
│   │   ├── memo-cards/
│   │   ├── scoring/
│   │   ├── vat-simulator/
│   │   ├── sharing/
│   │   └── onboarding/
│   ├── core/
│   │   ├── api/
│   │   ├── db/
│   │   │   ├── schema.ts           # Dexie schema
│   │   │   ├── tables/
│   │   │   └── repositories/
│   │   ├── sync/
│   │   ├── stores/
│   │   ├── theme/
│   │   │   ├── theme.ts            # MUI theme
│   │   │   └── colors.ts
│   │   └── services/
│   └── shared/
│       └── components/
├── public/
└── __tests__/
```

### Structure Package Shared — `packages/shared/`

```
packages/shared/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts
│   ├── types/
│   │   ├── index.ts
│   │   ├── user.ts
│   │   ├── property.ts
│   │   ├── contact.ts
│   │   ├── checklist.ts
│   │   ├── visitGuide.ts
│   │   ├── pipeline.ts
│   │   ├── memoCard.ts
│   │   ├── photo.ts
│   │   ├── sharing.ts
│   │   └── api.ts
│   ├── constants/
│   │   ├── index.ts
│   │   ├── pipelineStages.ts
│   │   └── propertyTypes.ts
│   ├── utils/
│   │   ├── index.ts
│   │   ├── formatters.ts
│   │   ├── validators.ts
│   │   ├── dateUtils.ts
│   │   └── moneyUtils.ts
│   └── api/
│       ├── index.ts
│       ├── endpoints.ts
│       └── types.ts
└── __tests__/
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
│   │   ├── Controllers/Api/
│   │   │   ├── AuthController.php
│   │   │   ├── PropertyController.php
│   │   │   ├── ContactController.php
│   │   │   ├── ChecklistController.php
│   │   │   ├── VisitGuideController.php
│   │   │   ├── PipelineController.php
│   │   │   ├── DvfController.php
│   │   │   ├── MemoCardController.php
│   │   │   ├── PhotoController.php
│   │   │   ├── ScoringController.php
│   │   │   ├── ShareController.php
│   │   │   ├── SyncController.php
│   │   │   ├── ScrapingController.php
│   │   │   └── InvitationController.php
│   │   ├── Requests/
│   │   ├── Resources/
│   │   └── Middleware/
│   │       └── EnsureTokenAbility.php
│   ├── Models/
│   │   ├── User.php
│   │   ├── Property.php
│   │   ├── Contact.php
│   │   ├── Checklist.php
│   │   ├── ChecklistItem.php
│   │   ├── VisitGuide.php
│   │   ├── VisitGuideResponse.php
│   │   ├── Photo.php
│   │   ├── MemoCard.php
│   │   ├── ShareToken.php
│   │   └── Invitation.php
│   ├── Actions/
│   │   ├── CreatePropertyAction.php
│   │   ├── UpdatePropertyAction.php
│   │   └── ...
│   ├── Services/
│   │   ├── DvfService.php
│   │   ├── ScoringService.php
│   │   ├── SyncService.php
│   │   ├── ShareService.php
│   │   ├── PhotoService.php
│   │   └── Scraping/
│   │       ├── ScrapingService.php
│   │       ├── Scrapers/
│   │       │   ├── ScraperInterface.php
│   │       │   ├── LeBonCoinScraper.php
│   │       │   ├── SeLogerScraper.php
│   │       │   ├── PapScraper.php
│   │       │   └── LogicImmoScraper.php
│   │       └── ScrapingResult.php
│   ├── Events/
│   └── Exceptions/
├── database/
│   ├── migrations/
│   ├── seeders/
│   │   └── MemoCardSeeder.php
│   └── factories/
├── routes/
│   ├── api.php
│   └── console.php
├── storage/
│   └── app/photos/
└── tests/
    ├── Feature/
    └── Unit/
```

### Architectural Boundaries

**API Boundary** : `routes/api.php` — toute communication React ↔ Laravel passe par `/api/*`. Aucun accès direct DB depuis le client.

**Data Boundary :**
- Mobile : WatermelonDB (local) ↔ Repository ↔ Hook ↔ Component
- Web : Dexie.js (local) ↔ Repository ↔ Hook ↔ Component
- Laravel : Eloquent (MySQL) ↔ Action/Service ↔ Controller ↔ Resource → JSON

**Sync Boundary** : `POST /api/sync` est l'unique point d'échange de données. Les `SyncEngine` mobile et web et le `SyncService` Laravel sont les seuls composants qui gèrent la synchronisation.

**Auth Boundary** : Sanctum middleware sur toutes les routes API sauf :
- `/api/auth/login`, `/api/auth/register`, `/api/auth/forgot-password`
- `/api/share/{token}` (accès public artisan)
- `/api/invitations/accept` (acceptation invitation)

**Photo Boundary** : Upload via `POST /api/photos`, stockage `storage/app/photos/`, accès via signed URL Laravel. Côté client, photos en cache local + upload queue.

**Scraping Boundary** : `POST /api/scrape` côté backend uniquement. Le client envoie l'URL, le backend fait le scraping et retourne les données structurées.

### Requirements → Structure Mapping

| Feature (PRD) | Mobile feature/ | Web feature/ | Laravel Controller |
|---------------|-----------------|--------------|-------------------|
| Auth | `auth/` | `auth/` | `AuthController` |
| Contacts | `contacts/` | `contacts/` | `ContactController` |
| Fiches annonces | `properties/` | `properties/` | `PropertyController` |
| Import lien | `properties/` (LinkImportInput) | `properties/` | `ScrapingController` |
| Pipeline Kanban | `pipeline/` | `pipeline/` | `PipelineController` |
| Checklist pré-visite | `checklist/` | `checklist/` | `ChecklistController` |
| Guide visite | `visit-guide/` | `visit-guide/` | `VisitGuideController` |
| Synthèse post-visite | `post-visit-summary/` | — | — (client-only) |
| Fiches mémo | `memo-cards/` | `memo-cards/` | `MemoCardController` |
| Score d'opportunité | `scoring/` | `scoring/` | `ScoringController` |
| DVF | (via scoring) | (via scoring) | `DvfController` |
| Simulateur TVA | `vat-simulator/` | `vat-simulator/` | — (client-only) |
| Guide fiscalité | `tax-guide/` | `tax-guide/` | — (client-only) |
| Partage | `sharing/` | `sharing/` | `ShareController` |
| Mode offline | `core/sync/` | `core/sync/` | `SyncController` |
| Photos | (dans visit-guide + properties) | (dans visit-guide + properties) | `PhotoController` |
| Onboarding | `onboarding/` | `onboarding/` | — (client-only) |

### External Integrations

| Service | Point d'intégration | Boundary |
|---------|---------------------|----------|
| DVF data.gouv.fr | `DvfService` → API HTTP | Laravel proxy + cache 24h |
| LeBonCoin/SeLoger/PAP | `ScrapingService` → HTTP scraping | Laravel proxy |
| Docker Registry | `deploy.sh` → registry privé | Build & push |
| Watchtower | Prod server | Auto-pull images |
| App Store / Play Store | Expo EAS Submit | Publication mobile |

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
