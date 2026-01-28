---
stepsCompleted: [1, 2, 3]
inputDocuments:
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/architecture.md
---

# mdb-tools - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for mdb-tools, decomposing the requirements from the PRD and Architecture into implementable stories.

## Requirements Inventory

### Functional Requirements

- **FR1 :** L'utilisateur peut créer un compte et s'authentifier
- **FR2 :** L'utilisateur peut gérer son profil (nom, email, mot de passe)
- **FR3 :** Le propriétaire peut inviter des utilisateurs avec un rôle (consultation, étendu)
- **FR4 :** L'utilisateur invité peut accéder uniquement aux données autorisées par son rôle
- **FR5 :** L'utilisateur peut créer une fiche annonce avec saisie manuelle (adresse, surface, prix, type de bien)
- **FR6 :** L'utilisateur peut renseigner les informations de l'agent immobilier (nom, agence, téléphone)
- **FR7 :** L'utilisateur peut indiquer le niveau d'urgence de vente
- **FR8 :** L'utilisateur peut ajouter des notes libres à une fiche annonce
- **FR9 :** L'utilisateur peut modifier et supprimer une fiche annonce
- **FR10 :** L'utilisateur peut consulter la liste de toutes ses fiches annonces
- **FR11 :** Le système calcule un score d'opportunité combinant prix vs marché (DVF), urgence de vente et potentiel
- **FR12 :** L'utilisateur peut consulter le détail du score et ses composantes
- **FR13 :** L'utilisateur peut visualiser toutes ses annonces dans un pipeline Kanban
- **FR14 :** L'utilisateur peut déplacer une annonce entre les étapes (Prospection → RDV → Visite → Analyse → Offre → Acheté → Travaux → Vente → Vendu)
- **FR15 :** L'utilisateur peut filtrer et trier les annonces dans le pipeline
- **FR16 :** L'utilisateur peut consulter une checklist de préparation avant visite (questions à poser, documents à demander, points à vérifier)
- **FR17 :** L'utilisateur peut cocher les éléments de la checklist pré-visite
- **FR18 :** La checklist pré-visite se génère automatiquement lors du passage au statut "RDV"
- **FR19 :** L'utilisateur peut parcourir un guide de visite organisé par catégorie (structure, électricité, plomberie, division, etc.)
- **FR20 :** L'utilisateur peut répondre à des questions guidées pour chaque catégorie
- **FR21 :** L'utilisateur peut prendre des photos contextualisées liées à un point du guide
- **FR22 :** L'utilisateur peut saisir des notes sur les échanges avec l'agent pendant la visite
- **FR23 :** Le guide de visite est utilisable en mode offline
- **FR24 :** Le système génère automatiquement une synthèse basée sur les réponses du guide de visite
- **FR25 :** La synthèse affiche des alertes sur les points critiques détectés
- **FR26 :** La synthèse inclut une première estimation de marge prévisionnelle
- **FR27 :** L'utilisateur peut consulter la synthèse pour prendre une décision Go/No Go
- **FR28 :** L'utilisateur peut consulter des guides complets sur les sujets MDB (fiscalité, juridique, bonnes pratiques)
- **FR29 :** L'utilisateur peut consulter des fiches mémo synthétiques pour chaque sujet
- **FR30 :** Les fiches mémo sont consultables en mode offline
- **FR31 :** L'utilisateur peut consulter ses fiches annonces sans connexion
- **FR32 :** L'utilisateur peut saisir et modifier des données sans connexion
- **FR33 :** Le système synchronise automatiquement les données au retour du réseau
- **FR34 :** L'utilisateur peut consulter les photos stockées localement sans connexion
- **FR35 :** Le système récupère les données de transactions récentes DVF pour une localisation donnée
- **FR36 :** L'utilisateur peut consulter les prix de transactions comparables autour d'une annonce
- **FR37 :** Les données DVF déjà téléchargées sont consultables en mode offline
- **FR38 :** L'utilisateur peut générer un lien public de consultation vers une fiche projet
- **FR39 :** Le lien public masque les données financières sensibles du MDB
- **FR40 :** L'artisan peut consulter les informations du bien (photos, plans, description travaux) via le lien partagé
- **FR41 :** L'artisan peut soumettre une fourchette estimative de devis via le lien partagé
- **FR42 :** L'associé invité peut consulter le pipeline et les fiches via son compte
- **FR43 :** L'utilisateur peut saisir les paramètres d'une opération (prix achat, travaux, frais)
- **FR44 :** Le système calcule automatiquement la base TVA et la TVA due à la revente
- **FR45 :** L'utilisateur peut simuler différents scénarios de prix de revente
- **FR46 :** L'utilisateur peut consulter les règles TVA sur marge vs TVA sur total
- **FR47 :** L'utilisateur peut consulter les règles de plus-value professionnelle
- **FR48 :** L'utilisateur peut consulter les différents régimes d'imposition applicables
- **FR49 :** Le système alerte l'utilisateur sur les délais de revente fiscaux

