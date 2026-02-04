---
stepsCompleted: ['step-01-validate-prerequisites', 'step-02-design-epics', 'step-03-create-stories', 'step-04-final-validation']
workflowStatus: completed
completedAt: '2026-02-03'
inputDocuments:
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/architecture.md
  - _bmad-output/planning-artifacts/ux-design-specification.md
pivotNote: 'Pivot technologique Flutter → React Native + React Web (2026-02-03)'
summary:
  totalEpics: 13
  totalStories: 52
  totalFRs: 63
  totalNFRs: 21
  totalARs: 67
---

# MDB Copilot - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for MDB Copilot, decomposing the requirements from the PRD, UX Design, and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

**Gestion de compte & Authentification (FR1-FR6)**
- FR1 : L'utilisateur peut créer un compte avec prénom, nom, email et mot de passe
- FR2 : L'utilisateur peut se connecter et se déconnecter
- FR3 : L'utilisateur peut réinitialiser son mot de passe via email
- FR4 : L'utilisateur peut gérer son profil (prénom, nom, email, mot de passe)
- FR5 : Le propriétaire peut inviter des utilisateurs avec un rôle (guest-read, guest-extended)
- FR6 : L'utilisateur invité accède uniquement aux données autorisées par son rôle

**Onboarding (FR7-FR8)**
- FR7 : Le nouvel utilisateur voit un écran d'accueil avec options de démarrage (import lien, saisie manuelle, explorer)
- FR8 : Le nouvel utilisateur peut suivre un tour guidé présentant les fonctionnalités principales

**Carnet d'Adresses (FR9-FR11)**
- FR9 : L'utilisateur peut créer un contact professionnel (prénom, nom, entreprise, téléphone, email, type, notes)
- FR10 : L'utilisateur peut consulter, modifier et supprimer un contact
- FR11 : L'utilisateur peut filtrer les contacts par type (agent immobilier, artisan, notaire, courtier, autre)

**Fiches Annonces (FR12-FR20)**
- FR12 : L'utilisateur peut créer une fiche annonce par saisie manuelle (adresse, surface, prix, type de bien)
- FR13 : L'utilisateur peut créer une fiche annonce par import de lien (LeBonCoin, SeLoger, PAP, Logic-Immo)
- FR14 : Le système extrait automatiquement les données disponibles depuis le lien importé
- FR15 : Si l'extraction est partielle, le système affiche un formulaire pré-rempli à compléter
- FR16 : L'utilisateur peut associer un agent immobilier depuis le carnet d'adresses ou en créer un nouveau inline
- FR17 : L'utilisateur peut indiquer le niveau d'urgence de vente (faible, moyen, élevé, non renseigné)
- FR18 : L'utilisateur peut ajouter des notes libres à une fiche
- FR19 : L'utilisateur peut consulter, modifier et supprimer une fiche annonce
- FR20 : L'utilisateur peut consulter la liste de toutes ses fiches annonces

**Score d'opportunité (FR21-FR23)**
- FR21 : Le système calcule un score d'opportunité combinant prix vs marché (DVF), urgence de vente et potentiel
- FR22 : L'utilisateur peut consulter le détail du score et ses composantes
- FR23 : Si les données DVF ne sont pas disponibles, le score est calculé sans cette composante avec mention

**Pipeline Kanban (FR24-FR26)**
- FR24 : L'utilisateur peut visualiser toutes ses annonces dans un pipeline Kanban
- FR25 : L'utilisateur peut déplacer une annonce entre les étapes (Prospection → RDV → Visite → Analyse → Offre → Acheté → Travaux → Vente → Vendu → No Go)
- FR26 : L'utilisateur peut filtrer et trier les annonces dans le pipeline

**Checklist Pré-visite (FR27-FR29)**
- FR27 : Le système génère automatiquement une checklist lors du passage au statut "RDV"
- FR28 : L'utilisateur peut consulter la checklist (questions à poser, documents à demander, points à vérifier)
- FR29 : L'utilisateur peut cocher les éléments de la checklist

**Guide de Visite Interactif (FR30-FR34)**
- FR30 : L'utilisateur peut parcourir un guide de visite organisé par catégorie (structure, électricité, plomberie, division, etc.)
- FR31 : L'utilisateur peut répondre aux questions guidées pour chaque catégorie
- FR32 : L'utilisateur peut prendre des photos contextualisées liées à un point du guide
- FR33 : L'utilisateur peut saisir des notes sur les échanges avec l'agent
- FR34 : Le guide de visite fonctionne intégralement en mode offline

**Synthèse Post-visite (FR35-FR39)**
- FR35 : Le système génère automatiquement une synthèse basée sur les réponses du guide
- FR36 : La synthèse affiche des alertes sur les points critiques détectés (red flags)
- FR37 : La synthèse inclut une estimation de marge prévisionnelle
- FR38 : La synthèse propose des liens contextuels vers les fiches mémo pertinentes
- FR39 : L'utilisateur peut marquer sa décision (Go, No Go, À approfondir)

**Fiches Mémo MDB (FR40-FR43)**
- FR40 : L'utilisateur peut consulter des guides complets sur les sujets MDB (fiscalité, juridique, bonnes pratiques)
- FR41 : L'utilisateur peut consulter des fiches mémo synthétiques pour chaque sujet
- FR42 : Les fiches mémo sont consultables en mode offline
- FR43 : Le système suggère des fiches mémo contextuelles selon l'action en cours

**Mode Offline & Sync (FR44-FR47)**
- FR44 : L'utilisateur peut consulter ses fiches annonces sans connexion
- FR45 : L'utilisateur peut créer et modifier des données sans connexion
- FR46 : Le système synchronise automatiquement les données au retour du réseau
- FR47 : L'utilisateur peut consulter les photos stockées localement sans connexion

**Intégration DVF (FR48-FR50)**
- FR48 : Le système récupère les données de transactions récentes DVF pour une localisation donnée
- FR49 : L'utilisateur peut consulter les prix de transactions comparables autour d'une annonce
- FR50 : Les données DVF téléchargées sont consultables en mode offline

**Partage & Collaboration (FR51-FR56)**
- FR51 : L'utilisateur peut générer un lien public de consultation vers une fiche projet
- FR52 : Le lien public masque les données financières sensibles du MDB
- FR53 : L'artisan peut consulter les informations du bien via le lien partagé (photos, travaux, contraintes)
- FR54 : L'artisan peut soumettre une fourchette estimative de devis via le lien partagé
- FR55 : Le propriétaire reçoit une notification quand un artisan soumet une estimation
- FR56 : L'associé invité peut consulter le pipeline et les fiches via son compte

**Simulateur TVA sur Marge (FR57-FR59)**
- FR57 : L'utilisateur peut saisir les paramètres d'une opération (prix achat, travaux, frais)
- FR58 : Le système calcule automatiquement la base TVA et la TVA due à la revente
- FR59 : L'utilisateur peut simuler différents scénarios de prix de revente

**Guide Fiscalité MDB (FR60-FR63)**
- FR60 : L'utilisateur peut consulter les règles TVA sur marge vs TVA sur total
- FR61 : L'utilisateur peut consulter les règles de plus-value professionnelle
- FR62 : L'utilisateur peut consulter les différents régimes d'imposition applicables
- FR63 : Le système affiche des alertes sur les délais de revente fiscaux

### NonFunctional Requirements