### NonFunctional Requirements

- **NFR1 :** Chargement initial mobile natif < 2s
- **NFR2 :** Chargement initial web < 3s
- **NFR3 :** Navigation entre écrans < 300ms
- **NFR4 :** Synchronisation après offline (10 fiches) < 5s
- **NFR5 :** Recherche DVF avec réseau < 3s
- **NFR6 :** Taille app installée < 50 MB
- **NFR7 :** Authentification Sanctum avec tokens révocables
- **NFR8 :** Mots de passe hashés (bcrypt/argon2)
- **NFR9 :** Communications HTTPS exclusivement
- **NFR10 :** Données stockées localement chiffrées (SQLCipher)
- **NFR11 :** Liens de partage publics avec token unique, révocables
- **NFR12 :** Séparation stricte des données par rôle
- **NFR13 :** Conformité RGPD : consentement, suppression, chiffrement
- **NFR14 :** Architecture multi-utilisateur ready
- **NFR15 :** Disponibilité cible 99%, backup quotidien, pas de perte de données offline

### Additional Requirements

- **AR1 :** Starter template Very Good CLI (Flutter) + Laravel 12 vanilla
- **AR2 :** Epic DevOps dédié : Sail (port prefix 4) + Dockerfile FrankenPHP + deploy.sh + qualité code via PHPStorm (inspections locales)
- **AR3 :** Drift (SQLite + SQLCipher) pour DB locale offline-first
- **AR4 :** Sanctum RBAC avec token abilities (owner, guest-read, guest-extended)
- **AR5 :** Repository pattern obligatoire (abstraction local/remote)
- **AR6 :** `adaptive_platform_ui` pour rendu iOS 26+ / Material adaptatif
- **AR7 :** Package `mdb_ui` pour widgets métier MDB
- **AR8 :** Sync engine : delta incrémental via `updated_at`, last-write-wins, `POST /api/sync`
- **AR9 :** UUID v4 pour tous les IDs d'entités
- **AR10 :** API REST JSON, pas de versioning, Scramble OpenAPI auto-doc
- **AR11 :** Monorepo : `mobile-app/` + `backend-api/`
- **AR12 :** Bloc/Cubit par feature, GoRouter, folder-by-feature

### FR Coverage Map

| FR | Epic | Description |
|----|------|-------------|
| FR1 | Epic 1 | Création compte et authentification |
| FR2 | Epic 1 | Gestion profil |
| FR3 | Epic 1 | Invitation utilisateurs avec rôle |
| FR4 | Epic 1 | Accès restreint par rôle |
| FR5 | Epic 2 | Création fiche annonce |
| FR6 | Epic 2 | Infos agent immobilier |
| FR7 | Epic 2 | Urgence de vente |
| FR8 | Epic 2 | Notes libres |
| FR9 | Epic 2 | Modification/suppression fiche |
| FR10 | Epic 2 | Liste des fiches |
| FR11 | Epic 7 | Calcul score d'opportunité |
| FR12 | Epic 7 | Détail du score |
| FR13 | Epic 3 | Visualisation pipeline Kanban |
| FR14 | Epic 3 | Déplacement entre étapes |
| FR15 | Epic 3 | Filtres et tri pipeline |
| FR16 | Epic 4 | Consultation checklist pré-visite |
| FR17 | Epic 4 | Cochage éléments checklist |
| FR18 | Epic 4 | Génération auto checklist |
| FR19 | Epic 5 | Guide visite par catégorie |
| FR20 | Epic 5 | Questions guidées |
| FR21 | Epic 5 | Photos contextualisées |
| FR22 | Epic 5 | Notes échanges agent |
| FR23 | Epic 5 | Guide visite offline |
| FR24 | Epic 6 | Génération synthèse auto |
| FR25 | Epic 6 | Alertes points critiques |
| FR26 | Epic 6 | Estimation marge prévisionnelle |
| FR27 | Epic 6 | Consultation synthèse Go/No Go |
| FR28 | Epic 8 | Guides complets MDB |
| FR29 | Epic 8 | Fiches mémo synthétiques |
| FR30 | Epic 8 | Mémos offline |
| FR31 | Epic 11 | Consultation fiches offline |
| FR32 | Epic 11 | Saisie/modification offline |
| FR33 | Epic 11 | Sync auto au retour réseau |
| FR34 | Epic 11 | Photos offline |
| FR35 | Epic 9 | Récupération données DVF |
| FR36 | Epic 9 | Consultation transactions comparables |
| FR37 | Epic 9 | DVF cache offline |
| FR38 | Epic 12 | Génération lien public |
| FR39 | Epic 12 | Masquage données financières |
| FR40 | Epic 12 | Consultation artisan via lien |
| FR41 | Epic 12 | Soumission devis artisan |
| FR42 | Epic 12 | Consultation associé via compte |
| FR43 | Epic 10 | Saisie paramètres opération |
| FR44 | Epic 10 | Calcul TVA auto |
| FR45 | Epic 10 | Simulation scénarios revente |
| FR46 | Epic 10 | Règles TVA marge vs total |
| FR47 | Epic 10 | Plus-value professionnelle |
| FR48 | Epic 10 | Régimes d'imposition |
| FR49 | Epic 10 | Alertes délais revente |

## Epic List

### Epic 0 : Infrastructure & DevOps
L'environnement de développement et de production est opérationnel : monorepo, Sail, Docker prod, CI, starters initialisés.
**FRs couverts :** Aucun FR direct — AR1, AR2, AR10, AR11

### Epic 1 : Authentification & Gestion de compte
L'utilisateur peut créer un compte, se connecter et gérer son profil. L'architecture multi-utilisateur et RBAC est en place.
**FRs couverts :** FR1, FR2, FR3, FR4

### Epic 2 : Fiches Annonces
L'utilisateur peut créer, consulter, modifier et supprimer des fiches annonces avec toutes les informations d'un bien.
**FRs couverts :** FR5, FR6, FR7, FR8, FR9, FR10

### Epic 3 : Pipeline Kanban
L'utilisateur peut visualiser toutes ses annonces dans un pipeline visuel et suivre la progression de chaque projet.
**FRs couverts :** FR13, FR14, FR15

### Epic 4 : Checklist Pré-visite
L'utilisateur peut préparer ses visites avec une checklist structurée qui se génère automatiquement.
**FRs couverts :** FR16, FR17, FR18

### Epic 5 : Guide de Visite Interactif
L'utilisateur peut parcourir un guide terrain complet, répondre aux questions guidées, prendre des photos et notes — en mode offline.
**FRs couverts :** FR19, FR20, FR21, FR22, FR23

### Epic 6 : Synthèse Post-visite
Le système génère automatiquement une synthèse avec alertes, estimation de marge et verdict Go/No Go.
**FRs couverts :** FR24, FR25, FR26, FR27

### Epic 7 : Score d'Opportunité
Le système calcule un score combinant prix vs marché, urgence de vente et potentiel, aidant au screening rapide.
**FRs couverts :** FR11, FR12

### Epic 8 : Fiches Mémo MDB
L'utilisateur peut consulter des guides éducatifs et fiches mémo synthétiques sur la fiscalité, le juridique et les bonnes pratiques MDB.
**FRs couverts :** FR28, FR29, FR30

### Epic 9 : Intégration DVF
L'utilisateur peut consulter les données de transactions récentes du marché pour évaluer objectivement le prix d'un bien.
**FRs couverts :** FR35, FR36, FR37

### Epic 10 : Simulateur TVA & Guide Fiscalité
L'utilisateur peut simuler la TVA sur marge et consulter les règles fiscales MDB pour maîtriser l'aspect fiscal.
**FRs couverts :** FR43, FR44, FR45, FR46, FR47, FR48, FR49

### Epic 11 : Mode Offline & Sync
L'utilisateur peut consulter, saisir et modifier toutes ses données sans connexion avec synchronisation automatique.
**FRs couverts :** FR31, FR32, FR33, FR34

### Epic 12 : Partage & Collaboration
L'utilisateur peut partager des fiches avec artisans et associés, avec masquage des données sensibles.
**FRs couverts :** FR38, FR39, FR40, FR41, FR42

## Epic 0 : Infrastructure & DevOps

L'environnement de développement et de production est opérationnel : monorepo, Sail, Docker prod, CI, starters initialisés.

### Story 0.1 : Initialisation du monorepo et des projets starter

As a développeur,
I want initialiser le monorepo avec le projet Flutter (Very Good CLI) et le projet Laravel 12,
So that l'environnement de développement est prêt pour l'implémentation des features.

**Acceptance Criteria:**

**Given** un répertoire vide `mdb-copilot/`
**When** le développeur exécute les commandes d'initialisation
**Then** le monorepo contient `mobile-app/` (Flutter VGV) et `backend-api/` (Laravel 12)
**And** `mobile-app/` compile sans erreur avec les flavors dev/staging/production
**And** `backend-api/` répond sur `localhost:4080` via Sail
**And** le fichier `CLAUDE.md` est présent à la racine avec les conventions IA