**Performance (NFR-P1 à NFR-P5)**
- NFR-P1 : Temps de démarrage app mobile < 2 secondes (cold start device mid-range)
- NFR-P2 : Navigation entre écrans < 300ms (95e percentile)
- NFR-P3 : Temps de réponse API < 500ms (95e percentile sous charge normale)
- NFR-P4 : Sync delta complète < 5 secondes (100 fiches modifiées, réseau 4G)
- NFR-P5 : Chargement liste Kanban < 1 seconde (jusqu'à 200 fiches, données locales)

**Sécurité (NFR-S1 à NFR-S5)**
- NFR-S1 : Données locales chiffrées (SQLCipher)
- NFR-S2 : Tokens Sanctum avec expiration 7 jours
- NFR-S3 : HTTPS obligatoire pour toutes les API
- NFR-S4 : Pas de données sensibles dans les logs
- NFR-S5 : Photos stockées avec accès authentifié (URLs signées ou proxy)

**Scalabilité (NFR-SC1 à NFR-SC3)**
- NFR-SC1 : Support jusqu'à 1000 fiches par utilisateur
- NFR-SC2 : Support jusqu'à 10 utilisateurs actifs simultanés (Phase 2)
- NFR-SC3 : Photos compressées < 500KB avant upload

**Fiabilité (NFR-R1 à NFR-R4)**
- NFR-R1 : Zéro perte de données en mode offline (tests sync après interruption réseau)
- NFR-R2 : Sauvegarde automatique continue (pas de bouton "Save")
- NFR-R3 : Récupération gracieuse si DVF indisponible (fallback fonctionnel)
- NFR-R4 : Récupération gracieuse si scraping échoue (formulaire pré-rempli partiel)

**Intégration (NFR-I1 à NFR-I3)**
- NFR-I1 : DVF API via proxy Laravel avec cache 24h
- NFR-I2 : Scraping annonces via backend (pas de client-side)
- NFR-I3 : Compatibilité navigateurs Safari/Chrome/Firefox/Edge 120+

**Accessibilité (NFR-A1 à NFR-A3)**
- NFR-A1 : Contraste texte minimum 4.5:1 (WCAG AA)
- NFR-A2 : Tailles de touch targets minimum 44x44dp
- NFR-A3 : Support lecteur d'écran (labels accessibles)

### Additional Requirements

**From Architecture — Stack React Native + React Web**
- AR1 : Monorepo structure : apps/mobile, apps/web, packages/shared, backend-api
- AR2 : Mobile : React Native + Expo managed workflow (create-expo-app avec blank-typescript)
- AR3 : Web : React + Vite (npm create vite --template react-ts)
- AR4 : Package shared : @mdb/shared pour types, utils, API client communs
- AR5 : State management : Zustand avec persist middleware (mobile et web)
- AR6 : Offline DB mobile : WatermelonDB (lazy loading, sync primitives)
- AR7 : Offline DB web : Dexie.js (IndexedDB wrapper avec useLiveQuery)
- AR8 : UI Kit : React Native Paper (mobile) + MUI v5+ (web) pour Material 3
- AR9 : Navigation mobile : React Navigation (bottom tabs + stack)
- AR10 : Navigation web : React Router v6
- AR11 : TypeScript strict mode sur tous les projets

**From Architecture — Backend Laravel (inchangé)**
- AR12 : Laravel 12 + Sanctum (existant, inchangé)
- AR13 : Ajout Symfony DomCrawler + Guzzle pour scraping
- AR14 : Dev environment : Laravel Sail avec préfixe port 4 (4080, 43306, etc.)
- AR15 : Prod backend : FrankenPHP + Octane Docker
- AR16 : Prod mobile : Expo EAS Build → App Store / Play Store
- AR17 : Prod web : Vite build statique → nginx ou CDN

**From Architecture — Epic DevOps identifié**
- AR18 : Setup monorepo avec workspaces (pnpm recommandé)
- AR19 : Initialisation Expo projet mobile
- AR20 : Initialisation Vite projet web
- AR21 : Configuration package shared avec TypeScript
- AR22 : Configuration Docker prod
- AR23 : Scripts de build/deploy
- AR24 : CI/CD pipeline

**From Architecture — Scraping Service**
- AR25 : ScrapingController + ScrapingService avec interface ScraperInterface
- AR26 : Scrapers : LeBonCoinScraper, SeLogerScraper, PapScraper, LogicImmoScraper
- AR27 : Endpoint : POST /api/scrape
- AR28 : Backend-only (évite CORS, gère changements structure)

**From Architecture — Sync Engine**
- AR29 : Delta incrémental via `updated_at`
- AR30 : Last-write-wins conflict resolution
- AR31 : Endpoint : POST /api/sync
- AR32 : Sync engine mobile (WatermelonDB sync primitives)
- AR33 : Sync engine web (Dexie.js + custom sync)
- AR34 : NetInfo (mobile) / navigator.onLine (web) pour détection connectivité

**From Architecture — Modular React Architecture**
- AR35 : Components : UI pure, rendu, pas de logique
- AR36 : Hooks : Logique réutilisable avec état React
- AR37 : Services : Logique métier pure, sans état (testable)
- AR38 : API : Communication HTTP
- AR39 : Repositories : Abstraction accès DB locale
- AR40 : Stores (Zustand) : État global partagé
- AR41 : Dependency rules strictes entre couches

**From UX Design — Custom Components**
- AR42 : ScoreCard (score d'opportunité 0-100 avec couleurs sémantiques)
- AR43 : KanbanBoard + KanbanColumn + KanbanCard (pipeline visuel avec drag & drop)
- AR44 : VisitGuideCategory (catégorie navigable avec badge complétion)
- AR45 : GuidedQuestion (question avec réponse rapide par tap)
- AR46 : PostVisitSummary (synthèse automatique avec alertes)
- AR47 : DVFComparator (données DVF contextualisées)
- AR48 : OfflineSyncIndicator (état connexion/sync discret)
- AR49 : LinkImportInput (champ saisie lien avec parsing auto)
- AR50 : PartialImportForm (formulaire pré-rempli extraction partielle)
- AR51 : OnboardingTour (tour guidé 5 écrans)
- AR52 : OnboardingWelcome (écran accueil première utilisation)
- AR53 : MemoSuggestionChip (chip contextuel fiche mémo)
- AR54 : StatusBanner (feedback gradient success/error/warning/info)

**From UX Design — Navigation Responsive**
- AR55 : Navigation Bar M3 (mobile < 600dp) avec pill indicator
- AR56 : Navigation Rail M3 (desktop ≥ 600dp) avec FAB intégré
- AR57 : Layout responsive via useMediaQuery + Context provider

**From UX Design — Design Tokens**
- AR58 : Light Mode : Violet #7c4dff (Primary), Magenta #f3419f (Accent)
- AR59 : Dark Mode : Indigo #5750d8 (Primary), Orchidée #d063de (Accent), Background rgb(30,35,52)
- AR60 : Police Inter (@fontsource/inter web, expo-google-fonts mobile)
- AR61 : Border radius : pills 24px, cards 16px, inputs 12px, bottom sheets 24px
- AR62 : Spacing : base 8px, multiples 4-8-16-24-32-48

**From UX Design — Accessibility WCAG 2.1 AA**
- AR63 : Contraste 4.5:1 texte, 3:1 interactifs
- AR64 : Touch targets 48x48dp minimum
- AR65 : Aria-* attributes (web), accessibilityLabel/Role/Hint (mobile)
- AR66 : Navigation clavier (Tab, focus visible, raccourcis N, /)
- AR67 : Animations réduites si prefers-reduced-motion

### FR Coverage Map

| FR | Epic | Description |
|----|------|-------------|
| FR1 | Epic 1 | Création compte (prénom, nom, email, mot de passe) |
| FR2 | Epic 1 | Connexion et déconnexion |
| FR3 | Epic 1 | Réinitialisation mot de passe via email |
| FR4 | Epic 1 | Gestion profil utilisateur |
| FR5 | Epic 1 | Invitation utilisateurs avec rôle |
| FR6 | Epic 1 | Accès restreint par rôle |
| FR7 | Epic 7 | Écran d'accueil avec options de démarrage |
| FR8 | Epic 7 | Tour guidé des fonctionnalités |
| FR9 | Epic 2 | Création contact professionnel |
| FR10 | Epic 2 | Consultation, modification, suppression contact |
| FR11 | Epic 2 | Filtrage contacts par type |
| FR12 | Epic 2 | Création fiche annonce (saisie manuelle) |
| FR13 | Epic 2 | Création fiche annonce (import lien) |
| FR14 | Epic 2 | Extraction automatique données depuis lien |
| FR15 | Epic 2 | Formulaire pré-rempli si extraction partielle |
| FR16 | Epic 2 | Association agent immobilier |
| FR17 | Epic 2 | Indication urgence de vente |
| FR18 | Epic 2 | Notes libres sur fiche |
| FR19 | Epic 2 | Consultation, modification, suppression fiche |
| FR20 | Epic 2 | Liste de toutes les fiches |
| FR21 | Epic 9 | Calcul score d'opportunité |
| FR22 | Epic 9 | Détail du score et composantes |
| FR23 | Epic 9 | Score sans DVF si indisponible |
| FR24 | Epic 3 | Visualisation pipeline Kanban |
| FR25 | Epic 3 | Déplacement entre étapes Kanban |
| FR26 | Epic 3 | Filtres et tri pipeline |
| FR27 | Epic 4 | Génération auto checklist au statut RDV |
| FR28 | Epic 4 | Consultation checklist pré-visite |
| FR29 | Epic 4 | Cochage éléments checklist |
| FR30 | Epic 5 | Guide visite par catégorie |
| FR31 | Epic 5 | Questions guidées par catégorie |
| FR32 | Epic 5 | Photos contextualisées |
| FR33 | Epic 5 | Notes échanges agent |
| FR34 | Epic 5 | Guide visite offline |
| FR35 | Epic 6 | Génération auto synthèse post-visite |
| FR36 | Epic 6 | Alertes points critiques (red flags) |
| FR37 | Epic 6 | Estimation marge prévisionnelle |
| FR38 | Epic 6 | Liens contextuels vers fiches mémo |
| FR39 | Epic 6 | Marquage décision Go/No Go/À approfondir |
| FR40 | Epic 8 | Guides complets sujets MDB |
| FR41 | Epic 8 | Fiches mémo synthétiques |
| FR42 | Epic 8 | Mémos consultables offline |
| FR43 | Epic 8 | Suggestions mémo contextuelles |
| FR44 | Epic 11 | Consultation fiches offline |
| FR45 | Epic 11 | Création/modification données offline |
| FR46 | Epic 11 | Sync auto au retour réseau |
| FR47 | Epic 11 | Photos stockées localement offline |
| FR48 | Epic 9 | Récupération données DVF |
| FR49 | Epic 9 | Consultation transactions comparables |
| FR50 | Epic 9 | DVF cache offline |
| FR51 | Epic 12 | Génération lien public |
| FR52 | Epic 12 | Masquage données financières sensibles |
| FR53 | Epic 12 | Consultation artisan via lien |
| FR54 | Epic 12 | Soumission devis artisan |
| FR55 | Epic 12 | Notification devis artisan |
| FR56 | Epic 12 | Consultation associé via compte invité |
| FR57 | Epic 10 | Saisie paramètres opération TVA |
| FR58 | Epic 10 | Calcul auto TVA sur marge |
| FR59 | Epic 10 | Simulation scénarios prix de revente |
| FR60 | Epic 10 | Règles TVA marge vs total |
| FR61 | Epic 10 | Règles plus-value professionnelle |
| FR62 | Epic 10 | Régimes d'imposition applicables |
| FR63 | Epic 10 | Alertes délais de revente fiscaux |

## Epic List

### Epic 0 : Infrastructure & DevOps
L'environnement de développement et production est opérationnel : monorepo React Native + React + Laravel, starters initialisés, Docker prod.
**FRs couverts :** Aucun FR direct
**ARs couverts :** AR1-AR11, AR14-AR24

### Epic 1 : Authentification & Gestion de compte
L'utilisateur peut créer un compte, se connecter, gérer son profil et inviter des collaborateurs avec des rôles différenciés.
**FRs couverts :** FR1, FR2, FR3, FR4, FR5, FR6

### Epic 2 : Carnet d'adresses & Fiches annonces
L'utilisateur peut gérer ses contacts professionnels et créer des fiches annonces par saisie manuelle ou import de lien (LeBonCoin, SeLoger, PAP, Logic-Immo).
**FRs couverts :** FR9, FR10, FR11, FR12, FR13, FR14, FR15, FR16, FR17, FR18, FR19, FR20
**ARs couverts :** AR25-AR28, AR49, AR50

### Epic 3 : Pipeline Kanban
L'utilisateur peut visualiser toutes ses annonces dans un pipeline visuel et suivre la progression de chaque projet.
**FRs couverts :** FR24, FR25, FR26
**ARs couverts :** AR43

### Epic 4 : Checklist Pré-visite
L'utilisateur peut préparer ses visites avec une checklist structurée qui se génère automatiquement au passage en statut "RDV".
**FRs couverts :** FR27, FR28, FR29

### Epic 5 : Guide de Visite Interactif
L'utilisateur peut parcourir un guide terrain complet, répondre aux questions guidées, prendre des photos et notes — en mode offline.
**FRs couverts :** FR30, FR31, FR32, FR33, FR34
**ARs couverts :** AR44, AR45

### Epic 6 : Synthèse Post-visite
Le système génère automatiquement une synthèse avec alertes, estimation de marge et verdict Go/No Go.
**FRs couverts :** FR35, FR36, FR37, FR38, FR39
**ARs couverts :** AR46, AR53

### Epic 7 : Onboarding
Le nouvel utilisateur est guidé par un écran d'accueil personnalisé et un tour guidé des fonctionnalités principales.
**FRs couverts :** FR7, FR8
**ARs couverts :** AR51, AR52

### Epic 8 : Fiches Mémo MDB
L'utilisateur peut consulter des guides éducatifs et fiches mémo synthétiques sur la fiscalité, le juridique et les bonnes pratiques MDB.
**FRs couverts :** FR40, FR41, FR42, FR43

### Epic 9 : Score d'Opportunité & Intégration DVF
Le système calcule un score d'opportunité combinant prix vs marché (DVF), urgence de vente et potentiel.
**FRs couverts :** FR21, FR22, FR23, FR48, FR49, FR50
**ARs couverts :** AR42, AR47

### Epic 10 : Simulateur TVA & Guide Fiscalité
L'utilisateur peut simuler la TVA sur marge et consulter les règles fiscales MDB pour maîtriser l'aspect fiscal.
**FRs couverts :** FR57, FR58, FR59, FR60, FR61, FR62, FR63

### Epic 11 : Mode Offline & Sync
L'utilisateur peut consulter, saisir et modifier toutes ses données sans connexion avec synchronisation automatique.
**FRs couverts :** FR44, FR45, FR46, FR47
**ARs couverts :** AR29-AR34, AR48

### Epic 12 : Partage & Collaboration
L'utilisateur peut partager des fiches avec artisans (lien public) et associés (compte invité), avec masquage des données sensibles.
**FRs couverts :** FR51, FR52, FR53, FR54, FR55, FR56

---

## Epic 0 : Infrastructure & DevOps

L'environnement de développement et production est opérationnel : monorepo React Native + React + Laravel, starters initialisés, Docker prod.

### Story 0.1 : Initialisation du monorepo et des projets starter

As a développeur,
I want initialiser le monorepo avec le projet React Native (Expo), le projet React Web (Vite), le package shared et le backend Laravel existant,
So that l'environnement de développement est prêt pour l'implémentation des features.

**Acceptance Criteria:**

**Given** un répertoire existant `mdb-tools/` avec `backend-api/` Laravel
**When** le développeur exécute les commandes d'initialisation
**Then** le monorepo contient `apps/mobile/` (Expo TypeScript), `apps/web/` (Vite React TypeScript), `packages/shared/` et `backend-api/`
**And** `apps/mobile/` compile sans erreur avec Expo Go
**And** `apps/web/` démarre sans erreur sur `localhost:5173`
**And** `packages/shared/` exporte des types TypeScript importables par mobile et web
**And** le fichier `CLAUDE.md` à la racine est mis à jour avec les conventions React
**And** pnpm workspaces est configuré à la racine

### Story 0.2 : Configuration du package shared

As a développeur,
I want configurer le package @mdb/shared avec les types, utilitaires et client API partagés,
So that le code commun entre mobile et web est centralisé et typé.

**Acceptance Criteria:**

**Given** le package `packages/shared/` initialisé
**When** le développeur configure le package
**Then** le `tsconfig.json` est configuré en strict mode
**And** le package exporte des types de base : `User`, `Property`, `Contact`, `ApiResponse`
**And** le package exporte des utilitaires : `formatMoney()`, `formatDate()`, `validateEmail()`
**And** le package est importable via `@mdb/shared` depuis `apps/mobile/` et `apps/web/`
**And** les tests unitaires passent (`pnpm test`)

### Story 0.3 : Configuration Docker production et déploiement backend

As a développeur,
I want configurer le Dockerfile FrankenPHP, docker-compose.prod.yml et deploy.sh,
So that le backend peut être déployé automatiquement sur le serveur OVH.

**Acceptance Criteria:**

**Given** le projet `backend-api/` existant
**When** le développeur exécute `deploy.sh`
**Then** l'image Docker est construite avec FrankenPHP + Octane
**And** l'image est pushée vers `docker-registry.miweb.fr/mdb-copilot-api`
**And** `docker-compose.prod.yml` configure app + MySQL + queue + scheduler
**And** le réseau Docker `docker_internal` est utilisé

### Story 0.4 : Configuration qualité code et linting

As a développeur,
I want configurer ESLint, Prettier et TypeScript strict sur tous les projets,
So that la qualité du code est garantie et cohérente.

**Acceptance Criteria:**

**Given** les projets `apps/mobile/`, `apps/web/` et `packages/shared/`
**When** le développeur lance les outils de qualité
**Then** ESLint est configuré avec les règles React/React Native appropriées
**And** Prettier formate le code automatiquement on-save
**And** TypeScript strict mode est activé sur tous les projets
**And** `pnpm lint` s'exécute sur tout le monorepo sans erreur
**And** `pnpm typecheck` vérifie les types sans erreur

**Given** le projet `backend-api/`
**Then** PHPStan (niveau max) et Laravel Pint restent configurés (inchangés)

### Story 0.5 : Configuration du Design System et Theme

As a développeur,
I want configurer le Design System Material 3 avec les tokens MDB Copilot,
So that l'UI est cohérente sur mobile et web dès le premier écran.

**Acceptance Criteria:**

**Given** les projets `apps/mobile/` et `apps/web/` initialisés
**When** le développeur configure les themes
**Then** MUI theme est configuré dans `apps/web/` avec :
  - Palette Light : Primary #7c4dff, Accent #f3419f
  - Palette Dark : Primary #5750d8, Accent #d063de, Background rgb(30,35,52)
  - Typography : Inter via @fontsource/inter
  - Shape : borderRadius pills 24px, cards 16px, inputs 12px

**And** React Native Paper theme est configuré dans `apps/mobile/` avec les mêmes tokens
**And** un composant `ThemeProvider` wrappe l'app sur les deux plateformes
**And** le dark mode switch fonctionne (suit les préférences système)
**And** un fichier `packages/shared/src/theme/colors.ts` centralise les constantes couleur

### Story 0.6 : Configuration de l'infrastructure de tests

As a développeur,
I want configurer l'infrastructure de tests sur tous les projets,
So that je peux écrire des tests dès la première story.

**Acceptance Criteria:**

**Given** les projets du monorepo
**When** le développeur configure les tests
**Then** Jest est configuré dans `apps/web/` avec React Testing Library
**And** Jest est configuré dans `apps/mobile/` avec React Native Testing Library
**And** Jest est configuré dans `packages/shared/` pour les utilitaires
**And** `pnpm test` exécute tous les tests du monorepo
**And** un test example passe sur chaque projet
**And** les mocks pour `fetch`/API sont configurés dans un fichier partagé
**And** PHPUnit reste configuré dans `backend-api/` (inchangé)

### Story 0.7 : Service de scraping backend

As a développeur,
I want implémenter le service de scraping côté Laravel,
So that l'import via lien fonctionne dès Epic 2.

**Acceptance Criteria:**

**Given** le projet `backend-api/` existant
**When** le développeur implémente le service de scraping
**Then** `ScrapingController` expose `POST /api/scrape` avec paramètre `url`
**And** `ScrapingService` détecte le site source (LeBonCoin, SeLoger, PAP, Logic-Immo)
**And** `ScraperInterface` définit le contrat commun pour tous les scrapers
**And** `LeBonCoinScraper` extrait : titre, prix, surface, adresse, description, photos
**And** les autres scrapers (SeLoger, PAP, Logic-Immo) retournent un stub "non implémenté" pour le MVP
**And** `ScrapingResult` est un DTO typé retourné par l'API
**And** les tests unitaires couvrent le scraper LeBonCoin avec des fixtures HTML

---

## Epic 1 : Authentification & Gestion de compte

L'utilisateur peut créer un compte, se connecter, gérer son profil et inviter des collaborateurs avec des rôles différenciés.

### Story 1.1 : Inscription utilisateur

As a utilisateur,
I want créer un compte avec prénom, nom, email et mot de passe,
So that j'accède à mon espace personnel MDB Copilot.

**Acceptance Criteria:**

**Given** un utilisateur non inscrit
**When** il soumet le formulaire d'inscription (prénom, nom, email, mot de passe, confirmation mot de passe)
**Then** un compte est créé avec mot de passe hashé (bcrypt)
**And** un token Sanctum est généré avec ability `owner`
**And** l'utilisateur est redirigé vers l'écran d'accueil
**And** le token est stocké de manière sécurisée (SecureStore mobile, httpOnly cookie ou localStorage web)

**Given** un email déjà utilisé
**When** l'utilisateur tente de s'inscrire
**Then** une erreur "Cet email est déjà utilisé" s'affiche

**Given** un mot de passe trop faible
**When** l'utilisateur soumet le formulaire
**Then** une erreur de validation s'affiche avec les critères requis

### Story 1.2 : Connexion et déconnexion

As a utilisateur inscrit,
I want me connecter et me déconnecter de mon compte,
So that j'accède à mes données de manière sécurisée.

**Acceptance Criteria:**

**Given** un utilisateur inscrit
**When** il soumet ses identifiants (email, mot de passe) sur l'écran de connexion
**Then** un token Sanctum est retourné et stocké
**And** les requêtes API incluent le token Bearer
**And** l'utilisateur est redirigé vers le Dashboard

**Given** des identifiants incorrects
**When** l'utilisateur tente de se connecter
**Then** une erreur "Email ou mot de passe incorrect" s'affiche
**And** aucune indication ne révèle si l'email existe ou non

**Given** un utilisateur connecté
**When** il choisit de se déconnecter
**Then** le token Sanctum est révoqué côté serveur
**And** le stockage local du token est effacé
**And** l'utilisateur est redirigé vers l'écran de connexion

### Story 1.3 : Réinitialisation du mot de passe

As a utilisateur,
I want réinitialiser mon mot de passe via email,
So that je récupère l'accès à mon compte si j'oublie mon mot de passe.

**Acceptance Criteria:**

**Given** un utilisateur sur l'écran "Mot de passe oublié"
**When** il saisit son email et soumet le formulaire
**Then** un email avec un lien de réinitialisation est envoyé
**And** un message "Si cet email existe, vous recevrez un lien" s'affiche (sécurité)

**Given** un lien de réinitialisation valide
**When** l'utilisateur clique et saisit un nouveau mot de passe
**Then** le mot de passe est mis à jour
**And** tous les tokens existants sont révoqués
**And** l'utilisateur est redirigé vers la connexion avec un message de succès

**Given** un lien de réinitialisation expiré (> 1h)
**When** l'utilisateur clique dessus
**Then** une erreur "Lien expiré" s'affiche avec option de redemander

### Story 1.4 : Gestion du profil utilisateur

As a utilisateur connecté,
I want modifier mon prénom, nom, email et mot de passe,
So that mes informations personnelles restent à jour.

**Acceptance Criteria:**

**Given** un utilisateur connecté
**When** il accède à l'écran Profil
**Then** ses informations actuelles (prénom, nom, email) sont affichées

**Given** l'écran Profil
**When** l'utilisateur modifie son prénom ou nom et sauvegarde
**Then** les modifications sont enregistrées côté serveur
**And** l'UI reflète les changements immédiatement

**Given** l'écran Profil
**When** l'utilisateur modifie son email
**Then** une vérification de l'email peut être requise (optionnel MVP)
**And** l'email est mis à jour après validation

**Given** l'écran Profil
**When** l'utilisateur modifie son mot de passe (ancien + nouveau + confirmation)
**Then** le mot de passe est mis à jour si l'ancien est correct
**And** une erreur s'affiche si l'ancien mot de passe est incorrect
**And** une erreur s'affiche si nouveau et confirmation ne correspondent pas

### Story 1.5 : Invitation d'utilisateurs avec rôle

As a propriétaire (owner),
I want inviter des utilisateurs avec un rôle (guest-read, guest-extended),
So that je peux collaborer avec des partenaires tout en contrôlant leur accès.

**Acceptance Criteria:**

**Given** un utilisateur owner sur l'écran Invitations
**When** il invite un email avec le rôle `guest-read` ou `guest-extended`
**Then** un email d'invitation est envoyé avec un lien unique
**And** l'invitation apparaît dans la liste des invitations en attente

**Given** un invité qui clique sur le lien d'invitation
**When** il crée un compte (ou se connecte si déjà inscrit)
**Then** le compte est lié au owner avec le rôle assigné
**And** le token Sanctum de l'invité porte les abilities correspondantes

**Given** un utilisateur owner
**When** il consulte la liste des invitations
**Then** il voit les invitations en attente et acceptées
**And** il peut révoquer une invitation ou un accès existant

### Story 1.6 : Accès restreint par rôle

As a utilisateur invité,
I want accéder uniquement aux données autorisées par mon rôle,
So that je consulte ce que le propriétaire m'a autorisé.

**Acceptance Criteria:**

**Given** un utilisateur `guest-read`
**When** il accède à l'application
**Then** il peut consulter les fiches et le pipeline (lecture seule)
**And** il ne peut pas modifier, créer ou supprimer de données
**And** les boutons d'action (créer, modifier, supprimer) sont masqués ou désactivés

**Given** un utilisateur `guest-extended`
**When** il accède à l'application
**Then** il peut consulter et modifier les fiches selon les permissions étendues
**And** il ne peut pas inviter d'autres utilisateurs
**And** il ne peut pas modifier les paramètres du compte owner

**Given** un utilisateur invité tentant une action non autorisée via API
**When** la requête est envoyée
**Then** une erreur 403 Forbidden est retournée
**And** l'action n'est pas exécutée

---

## Epic 2 : Carnet d'adresses & Fiches annonces

L'utilisateur peut gérer ses contacts professionnels et créer des fiches annonces par saisie manuelle ou import de lien (LeBonCoin, SeLoger, PAP, Logic-Immo).

### Story 2.1 : CRUD Carnet d'adresses

As a utilisateur,
I want gérer un carnet d'adresses de contacts professionnels,
So that je centralise mes interlocuteurs et les réutilise dans mes fiches annonces.

**Acceptance Criteria:**

**Given** un utilisateur connecté
**When** il accède au Carnet d'adresses
**Then** la liste de tous ses contacts est affichée, triée par nom
**And** un filtre par type de contact est disponible (agent immobilier, artisan, notaire, courtier, autre)

**Given** le Carnet d'adresses
**When** l'utilisateur crée un nouveau contact (prénom, nom, entreprise, téléphone, email, type, notes)
**Then** le contact est créé avec un UUID v4
**And** le champ "type de contact" est obligatoire, les autres champs sauf nom sont optionnels
**And** le contact est sauvegardé (DB locale + sync serveur)

**Given** un contact existant
**When** l'utilisateur modifie ses informations
**Then** les modifications sont enregistrées
**And** le champ `updated_at` est mis à jour

**Given** un contact existant
**When** l'utilisateur choisit de le supprimer
**Then** une confirmation est demandée
**And** si le contact est associé à des fiches annonces, un avertissement le signale
**And** si confirmé, le contact est soft-deleted

### Story 2.2 : Création fiche annonce — Saisie manuelle avec agent

As a utilisateur,
I want créer une fiche annonce par saisie manuelle avec possibilité d'associer un agent,
So that je centralise les informations d'une opportunité immobilière.

**Acceptance Criteria:**

**Given** un utilisateur connecté
**When** il remplit le formulaire de création (adresse, surface, prix, type de bien)
**Then** une fiche annonce est créée avec un UUID v4
**And** la fiche est sauvegardée (DB locale + sync serveur)
**And** la fiche apparaît dans la liste des fiches

**Given** le formulaire de création, section agent
**When** l'utilisateur ouvre le sélecteur d'agent
**Then** une liste affiche uniquement les contacts de type "agent immobilier" du carnet
**And** un bouton "Créer un nouveau contact" permet d'ajouter un agent inline
**And** le champ agent est optionnel

**Given** le formulaire de fiche
**When** l'utilisateur sélectionne un agent existant
**Then** la fiche est liée au contact via `contact_id`
**And** les informations de l'agent (nom, entreprise, téléphone) s'affichent sous le sélecteur

**Given** le formulaire de fiche
**When** l'utilisateur crée un agent inline
**Then** le nouveau contact est créé avec type "agent immobilier" (réutilise la logique de Story 2.1)
**And** il est automatiquement sélectionné pour la fiche

**Given** le formulaire de création
**When** l'utilisateur sélectionne un niveau d'urgence de vente (faible, moyen, élevé)
**Then** l'urgence est enregistrée dans la fiche
**And** le champ urgence est optionnel avec valeur par défaut "non renseigné"

**Given** le formulaire de création
**When** l'utilisateur ajoute des notes libres
**Then** les notes sont enregistrées en texte libre dans la fiche

### Story 2.3 : Création fiche annonce — Import via lien

As a utilisateur,
I want créer une fiche annonce en collant un lien (LeBonCoin, SeLoger, PAP, Logic-Immo),
So that je gagne du temps en évitant la saisie manuelle.

**Acceptance Criteria:**

**Given** un utilisateur sur l'écran de création de fiche
**When** il colle un lien d'annonce LeBonCoin
**Then** le système détecte le site source et affiche "Analyse en cours..."
**And** l'API backend `/api/scrape` est appelée avec l'URL
**And** les données extraites (adresse, surface, prix, type, photos, description) pré-remplissent le formulaire

**Given** un lien SeLoger, PAP ou Logic-Immo
**When** l'utilisateur colle le lien
**Then** le scraper correspondant est utilisé
**And** les données disponibles sont extraites

**Given** une extraction réussie complète
**When** les données sont retournées
**Then** le formulaire est pré-rempli entièrement
**And** l'utilisateur peut modifier les champs avant validation
**And** les photos sont affichées en miniature
**And** l'utilisateur peut associer un agent (comme dans Story 2.2)

### Story 2.4 : Import via lien — Extraction partielle et fallback

As a utilisateur,
I want que l'import fonctionne même si l'extraction est partielle,
So that je ne suis pas bloqué si le site source a changé.

**Acceptance Criteria:**

**Given** un lien d'annonce dont l'extraction est partielle
**When** le scraping retourne des données incomplètes
**Then** un message positif s'affiche : "On a trouvé des infos ! Aide-nous à compléter."
**And** le formulaire est pré-rempli avec les champs extraits (marqués visuellement)
**And** les champs manquants sont vides avec placeholder indicatif

**Given** une extraction sans photos
**When** le formulaire s'affiche
**Then** une section "Ajouter des photos" permet l'upload depuis la galerie

**Given** un lien non supporté ou extraction totalement vide
**When** le scraping échoue
**Then** un message s'affiche : "Ce site n'est pas encore supporté, créons la fiche ensemble"
**And** le formulaire de saisie manuelle s'affiche vide

### Story 2.5 : Consultation et liste des fiches annonces

As a utilisateur,
I want consulter la liste de mes fiches et voir le détail de chacune,
So that j'ai une vue d'ensemble de mes opportunités.

**Acceptance Criteria:**

**Given** un utilisateur connecté avec des fiches existantes
**When** il accède à l'écran liste des fiches
**Then** toutes ses fiches sont affichées avec adresse, prix, surface, type et urgence
**And** la liste est triée par date de création (plus récente en premier)

**Given** la liste des fiches
**When** l'utilisateur sélectionne une fiche
**Then** l'écran détail affiche toutes les informations : bien, agent associé, urgence, notes, photos

**Given** l'écran détail
**When** l'utilisateur consulte la section agent
**Then** les informations de l'agent (depuis le carnet d'adresses) sont affichées avec lien vers la fiche contact

### Story 2.6 : Modification et suppression d'une fiche annonce

As a utilisateur,
I want modifier ou supprimer une fiche annonce,
So que mes données restent à jour.

**Acceptance Criteria:**

**Given** l'écran détail d'une fiche
**When** l'utilisateur modifie un champ et sauvegarde
**Then** les modifications sont enregistrées
**And** le champ `updated_at` est mis à jour

**Given** l'écran détail d'une fiche
**When** l'utilisateur modifie l'agent associé
**Then** la nouvelle association est enregistrée
**And** l'ancien agent n'est pas supprimé du carnet d'adresses

**Given** l'écran détail d'une fiche
**When** l'utilisateur choisit de supprimer la fiche
**Then** une confirmation est demandée
**And** si confirmé, la fiche est soft-deleted
**And** la fiche disparaît de la liste

---

## Epic 3 : Pipeline Kanban

L'utilisateur peut visualiser toutes ses annonces dans un pipeline visuel et suivre la progression de chaque projet.

### Story 3.1 : Visualisation du pipeline Kanban

As a utilisateur,
I want visualiser toutes mes annonces dans un pipeline Kanban,
So that j'ai une vue d'ensemble de la progression de chaque projet.

**Acceptance Criteria:**

**Given** un utilisateur connecté avec des fiches annonces
**When** il accède à l'écran Pipeline
**Then** un Kanban s'affiche avec les colonnes : Prospection, RDV, Visite, Analyse, Offre, Acheté, Travaux, Vente, Vendu, No Go
**And** chaque fiche apparaît dans la colonne correspondant à son statut
**And** chaque carte affiche adresse, prix et urgence
**And** le statut par défaut d'une nouvelle fiche est "Prospection"

**Given** le pipeline sur mobile (< 600dp)
**When** l'utilisateur consulte le Kanban
**Then** les colonnes sont scrollables horizontalement
**And** chaque colonne affiche le nombre de fiches

**Given** le pipeline sur desktop (≥ 600dp)
**When** l'utilisateur consulte le Kanban
**Then** toutes les colonnes sont visibles simultanément
**And** le drag & drop est disponible entre colonnes

### Story 3.2 : Déplacement des annonces dans le pipeline

As a utilisateur,
I want déplacer une annonce d'une étape à l'autre,
So that je mets à jour la progression de mes projets.

**Acceptance Criteria:**

**Given** une fiche dans une colonne du pipeline
**When** l'utilisateur la déplace vers une autre colonne (drag & drop sur desktop, menu action sur mobile)
**Then** le statut de la fiche est mis à jour
**And** la fiche apparaît dans la nouvelle colonne
**And** la modification est synchronisée au serveur

**Given** un déplacement de fiche
**When** le statut passe à "RDV"
**Then** une checklist pré-visite est générée automatiquement (liaison Epic 4)

**Given** un déplacement de fiche vers "No Go"
**When** l'utilisateur confirme
**Then** la fiche est archivée dans la colonne No Go
**And** elle reste consultable mais n'apparaît plus dans les vues actives par défaut

### Story 3.3 : Filtres et tri du pipeline

As a utilisateur,
I want filtrer et trier mes annonces dans le pipeline,
So that je retrouve rapidement les projets qui m'intéressent.

**Acceptance Criteria:**

**Given** le pipeline Kanban affiché
**When** l'utilisateur applique un filtre par type de bien
**Then** seules les fiches correspondantes sont affichées dans chaque colonne

**Given** le pipeline Kanban affiché
**When** l'utilisateur applique un filtre par urgence
**Then** seules les fiches avec l'urgence sélectionnée sont affichées

**Given** le pipeline Kanban affiché
**When** l'utilisateur applique un tri (prix croissant/décroissant, date, urgence)
**Then** les cartes dans chaque colonne sont réordonnées selon le critère

**Given** des filtres actifs
**When** l'utilisateur réinitialise les filtres
**Then** toutes les fiches sont à nouveau visibles
**And** les filtres actifs sont clairement indiqués visuellement

---

## Epic 4 : Checklist Pré-visite

L'utilisateur peut préparer ses visites avec une checklist structurée qui se génère automatiquement au passage en statut "RDV".

### Story 4.1 : Génération automatique de la checklist pré-visite

As a utilisateur,
I want qu'une checklist de préparation se génère automatiquement quand une annonce passe au statut "RDV",
So that je n'oublie aucune étape de préparation avant la visite.

**Acceptance Criteria:**

**Given** une fiche annonce
**When** son statut passe à "RDV" dans le pipeline
**Then** une checklist pré-visite est créée automatiquement et liée à la fiche
**And** la checklist contient les catégories : questions à poser à l'agent, documents à demander, points à vérifier sur place
**And** chaque catégorie contient des items prédéfinis adaptés au type de bien

**Given** une fiche qui repasse en "Prospection" depuis "RDV"
**When** le statut change
**Then** la checklist existante est conservée (pas de suppression)

### Story 4.2 : Consultation et cochage de la checklist

As a utilisateur,
I want consulter ma checklist pré-visite et cocher les éléments au fur et à mesure,
So that je prépare méthodiquement chaque visite.

**Acceptance Criteria:**

**Given** une fiche avec une checklist générée
**When** l'utilisateur accède à la checklist depuis la fiche
**Then** tous les items sont affichés par catégorie avec leur état (coché/non coché)

**Given** un item de checklist non coché
**When** l'utilisateur le coche
**Then** l'état est mis à jour immédiatement
**And** la progression globale (X/Y items complétés) est affichée
**And** la modification est synchronisée

**Given** la checklist
**When** tous les items sont cochés
**Then** un indicateur visuel confirme que la préparation est complète
**And** un badge "Prêt" apparaît sur la fiche dans le pipeline

---

## Epic 5 : Guide de Visite Interactif

L'utilisateur peut parcourir un guide terrain complet, répondre aux questions guidées, prendre des photos et notes — en mode offline.

### Story 5.1 : Parcours du guide de visite par catégorie

As a utilisateur,
I want parcourir un guide de visite organisé par catégorie,
So que j'inspecte méthodiquement chaque aspect du bien sans rien oublier.

**Acceptance Criteria:**

**Given** une fiche au statut "Visite" ou supérieur
**When** l'utilisateur ouvre le guide de visite
**Then** les catégories s'affichent : Structure/Gros œuvre, Électricité, Plomberie, Toiture, Isolation, Division possible, Extérieurs, Environnement
**And** chaque catégorie est accessible via des chips scrollables horizontalement
**And** la progression par catégorie est affichée (✓ complète, en cours, vide)

**Given** une catégorie du guide
**When** l'utilisateur y accède
**Then** les questions guidées spécifiques s'affichent
**And** chaque question a un type de réponse adapté (choix simple, choix multiple, oui/non, texte libre, slider)

### Story 5.2 : Réponses aux questions guidées

As a utilisateur,
I want répondre aux questions guidées pour chaque catégorie,
So que je documente systématiquement l'état du bien.

**Acceptance Criteria:**

**Given** une question du guide de visite
**When** l'utilisateur répond (tap sur choix, slider, texte)
**Then** la réponse est enregistrée immédiatement (sauvegarde continue)
**And** la progression de la catégorie est mise à jour

**Given** une réponse indiquant un problème critique (ex: "Fissures structurelles: Oui")
**When** la réponse est enregistrée
**Then** un indicateur d'alerte apparaît sur la catégorie
**And** ce point sera remonté dans la synthèse post-visite

**Given** le guide de visite
**When** l'utilisateur navigue entre catégories
**Then** les réponses déjà saisies sont conservées
**And** il peut revenir modifier une réponse précédente

### Story 5.3 : Photos contextualisées et notes agent

As a utilisateur,
I want prendre des photos liées à un point du guide et saisir des notes,
So que je documente visuellement les constats et conserve les informations verbales.

**Acceptance Criteria:**

**Given** une question du guide de visite
**When** l'utilisateur prend une photo via le bouton caméra
**Then** la photo est liée à la question/catégorie spécifique
**And** la photo est compressée (< 500KB) et stockée localement
**And** une miniature apparaît à côté de la question

**Given** le guide de visite
**When** l'utilisateur accède à la section "Notes agent"
**Then** il peut saisir du texte libre sur les échanges avec l'agent immobilier
**And** les notes sont horodatées et liées à la visite

**Given** plusieurs photos prises pendant la visite
**When** l'utilisateur consulte la galerie de la visite
**Then** les photos sont organisées par catégorie
**And** chaque photo affiche la question associée

### Story 5.4 : Mode offline du guide de visite

As a utilisateur sur le terrain,
I want utiliser le guide de visite sans connexion internet,
So que je peux visiter des biens en cave, parking souterrain ou zone blanche.

**Acceptance Criteria:**

**Given** le guide de visite ouvert
**When** l'appareil perd la connexion internet
**Then** le guide fonctionne intégralement sans interruption
**And** toutes les réponses sont stockées localement (WatermelonDB mobile, Dexie web)
**And** les photos sont stockées localement

**Given** des données saisies en mode offline
**When** le réseau revient
**Then** les données sont synchronisées automatiquement en arrière-plan
**And** les photos sont uploadées dans une queue de priorité basse
**And** aucune action manuelle n'est requise

**Given** une visite terminée en mode offline
**When** l'utilisateur quitte le guide
**Then** un indicateur montre "Données en attente de sync"
**And** la synthèse post-visite peut être générée localement

---

## Epic 6 : Synthèse Post-visite

Le système génère automatiquement une synthèse avec alertes, estimation de marge et verdict Go/No Go.

### Story 6.1 : Génération automatique de la synthèse post-visite

As a utilisateur,
I want que le système génère une synthèse complète basée sur mes réponses du guide de visite,
So que j'ai un récapitulatif structuré sans effort de rédaction.

**Acceptance Criteria:**

**Given** un guide de visite avec des réponses complétées
**When** l'utilisateur termine la visite ou demande la synthèse
**Then** le système génère une synthèse récapitulant les constats par catégorie
**And** la synthèse est générée côté client (logique embarquée, fonctionne offline)
**And** la synthèse est stockée et liée à la fiche annonce

**Given** un guide de visite partiellement complété
**When** l'utilisateur demande la synthèse
**Then** la synthèse est générée avec les données disponibles
**And** un avertissement indique les catégories non complétées

### Story 6.2 : Alertes sur les points critiques (red flags)

As a utilisateur,
I want voir les alertes sur les points critiques détectés,
So que je identifie immédiatement les risques majeurs.

**Acceptance Criteria:**

**Given** une synthèse post-visite générée
**When** l'utilisateur consulte la synthèse
**Then** les alertes rouges sont affichées en priorité (problèmes structurels, amiante probable, électricité vétuste, etc.)
**And** chaque alerte est catégorisée par sévérité (critique, attention, info)
**And** le nombre d'alertes par sévérité est résumé en haut de la synthèse

**Given** une alerte critique
**When** l'utilisateur la consulte
**Then** la question source et la réponse sont affichées
**And** un lien vers la fiche mémo pertinente est proposé (liaison Epic 8)

### Story 6.3 : Estimation de marge prévisionnelle

As a utilisateur,
I want voir une estimation de marge prévisionnelle,
So que j'évalue rapidement la rentabilité potentielle.

**Acceptance Criteria:**

**Given** une synthèse avec les données financières de la fiche (prix annoncé)
**When** le système calcule la marge prévisionnelle
**Then** une estimation est affichée : prix achat estimé + travaux estimés (basé sur alertes) vs prix de revente estimé
**And** la marge est affichée en euros et en pourcentage

**Given** des alertes travaux dans la synthèse
**When** l'estimation travaux est calculée
**Then** chaque catégorie d'alerte contribue à une fourchette de coût
**And** l'utilisateur peut ajuster manuellement les montants

### Story 6.4 : Décision Go/No Go et liens mémo contextuels

As a utilisateur,
I want marquer ma décision et consulter des fiches mémo pertinentes,
So que je prends une décision éclairée et documentée.

**Acceptance Criteria:**

**Given** la synthèse complète consultée
**When** l'utilisateur consulte la section décision
**Then** trois options sont proposées : Go, No Go, À approfondir
**And** l'option sélectionnée est enregistrée et visible sur la fiche

**Given** des alertes spécifiques dans la synthèse
**When** la synthèse est affichée
**Then** des liens contextuels vers les fiches mémo pertinentes apparaissent (ex: "Red flags structurels", "Estimation travaux électricité")
**And** les fiches mémo s'ouvrent en bottom sheet sans quitter la synthèse

**Given** une décision "Go" sélectionnée
**When** l'utilisateur confirme
**Then** la fiche passe automatiquement au statut "Offre" dans le pipeline

---

## Epic 7 : Onboarding

Le nouvel utilisateur est guidé par un écran d'accueil personnalisé et un tour guidé des fonctionnalités principales.

### Story 7.1 : Écran d'accueil première utilisation

As a nouvel utilisateur,
I want voir un écran d'accueil avec des options de démarrage,
So que je sais par où commencer.

**Acceptance Criteria:**

**Given** un utilisateur qui ouvre l'app pour la première fois après inscription
**When** l'écran d'accueil s'affiche
**Then** un message personnalisé "Bienvenue [Prénom] !" apparaît
**And** trois options de démarrage sont présentées clairement :
  - 📎 "Coller un lien d'annonce" (action rapide)
  - ✏️ "Saisir une annonce manuellement"
  - 👀 "Explorer l'app d'abord"

**Given** l'écran d'accueil
**When** l'utilisateur choisit "Coller un lien"
**Then** il est redirigé vers le formulaire de création avec le champ lien focus

**Given** l'écran d'accueil
**When** l'utilisateur choisit "Saisir manuellement"
**Then** il est redirigé vers le formulaire de création manuelle

### Story 7.2 : Tour guidé des fonctionnalités

As a nouvel utilisateur,
I want suivre un tour guidé des fonctionnalités principales,
So que je comprends rapidement comment utiliser l'app.

**Acceptance Criteria:**

**Given** l'utilisateur qui choisit "Explorer l'app"
**When** le tour guidé démarre
**Then** un overlay présente 5 écrans successifs :
  1. Pipeline Kanban ("Suivez vos opportunités")
  2. Fiche annonce ("Centralisez les infos")
  3. Guide de visite ("Ne ratez rien sur le terrain")
  4. Fiches mémo ("Apprenez en pratiquant")
  5. Score d'opportunité ("Décidez en confiance")

**Given** le tour guidé en cours
**When** l'utilisateur navigue
**Then** des boutons Précédent/Suivant permettent de naviguer
**And** un indicateur de progression (dots) montre l'étape actuelle
**And** un bouton "Passer" permet de quitter à tout moment

**Given** la fin du tour guidé
**When** l'utilisateur termine ou passe
**Then** il est redirigé vers l'écran d'accueil avec les options de création
**And** un flag "onboarding_completed" est enregistré

**Given** un utilisateur ayant complété l'onboarding
**When** il revient dans l'app
**Then** l'écran d'accueil n'apparaît plus automatiquement
**And** le tour guidé reste accessible depuis les paramètres

---

## Epic 8 : Fiches Mémo MDB

L'utilisateur peut consulter des guides éducatifs et fiches mémo synthétiques sur la fiscalité, le juridique et les bonnes pratiques MDB.

### Story 8.1 : Consultation des guides et fiches mémo

As a utilisateur débutant MDB,
I want consulter des guides complets et des fiches mémo synthétiques,
So que je me forme progressivement et évite les erreurs coûteuses.

**Acceptance Criteria:**

**Given** un utilisateur connecté
**When** il accède à la section "Mémos MDB"
**Then** une liste de guides est affichée organisée par thème : Fiscalité, Juridique, Bonnes pratiques, Financement
**And** chaque thème contient plusieurs fiches

**Given** la section Mémos
**When** l'utilisateur sélectionne un guide complet
**Then** un contenu éducatif structuré s'affiche avec titres, paragraphes et exemples
**And** le contenu est scrollable et lisible sur mobile

**Given** la section Mémos
**When** l'utilisateur consulte une fiche mémo synthétique
**Then** une fiche condensée (1-2 écrans max) résume les points essentiels
**And** des bullet points facilitent la lecture rapide

### Story 8.2 : Fiches mémo consultables offline

As a utilisateur sur le terrain,
I want consulter les fiches mémo sans connexion,
So que j'ai accès à l'aide même en zone blanche.

**Acceptance Criteria:**

**Given** les guides et fiches mémo
**When** l'utilisateur se connecte pour la première fois
**Then** tout le contenu éducatif est téléchargé et stocké localement

**Given** l'appareil hors connexion
**When** l'utilisateur accède aux Mémos MDB
**Then** tout le contenu est consultable sans erreur
**And** aucun message "connexion requise" n'apparaît

### Story 8.3 : Suggestions de fiches mémo contextuelles

As a utilisateur,
I want recevoir des suggestions de fiches mémo pertinentes selon mon action,
So que j'apprends au bon moment dans mon workflow.

**Acceptance Criteria:**

**Given** l'utilisateur sur une fiche annonce avec score d'opportunité calculé
**When** le score est affiché
**Then** un chip "Comprendre le score" propose d'ouvrir la fiche mémo correspondante

**Given** une synthèse post-visite avec des alertes red flags
**When** la synthèse est affichée
**Then** des chips contextuels apparaissent pour chaque type d'alerte (ex: "En savoir plus sur les fissures")

**Given** l'utilisateur sur le simulateur TVA
**When** le simulateur s'affiche
**Then** un lien vers la fiche "TVA sur marge vs TVA sur total" est proposé

**Given** un chip de suggestion mémo
**When** l'utilisateur le tape
**Then** la fiche mémo s'ouvre en bottom sheet
**And** l'utilisateur peut la fermer pour revenir à son contexte

---

## Epic 9 : Score d'Opportunité & Intégration DVF

Le système calcule un score d'opportunité combinant prix vs marché (DVF), urgence de vente et potentiel.

### Story 9.1 : Calcul et affichage du score d'opportunité

As a utilisateur,
I want que le système calcule un score d'opportunité pour chaque annonce,
So que je priorise rapidement les meilleures opportunités.

**Acceptance Criteria:**

**Given** une fiche annonce avec prix, localisation et urgence renseignés
**When** le système calcule le score d'opportunité
**Then** un score (0-100) est généré combinant : écart prix vs marché (DVF si disponible), urgence de vente, potentiel estimé
**And** le score est affiché avec un code couleur (vert ≥70, orange 40-69, rouge <40)

**Given** l'écran détail d'une fiche
**When** l'utilisateur consulte le score
**Then** les composantes du score sont détaillées avec leur contribution
**And** chaque composante est expliquée clairement

**Given** une fiche sans données DVF disponibles
**When** le score est calculé
**Then** le score est calculé sans la composante marché
**And** une mention "Données marché non disponibles" est affichée

### Story 9.2 : Récupération et affichage des données DVF

As a utilisateur,
I want consulter les transactions immobilières récentes autour d'une annonce,
So que j'évalue objectivement si le prix est cohérent avec le marché.

**Acceptance Criteria:**

**Given** une fiche annonce avec une adresse renseignée
**When** l'utilisateur demande les données DVF (ou automatiquement au calcul du score)
**Then** le système interroge l'API DVF via le proxy Laravel `/api/dvf`
**And** les transactions récentes dans un rayon pertinent sont récupérées

**Given** les données DVF récupérées
**When** l'utilisateur les consulte
**Then** une liste de transactions comparables s'affiche (adresse, surface, prix, date, type)
**And** un comparatif prix/m² est affiché entre l'annonce et la médiane des transactions
**And** une indication visuelle montre si le prix est au-dessus, dans la moyenne ou en dessous

### Story 9.3 : Cache DVF et consultation offline

As a utilisateur,
I want consulter les données DVF même sans connexion,
So que j'ai accès aux données marché lors de mes visites terrain.

**Acceptance Criteria:**

**Given** des données DVF téléchargées pour une fiche
**When** l'appareil passe hors connexion
**Then** les données DVF en cache restent consultables
**And** la date de dernière mise à jour est affichée

**Given** une requête DVF
**When** le cache contient des données récentes (< 24h)
**Then** le cache est utilisé sans nouvelle requête réseau

**Given** une requête DVF
**When** l'API DVF est indisponible
**Then** un message informe l'utilisateur "Données marché temporairement indisponibles"
**And** les données en cache (même anciennes) restent consultables avec mention de la date
**And** le score est calculé sans la composante marché

---

## Epic 10 : Simulateur TVA & Guide Fiscalité

L'utilisateur peut simuler la TVA sur marge et consulter les règles fiscales MDB pour maîtriser l'aspect fiscal.

### Story 10.1 : Simulateur TVA sur marge

As a utilisateur,
I want simuler la TVA sur marge pour une opération,
So que je maîtrise l'impact fiscal avant de faire une offre.

**Acceptance Criteria:**

**Given** l'écran simulateur TVA
**When** l'utilisateur saisit : prix d'achat, montant travaux, frais (notaire, agence)
**Then** le système calcule automatiquement la base TVA et la TVA due à la revente
**And** le calcul distingue TVA sur marge vs TVA sur total selon le cas

**Given** les paramètres saisis
**When** l'utilisateur modifie le prix de revente
**Then** le calcul se met à jour en temps réel
**And** la marge nette après TVA est affichée

**Given** le simulateur
**When** l'utilisateur souhaite comparer des scénarios
**Then** il peut sauvegarder un scénario et en créer un nouveau
**And** les scénarios sont comparables côte à côte

### Story 10.2 : Guide fiscalité MDB — Règles TVA

As a utilisateur débutant MDB,
I want consulter les règles TVA applicables,
So que je comprends quand appliquer la TVA sur marge ou sur total.

**Acceptance Criteria:**

**Given** l'écran Guide Fiscalité
**When** l'utilisateur consulte la section TVA
**Then** les règles TVA sur marge et TVA sur total sont expliquées clairement
**And** les conditions d'application de chaque régime sont détaillées
**And** des exemples chiffrés illustrent chaque cas

**Given** la section TVA
**When** l'utilisateur consulte un exemple
**Then** un calcul détaillé montre le raisonnement étape par étape

### Story 10.3 : Guide fiscalité MDB — Plus-value et régimes

As a utilisateur,
I want consulter les règles de plus-value et les régimes d'imposition,
So que j'anticipe la fiscalité globale de mes opérations.

**Acceptance Criteria:**

**Given** l'écran Guide Fiscalité
**When** l'utilisateur consulte la section plus-value professionnelle
**Then** les règles de calcul et d'imposition sont détaillées
**And** les abattements et exonérations sont expliqués

**Given** l'écran Guide Fiscalité
**When** l'utilisateur consulte les régimes d'imposition
**Then** les différents régimes applicables sont listés (micro-BIC, réel simplifié, etc.)
**And** les conditions et seuils de chaque régime sont précisés

### Story 10.4 : Alertes délais de revente fiscaux

As a utilisateur,
I want être alerté sur les délais de revente fiscaux,
So que je ne manque pas une échéance importante.

**Acceptance Criteria:**

**Given** une fiche annonce avec une date d'achat renseignée
**When** le système vérifie les délais de revente
**Then** une alerte est affichée si un délai fiscal approche (ex: délai 2 ans régime MDB)
**And** l'alerte précise le délai restant et les conséquences fiscales

**Given** une alerte de délai fiscal
**When** l'utilisateur la consulte
**Then** un lien vers la fiche mémo correspondante est proposé
**And** les options (revente avant/après délai) sont expliquées

---

## Epic 11 : Mode Offline & Sync

L'utilisateur peut consulter, saisir et modifier toutes ses données sans connexion avec synchronisation automatique.

### Story 11.1 : Consultation et saisie offline

As a utilisateur sur le terrain,
I want consulter et modifier mes données sans connexion internet,
So que je travaille efficacement même dans des zones sans réseau.

**Acceptance Criteria:**

**Given** un utilisateur avec des données synchronisées
**When** l'appareil perd la connexion internet
**Then** toutes les fiches annonces restent consultables depuis la DB locale
**And** l'utilisateur peut créer de nouvelles fiches
**And** l'utilisateur peut modifier des fiches existantes
**And** les photos stockées localement restent consultables

**Given** des modifications effectuées en mode offline
**When** l'utilisateur crée ou modifie des données
**Then** chaque entité modifiée est marquée `syncStatus: pending`
**And** un indicateur visuel discret montre "Données en attente de sync"

### Story 11.2 : Synchronisation automatique au retour réseau

As a utilisateur,
I want que mes données se synchronisent automatiquement,
So que je n'ai aucune action manuelle à effectuer.

**Acceptance Criteria:**

**Given** des données en attente de synchronisation
**When** la connexion internet revient
**Then** le sync engine déclenche automatiquement la synchronisation
**And** les données sont envoyées via `POST /api/sync` (delta incrémental via `updated_at`)
**And** les conflits sont résolus en last-write-wins

**Given** une synchronisation en cours
**When** le processus se termine
**Then** les entités synchronisées passent de `pending` à `synced`
**And** les nouvelles données du serveur sont intégrées localement
**And** un feedback discret confirme "Synchronisation terminée"

**Given** un échec de synchronisation (réseau instable)
**When** la requête échoue
**Then** le système retry avec backoff exponentiel (1s, 2s, 4s, 8s...)
**And** aucune donnée n'est perdue
**And** l'utilisateur est informé discrètement après plusieurs échecs

### Story 11.3 : Photos offline et upload différé

As a utilisateur,
I want que mes photos soient stockées localement et uploadées quand le réseau revient,
So que je peux documenter mes visites sans contrainte réseau.

**Acceptance Criteria:**

**Given** une photo prise en mode offline
**When** la photo est capturée
**Then** elle est compressée (< 500KB) et stockée localement
**And** elle est visible immédiatement dans l'app
**And** elle est ajoutée à la queue d'upload

**Given** des photos en queue d'upload
**When** le réseau revient
**Then** les photos sont uploadées en arrière-plan par ordre chronologique
**And** l'upload n'impacte pas la navigation de l'utilisateur
**And** chaque photo uploadée est marquée comme synchronisée

**Given** un upload de photo qui échoue
**When** l'erreur survient
**Then** la photo reste en queue pour retry ultérieur
**And** elle reste consultable localement
**And** un indicateur montre les photos en attente d'upload

---

## Epic 12 : Partage & Collaboration

L'utilisateur peut partager des fiches avec artisans (lien public) et associés (compte invité), avec masquage des données sensibles.

### Story 12.1 : Génération de lien public pour artisan

As a utilisateur,
I want générer un lien public vers une fiche projet pour un artisan,
So que l'artisan consulte les informations du bien sans créer de compte.

**Acceptance Criteria:**

**Given** une fiche annonce
**When** l'utilisateur génère un lien de partage public
**Then** un token unique signé est créé avec durée limitée (7 jours par défaut)
**And** le lien est copiable et partageable
**And** le lien est révocable à tout moment par l'utilisateur

**Given** le lien généré
**When** l'utilisateur configure le partage
**Then** il peut choisir la durée de validité (1 jour, 7 jours, 30 jours)
**And** il peut choisir les sections visibles (photos, description, travaux, contraintes)

### Story 12.2 : Consultation artisan via lien partagé

As a artisan,
I want consulter les informations d'un bien via un lien partagé,
So que je prépare mon estimation sans créer de compte.

**Acceptance Criteria:**

**Given** un artisan avec un lien de partage valide
**When** il ouvre le lien
**Then** il voit les informations du bien : photos organisées par zone, description des travaux, contraintes chantier
**And** les données financières du MDB (prix achat, marge, scoring) sont masquées
**And** aucune inscription n'est requise

**Given** un lien de partage expiré
**When** l'artisan ouvre le lien
**Then** une page "Lien expiré" s'affiche
**And** un message suggère de contacter le propriétaire pour un nouveau lien

### Story 12.3 : Soumission de devis par l'artisan

As a artisan,
I want soumettre une fourchette estimative de devis via le lien partagé,
So que je réponds rapidement à la demande sans paperasse.

**Acceptance Criteria:**

**Given** la vue artisan d'une fiche partagée
**When** l'artisan remplit le formulaire d'estimation (fourchette basse-haute, commentaires, délai estimé)
**Then** l'estimation est enregistrée et visible par l'utilisateur owner

**Given** une estimation soumise
**When** l'artisan valide
**Then** l'artisan voit une confirmation "Estimation envoyée"
**And** il peut modifier son estimation tant que le lien est valide

### Story 12.4 : Notification et consultation des estimations artisan

As a utilisateur owner,
I want être notifié quand un artisan soumet une estimation,
So que je réagis rapidement aux réponses.

**Acceptance Criteria:**

**Given** un artisan qui soumet une estimation
**When** l'estimation est enregistrée
**Then** le propriétaire reçoit une notification (in-app, et email si configuré)
**And** la notification indique le nom de la fiche et le montant estimé

**Given** des estimations reçues
**When** le propriétaire consulte la fiche
**Then** une section "Estimations artisans" liste toutes les soumissions
**And** chaque estimation affiche : fourchette, commentaires, date, statut

### Story 12.5 : Consultation associé via compte invité

As a associé potentiel,
I want consulter le pipeline et les fiches via un compte invité,
So que j'évalue l'activité MDB avant de m'engager.

**Acceptance Criteria:**

**Given** un utilisateur invité avec rôle `guest-extended`
**When** il se connecte à l'application
**Then** il voit le pipeline Kanban avec les projets en cours
**And** il peut consulter les fiches annonces selon ses permissions
**And** il ne voit pas les données de négociation sensibles définies par l'owner

**Given** un utilisateur invité avec rôle `guest-read`
**When** il se connecte
**Then** il a un accès en lecture seule au pipeline et aux fiches
**And** il ne peut modifier aucune donnée
**And** les boutons d'action sont masqués