### Story 0.2 : Configuration Docker production et déploiement

As a développeur,
I want configurer le Dockerfile FrankenPHP, docker-compose.prod.yml et deploy.sh,
So that le backend peut être déployé automatiquement sur le serveur OVH.

**Acceptance Criteria:**

**Given** le projet `backend-api/` initialisé
**When** le développeur exécute `deploy.sh`
**Then** l'image Docker est construite avec FrankenPHP + Octane
**And** l'image est pushée vers `docker-registry.miweb.fr/mdb-copilot-api`
**And** `docker-compose.prod.yml` configure app + MySQL + queue + scheduler
**And** le réseau Docker `docker_internal` est utilisé

### Story 0.3 : Configuration qualité locale dans PHPStorm

As a développeur,
I want configurer PHPStorm pour exécuter automatiquement les outils de qualité de code (lint, analyse statique, tests),
So that la qualité du code est garantie localement sans dépendre d'un pipeline CI/CD distant.

**Acceptance Criteria:**

**Given** PHPStorm ouvert sur le projet `backend-api/`
**When** le développeur sauvegarde un fichier PHP ou exécute l'inspection
**Then** PHPStan (niveau max) est configuré comme inspection externe dans PHPStorm
**And** Laravel Pint est configuré comme formateur de code (File Watcher ou on-save)
**And** PHPUnit est configuré comme framework de test avec l'interpréteur Sail (Docker)

**Given** PHPStorm ouvert sur le projet `mobile-app/`
**When** le développeur travaille sur le code Flutter
**Then** `very_good analyze` est configuré comme inspection externe
**And** `very_good test` est exécutable depuis la configuration Run/Debug
**And** le Dart SDK est correctement référencé

**Given** les outils de qualité configurés
**When** le développeur lance une vérification complète (via un Run Configuration dédiée)
**Then** PHPStan, Pint, PHPUnit (backend) et very_good analyze, very_good test (frontend) s'exécutent
**And** les résultats sont affichés dans le panneau d'inspection PHPStorm
**And** les erreurs sont navigables directement vers le code source

## Epic 1 : Authentification & Gestion de compte

L'utilisateur peut créer un compte, se connecter et gérer son profil. L'architecture multi-utilisateur et RBAC est en place.

### Story 1.1 : Inscription et connexion utilisateur

As a utilisateur,
I want créer un compte avec email/mot de passe et me connecter,
So that j'accède à mon espace personnel MDB Copilot.

**Acceptance Criteria:**

**Given** un utilisateur non inscrit
**When** il soumet le formulaire d'inscription (nom, email, mot de passe)
**Then** un compte est créé avec mot de passe hashé (bcrypt)
**And** un token Sanctum est généré avec ability `owner`
**And** l'utilisateur est redirigé vers l'écran d'accueil

**Given** un utilisateur inscrit
**When** il soumet ses identifiants sur l'écran de connexion
**Then** un token Sanctum est retourné et stocké via `flutter_secure_storage`
**And** les requêtes API incluent le token Bearer

**Given** un utilisateur connecté
**When** il choisit de se déconnecter
**Then** le token Sanctum est révoqué côté serveur
**And** le stockage local du token est effacé

### Story 1.2 : Gestion du profil utilisateur

As a utilisateur,
I want modifier mon nom, email et mot de passe,
So that mes informations personnelles restent à jour.

**Acceptance Criteria:**

**Given** un utilisateur connecté
**When** il modifie son nom ou email dans l'écran profil
**Then** les modifications sont enregistrées côté serveur
**And** l'UI reflète les changements immédiatement

**Given** un utilisateur connecté
**When** il modifie son mot de passe (ancien + nouveau + confirmation)
**Then** le mot de passe est mis à jour si l'ancien est correct
**And** une erreur s'affiche si l'ancien mot de passe est incorrect
**And** une erreur s'affiche si nouveau et confirmation ne correspondent pas

### Story 1.3 : Invitation d'utilisateurs avec rôle

As a propriétaire,
I want inviter des utilisateurs avec un rôle (consultation ou étendu),
So that je peux collaborer avec des partenaires tout en contrôlant leur accès.

**Acceptance Criteria:**

**Given** un utilisateur owner
**When** il invite un email avec le rôle `guest-read` ou `guest-extended`
**Then** un email d'invitation est envoyé
**And** l'invité peut créer un compte avec le rôle assigné
**And** le token Sanctum de l'invité porte les abilities correspondantes

**Given** un utilisateur `guest-read`
**When** il accède à l'application
**Then** il peut consulter les fiches et le pipeline
**And** il ne peut pas modifier, créer ou supprimer de données

**Given** un utilisateur `guest-extended`
**When** il accède à l'application
**Then** il peut consulter et modifier les fiches selon les permissions étendues
**And** il ne peut pas inviter d'autres utilisateurs ni modifier les paramètres du compte owner

## Epic 2 : Fiches Annonces

L'utilisateur peut créer, consulter, modifier et supprimer des fiches annonces avec toutes les informations d'un bien.

### Story 2.1 : Création d'une fiche annonce

As a utilisateur,
I want créer une fiche annonce avec les informations du bien et de l'agent,
So that je centralise toutes les données d'une opportunité immobilière.

**Acceptance Criteria:**

**Given** un utilisateur connecté
**When** il remplit le formulaire de création (adresse, surface, prix, type de bien)
**Then** une fiche annonce est créée avec un UUID v4
**And** la fiche est stockée localement via Drift et synchronisée au serveur

**Given** le formulaire de création
**When** l'utilisateur renseigne les informations agent (nom, agence, téléphone)
**Then** ces informations sont enregistrées dans la fiche
**And** les champs agent sont optionnels

**Given** le formulaire de création
**When** l'utilisateur sélectionne un niveau d'urgence de vente (faible, moyen, élevé)
**Then** l'urgence est enregistrée dans la fiche
**And** le champ urgence est optionnel avec valeur par défaut "non renseigné"

**Given** le formulaire de création
**When** l'utilisateur ajoute des notes libres
**Then** les notes sont enregistrées en texte libre dans la fiche

### Story 2.2 : Consultation et liste des fiches annonces

As a utilisateur,
I want consulter la liste de toutes mes fiches et voir le détail de chacune,
So that j'ai une vue d'ensemble de mes opportunités.

**Acceptance Criteria:**

**Given** un utilisateur connecté avec des fiches existantes
**When** il accède à l'écran liste des fiches
**Then** toutes ses fiches sont affichées avec adresse, prix, type de bien et urgence
**And** la liste est triée par date de création (plus récente en premier)

**Given** la liste des fiches
**When** l'utilisateur tapote sur une fiche
**Then** l'écran détail affiche toutes les informations : bien, agent, urgence, notes

### Story 2.3 : Modification et suppression d'une fiche annonce

As a utilisateur,
I want modifier ou supprimer une fiche annonce,
So that mes données restent à jour et je peux nettoyer mon portfolio.

**Acceptance Criteria:**

**Given** l'écran détail d'une fiche
**When** l'utilisateur modifie un champ et sauvegarde
**Then** les modifications sont enregistrées localement et synchronisées
**And** le champ `updated_at` est mis à jour

**Given** l'écran détail d'une fiche
**When** l'utilisateur choisit de supprimer la fiche
**Then** une confirmation est demandée
**And** si confirmé, la fiche est soft-deleted (marquée `deleted_at`)
**And** la fiche disparaît de la liste

## Epic 3 : Pipeline Kanban

L'utilisateur peut visualiser toutes ses annonces dans un pipeline visuel et suivre la progression de chaque projet.

### Story 3.1 : Visualisation du pipeline Kanban

As a utilisateur,
I want visualiser toutes mes annonces dans un pipeline Kanban avec les étapes de mon workflow MDB,
So that j'ai une vue d'ensemble de la progression de chaque projet.

**Acceptance Criteria:**

**Given** un utilisateur connecté avec des fiches annonces
**When** il accède à l'écran Pipeline
**Then** un Kanban s'affiche avec les colonnes : Prospection, RDV, Visite, Analyse, Offre, Acheté, Travaux, Vente, Vendu
**And** chaque fiche apparaît dans la colonne correspondant à son statut
**And** chaque carte affiche adresse, prix et urgence

### Story 3.2 : Déplacement des annonces dans le pipeline

As a utilisateur,
I want déplacer une annonce d'une étape à l'autre par drag & drop ou action,
So that je mets à jour la progression de mes projets.

**Acceptance Criteria:**

**Given** une fiche dans la colonne "Prospection"
**When** l'utilisateur la déplace vers "RDV" (drag & drop ou menu action)
**Then** le statut de la fiche est mis à jour
**And** la fiche apparaît dans la nouvelle colonne
**And** la modification est synchronisée au serveur

**Given** un déplacement de fiche
**When** le statut passe à "RDV"
**Then** l'événement est enregistré pour déclencher la checklist pré-visite (Epic 4)

### Story 3.3 : Filtres et tri du pipeline

As a utilisateur,
I want filtrer et trier mes annonces dans le pipeline,
So that je retrouve rapidement les projets qui m'intéressent.

**Acceptance Criteria:**

**Given** le pipeline Kanban affiché
**When** l'utilisateur applique un filtre par type de bien
**Then** seules les fiches correspondantes sont affichées

**Given** le pipeline Kanban affiché
**When** l'utilisateur applique un tri (prix croissant/décroissant, date, urgence)
**Then** les cartes dans chaque colonne sont réordonnées

**Given** des filtres actifs
**When** l'utilisateur réinitialise les filtres
**Then** toutes les fiches sont à nouveau visibles

## Epic 4 : Checklist Pré-visite

L'utilisateur peut préparer ses visites avec une checklist structurée qui se génère automatiquement.

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

## Epic 5 : Guide de Visite Interactif

L'utilisateur peut parcourir un guide terrain complet, répondre aux questions guidées, prendre des photos et notes — en mode offline.

### Story 5.1 : Parcours du guide de visite par catégorie

As a utilisateur,
I want parcourir un guide de visite organisé par catégorie et répondre aux questions guidées,
So that j'inspecte méthodiquement chaque aspect du bien sans rien oublier.

**Acceptance Criteria:**

**Given** une fiche au statut "Visite" ou supérieur
**When** l'utilisateur ouvre le guide de visite
**Then** les catégories s'affichent : structure, électricité, plomberie, toiture, isolation, division possible, extérieurs, environnement
**And** chaque catégorie contient des questions guidées spécifiques

**Given** une catégorie du guide
**When** l'utilisateur répond aux questions (choix multiples, oui/non, texte libre)
**Then** les réponses sont enregistrées localement via Drift
**And** la progression par catégorie est affichée (X/Y questions répondues)

**Given** le guide de visite
**When** l'appareil est hors connexion
**Then** le guide fonctionne intégralement en mode offline
**And** toutes les réponses sont stockées localement

### Story 5.2 : Photos contextualisées et notes agent

As a utilisateur,
I want prendre des photos liées à un point du guide et saisir des notes d'échanges avec l'agent,
So that je documente visuellement les constats et conserve les informations verbales.

**Acceptance Criteria:**

**Given** une question du guide de visite
**When** l'utilisateur prend une photo
**Then** la photo est liée à la question/catégorie spécifique
**And** la photo est compressée et stockée localement
**And** la photo est uploadée au serveur quand le réseau est disponible

**Given** le guide de visite
**When** l'utilisateur accède à la section "Notes agent"
**Then** il peut saisir du texte libre sur les échanges avec l'agent immobilier
**And** les notes sont horodatées et liées à la visite

**Given** des photos et notes prises en mode offline
**When** le réseau revient
**Then** les photos sont uploadées et les notes synchronisées automatiquement

## Epic 6 : Synthèse Post-visite

Le système génère automatiquement une synthèse avec alertes, estimation de marge et verdict Go/No Go.

### Story 6.1 : Génération automatique de la synthèse post-visite

As a utilisateur,
I want que le système génère une synthèse complète basée sur mes réponses du guide de visite,
So that j'ai un récapitulatif structuré sans effort de rédaction.

**Acceptance Criteria:**

**Given** un guide de visite avec des réponses complétées
**When** l'utilisateur demande la synthèse post-visite
**Then** le système génère une synthèse récapitulant les constats par catégorie
**And** la synthèse est générée côté client (logique embarquée)
**And** la synthèse est stockée et liée à la fiche annonce

### Story 6.2 : Alertes et estimation de marge

As a utilisateur,
I want voir les alertes sur les points critiques et une estimation de marge prévisionnelle,
So that je prends une décision Go/No Go éclairée.

**Acceptance Criteria:**

**Given** une synthèse post-visite générée
**When** l'utilisateur consulte la synthèse
**Then** les alertes rouges sont affichées en priorité (problèmes structurels, amiante, électricité vétuste, etc.)
**And** le nombre d'alertes par sévérité est résumé (critique, attention, info)

**Given** une synthèse avec les données financières de la fiche
**When** le système calcule la marge prévisionnelle
**Then** une estimation est affichée : prix achat + travaux estimés vs prix de revente estimé
**And** la marge est affichée en euros et en pourcentage

**Given** la synthèse complète (alertes + marge)
**When** l'utilisateur consulte le verdict
**Then** un indicateur visuel Go/No Go est affiché basé sur les alertes et la marge
**And** l'utilisateur peut marquer sa décision (Go, No Go, À approfondir)

## Epic 7 : Score d'Opportunité

Le système calcule un score combinant prix vs marché, urgence de vente et potentiel, aidant au screening rapide.

### Story 7.1 : Calcul et affichage du score d'opportunité

As a utilisateur,
I want que le système calcule un score d'opportunité pour chaque annonce,
So that je priorise rapidement les meilleures opportunités.

**Acceptance Criteria:**

**Given** une fiche annonce avec prix, localisation et urgence renseignés
**When** le système calcule le score d'opportunité
**Then** un score est généré combinant : écart prix vs marché (DVF si disponible), urgence de vente, potentiel estimé
**And** le score est affiché avec un code couleur (vert/orange/rouge)
**And** si les données DVF ne sont pas disponibles, le score est calculé sans cette composante avec une mention "données marché non disponibles"

**Given** l'écran détail d'une fiche
**When** l'utilisateur consulte le score
**Then** les composantes du score sont détaillées : contribution prix/marché, contribution urgence, contribution potentiel
**And** chaque composante est expliquée clairement

## Epic 8 : Fiches Mémo MDB

L'utilisateur peut consulter des guides éducatifs et fiches mémo synthétiques sur la fiscalité, le juridique et les bonnes pratiques MDB.

### Story 8.1 : Consultation des guides et fiches mémo

As a utilisateur débutant MDB,
I want consulter des guides complets et des fiches mémo synthétiques sur les sujets MDB,
So that je me forme progressivement et évite les erreurs coûteuses.

**Acceptance Criteria:**

**Given** un utilisateur connecté
**When** il accède à la section "Mémos MDB"
**Then** une liste de guides complets est affichée organisée par thème (fiscalité, juridique, bonnes pratiques, financement)
**And** chaque guide contient un contenu éducatif structuré

**Given** la section Mémos
**When** l'utilisateur consulte les fiches mémo synthétiques
**Then** des fiches condensées (1-2 écrans max) résument les points essentiels de chaque sujet
**And** les fiches sont consultables rapidement comme aide-mémoire

**Given** les guides et fiches mémo
**When** l'appareil est hors connexion
**Then** tout le contenu éducatif est consultable en mode offline
**And** le contenu est pré-chargé lors de la première synchronisation

## Epic 9 : Intégration DVF

L'utilisateur peut consulter les données de transactions récentes du marché pour évaluer objectivement le prix d'un bien.

### Story 9.1 : Récupération et affichage des données DVF

As a utilisateur,
I want consulter les transactions immobilières récentes autour d'une annonce,
So that j'évalue objectivement si le prix demandé est cohérent avec le marché.

**Acceptance Criteria:**

**Given** une fiche annonce avec une adresse renseignée
**When** l'utilisateur demande les données DVF
**Then** le système interroge l'API DVF via le proxy Laravel
**And** les transactions récentes dans un rayon pertinent sont affichées
**And** les données incluent : adresse, surface, prix, date de transaction, type de bien

**Given** les données DVF affichées
**When** l'utilisateur les consulte
**Then** un comparatif prix/m² est affiché entre l'annonce et les transactions récentes
**And** une indication visuelle montre si le prix est au-dessus, dans la moyenne ou en dessous du marché

### Story 9.2 : Cache DVF et consultation offline

As a utilisateur,
I want consulter les données DVF déjà téléchargées même sans connexion,
So that j'ai accès aux données marché lors de mes visites terrain.

**Acceptance Criteria:**

**Given** des données DVF téléchargées pour une fiche
**When** l'appareil passe hors connexion
**Then** les données DVF en cache restent consultables

**Given** une requête DVF
**When** le cache contient des données récentes (< 24h)
**Then** le cache est utilisé sans nouvelle requête réseau
**And** la date de dernière mise à jour est affichée

**Given** une requête DVF
**When** l'API DVF est indisponible
**Then** un message informe l'utilisateur
**And** les données en cache (même anciennes) restent consultables avec mention de la date

## Epic 10 : Simulateur TVA & Guide Fiscalité

L'utilisateur peut simuler la TVA sur marge et consulter les règles fiscales MDB pour maîtriser l'aspect fiscal.

### Story 10.1 : Simulateur TVA sur marge

As a utilisateur,
I want saisir les paramètres d'une opération et simuler la TVA sur marge,
So that je maîtrise l'impact fiscal avant de faire une offre.

**Acceptance Criteria:**

**Given** l'écran simulateur TVA
**When** l'utilisateur saisit : prix d'achat, montant travaux, frais (notaire, agence)
**Then** le système calcule automatiquement la base TVA et la TVA due à la revente
**And** le calcul distingue TVA sur marge vs TVA sur total

**Given** les paramètres saisis
**When** l'utilisateur modifie le prix de revente
**Then** le calcul se met à jour en temps réel
**And** la marge nette après TVA est affichée

**Given** le simulateur
**When** l'utilisateur teste différents scénarios de prix de revente
**Then** il peut comparer les résultats côte à côte ou en séquence
**And** chaque scénario affiche : prix revente, TVA due, marge nette

### Story 10.2 : Guide fiscalité MDB

As a utilisateur débutant MDB,
I want consulter les règles fiscales applicables aux marchands de biens,
So that je comprends les implications fiscales de mes opérations.

**Acceptance Criteria:**

**Given** l'écran Guide Fiscalité
**When** l'utilisateur consulte les règles TVA
**Then** les règles TVA sur marge et TVA sur total sont expliquées clairement
**And** des exemples chiffrés illustrent chaque cas

**Given** l'écran Guide Fiscalité
**When** l'utilisateur consulte la section plus-value professionnelle
**Then** les règles de calcul et d'imposition sont détaillées
**And** les différents régimes d'imposition applicables sont listés avec leurs conditions

**Given** une fiche annonce avec une date d'achat
**When** le système vérifie les délais de revente
**Then** une alerte est affichée si un délai fiscal approche (ex: délai de revente pour exonération)
**And** l'alerte précise le délai restant et les conséquences fiscales

## Epic 11 : Mode Offline & Sync

L'utilisateur peut consulter, saisir et modifier toutes ses données sans connexion avec synchronisation automatique.

### Story 11.1 : Consultation et saisie offline

As a utilisateur sur le terrain,
I want consulter et modifier mes fiches annonces sans connexion internet,
So that je travaille efficacement même dans des zones sans réseau.

**Acceptance Criteria:**

**Given** un utilisateur avec des fiches synchronisées
**When** l'appareil perd la connexion internet
**Then** toutes les fiches annonces restent consultables depuis Drift
**And** l'utilisateur peut créer de nouvelles fiches
**And** l'utilisateur peut modifier des fiches existantes
**And** les photos stockées localement restent consultables

**Given** des modifications effectuées en mode offline
**When** l'utilisateur crée ou modifie des données
**Then** chaque entité modifiée est marquée `syncStatus: pending`
**And** un indicateur visuel discret montre les données non synchronisées

### Story 11.2 : Synchronisation automatique au retour réseau

As a utilisateur,
I want que mes données se synchronisent automatiquement quand je retrouve le réseau,
So that je n'ai aucune action manuelle à effectuer.

**Acceptance Criteria:**

**Given** des données en attente de synchronisation
**When** la connexion internet revient
**Then** le `SyncEngine` déclenche automatiquement la synchronisation
**And** les données sont envoyées via `POST /api/sync` (delta incrémental via `updated_at`)
**And** les conflits sont résolus en last-write-wins

**Given** une synchronisation en cours
**When** le processus se termine
**Then** les entités synchronisées passent de `syncStatus: pending` à `synced`
**And** les nouvelles données du serveur sont intégrées localement

**Given** un échec de synchronisation (réseau instable)
**When** la requête échoue
**Then** le système retry avec backoff exponentiel
**And** aucune donnée n'est perdue
**And** l'utilisateur est informé discrètement si la sync échoue après plusieurs tentatives

## Epic 12 : Partage & Collaboration

L'utilisateur peut partager des fiches avec artisans et associés, avec masquage des données sensibles.

### Story 12.1 : Génération de lien public pour artisan

As a utilisateur,
I want générer un lien public vers une fiche projet pour un artisan,
So that l'artisan consulte les informations du bien et soumet un devis sans créer de compte.

**Acceptance Criteria:**

**Given** une fiche annonce
**When** l'utilisateur génère un lien de partage public
**Then** un token unique signé est créé avec durée limitée
**And** le lien est copiable et partageable
**And** le lien est révocable à tout moment par l'utilisateur

**Given** un artisan avec le lien de partage
**When** il ouvre le lien
**Then** il voit les informations du bien : photos organisées par zone, description des travaux, contraintes chantier
**And** les données financières du MDB (prix achat, marge, scoring) sont masquées

**Given** la vue artisan
**When** l'artisan soumet une fourchette estimative de devis
**Then** l'estimation est enregistrée et visible par l'utilisateur owner
**And** l'artisan n'a pas accès aux autres fiches ou au pipeline

### Story 12.2 : Consultation associé via compte invité

As a associé potentiel,
I want consulter le pipeline et les fiches via un compte invité,
So that j'évalue l'activité MDB avant de m'engager.

**Acceptance Criteria:**

**Given** un utilisateur invité avec rôle `guest-extended`
**When** il se connecte à l'application
**Then** il voit le pipeline Kanban avec les projets en cours
**And** il peut consulter les fiches annonces (selon les permissions de son rôle)
**And** il ne voit pas les données de négociation sensibles définies par l'owner

**Given** un utilisateur invité avec rôle `guest-read`
**When** il se connecte
**Then** il a un accès en lecture seule au pipeline et aux fiches
**And** il ne peut modifier aucune donnée
