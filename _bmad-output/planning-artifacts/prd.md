---
stepsCompleted: ['step-01-init', 'step-02-discovery', 'step-03-success', 'step-04-journeys', 'step-05-domain', 'step-06-innovation-skipped', 'step-07-project-type', 'step-08-scoping', 'step-09-functional', 'step-10-nonfunctional', 'step-11-polish', 'step-12-complete']
classification:
  projectType: mobile_web_app
  domain: real_estate_mdb_france
  complexity: medium
  projectContext: brownfield_pivot
  techPivot:
    from: Flutter
    to: React Native + React Web
    backendUnchanged: true
inputDocuments:
  - _bmad-output/planning-artifacts/product-brief-mdb-copilot-2026-01-27.md
  - _bmad-output/planning-artifacts/prd-flutter-ABANDONED-2026-02-03.md
  - _bmad-output/planning-artifacts/ux-design-specification.md
  - _bmad-output/planning-artifacts/epics.md
workflowType: 'prd'
documentCounts:
  briefs: 1
  research: 0
  prdReference: 1
  uxDesign: 1
  epics: 1
pivotContext:
  from: Flutter
  to: React Native + React Web
  backendUnchanged: true
  previousPrd: prd-flutter-ABANDONED-2026-02-03.md
---

# Product Requirements Document — MDB Copilot

**Author:** Michael
**Date:** 2026-02-03

## Executive Summary

**MDB Copilot** est une application React Native (iOS, Android) et React Web destinée aux Marchands de Biens débutants en France. Elle accompagne l'utilisateur à chaque étape de son activité d'achat-revente immobilière : prospection, visite, analyse de rentabilité et prise de décision.

**Problème :** Se lancer en tant que Marchand de Bien implique de maîtriser simultanément l'évaluation immobilière, l'estimation de travaux, la fiscalité spécifique (TVA sur marge, plus-value professionnelle), la négociation et le financement. Un débutant navigue sans filet, avec un risque financier réel à chaque décision.

**Solution :** Un assistant structurant qui guide l'utilisateur à travers des checklists, des calculs automatisés et des fiches éducatives, comblant le vide entre connaissances théoriques et pratique opérationnelle.

**Différenciateurs clés :**

| Différenciateur | Avantage |
|-----------------|----------|
| Spécifique MDB France | Workflow adapté (fiscalité, notariat, DVF) |
| Conçu pour débutants | Éducation intégrée, checklists guidées, alertes proactives |
| Terrain-first | Mode offline, guide de visite, capture photos |
| Workflow complet | De la prospection à la revente |
| Copilote anti-erreur | Structure, alerte et éduque pour éviter les erreurs coûteuses |

## Success Criteria

### User Success

| Critère | Indicateur | Cible |
|---------|-----------|-------|
| Adoption complète | Chaque annonce identifiée est saisie dans MDB Copilot | 100% |
| Zéro oubli terrain | Checklist visite complétée intégralement | 100% par visite |
| Confiance décisionnelle | Décision Go/No Go prise via la synthèse post-visite | Utilisation systématique |
| Maîtrise fiscale | Calcul TVA sur marge utilisé avant chaque offre | 100% des offres |
| Zéro erreur coûteuse | Aucune erreur majeure (fiscale, juridique, travaux) sur la 1ère opération | 0 erreur |

**Moment "aha!" :** Première visite terrain avec le guide interactif — remonte en voiture avec une synthèse complète, alertes et estimation de marge, sans avoir oublié un seul point.

### Business Success

| Horizon | Objectif | Mesure |
|---------|----------|--------|
| 3 mois | Première opération MDB rentable réalisée avec l'outil | Marge nette positive |
| 6 mois | Usage en routine sur toutes les opportunités | Nb annonces trackées/mois |
| 12 mois | Activité MDB structurée et rentable | Nb opérations + marge cumulée |

### Technical Success

| Critère | Cible |
|---------|-------|
| Mode offline fiable | Consultation et saisie sans perte de données, sync au retour réseau |
| Sync transparente | Synchronisation automatique sans intervention manuelle |
| Design Material 3 adaptatif | NavBar mobile / NavRail desktop cohérents sur tous devices |
| Multi-utilisateur ready | Architecture prête même si usage solo initial |
| Performance React Native | Temps de démarrage < 2s, navigation < 300ms |

### Measurable Outcomes

- Taux de conversion pipeline : annonce → visite → offre (suivi via Kanban)
- Nombre de fiches mémo consultées par opération
- Ratio visites avec checklist complète / total visites

## Product Scope

### MVP Strategy

**Approche :** Problem-solving — livrer un outil complet couvrant le workflow MDB de bout en bout dès la V1, pour éviter les erreurs coûteuses sur la première opération.

**Ressources :** Développeur solo (Michael), full-stack React Native + React + backend Laravel existant.

### MVP Feature Set (Phase 1) — 14 capabilities

| # | Feature | Justification MVP |
|---|---------|-------------------|
| 1 | Authentification | Pré-requis technique, multi-utilisateur ready |
| 2a | Carnet d'adresses | Centralisation contacts pro — pré-requis fiches annonces |
| 2b | Fiches annonces | Cœur du produit — création manuelle **ou import via lien** (LeBonCoin, SeLoger, PAP, Logic-Immo) avec extraction automatique des données |
| 3 | Score d'opportunité | Screening rapide, évite les visites inutiles |
| 4 | Pipeline Kanban | Vue d'ensemble, suivi progression |
| 5 | Checklist pré-visite | Préparation structurée, zéro oubli |
| 6 | Guide de visite interactif | Usage terrain, moment "aha!" |
| 7 | Synthèse post-visite | Verdict décisionnel, alertes |
| 8 | Fiches mémo MDB | Éducation intégrée, anti-erreur |
| 9 | Mode offline | Indispensable terrain |
| 10 | Intégration DVF | Données marché objectives |
| 11 | Partage fiches | Collaboration artisan/partenaire |
| 12 | Simulateur TVA sur marge | Maîtrise fiscale, anti-erreur |
| 13 | Guide fiscalité MDB | Éducation fiscale, alertes délais |

**Parcours utilisateur supportés :**
- Michael — Happy Path (découverte → analyse → offre)
- Michael — No Go (détection red flags → abandon éclairé)
- Artisan — Consultation fiche + estimation
- Associé — Consultation portfolio

### Growth Features (Phase 2)

- Calculateurs financiers (marge, plus-value pro, calcul inversé)
- Suivi travaux avec alertes dérapage
- Comparateur devis artisans
- Dashboard financier (P&L par projet, trésorerie)
- Intégration comptable (Pennylane, export FEC)
- Générateur dossier bancaire

### Vision (Phase 3)

- Veille marché continue
- Scoring prédictif (apprentissage sur opérations passées)
- Mode présentation investisseur/associé
- Rapport annuel auto-généré
- Collaboration artisan avancée
- Commercialisation : ouverture à d'autres MDB débutants, modèle freemium/abonnement

### Risk Mitigation

**Risques techniques :**
- Mode offline + sync : architecture offline-first dès le départ avec WatermelonDB ou expo-sqlite
- DVF API : proxy serveur Laravel avec cache, fallback gracieux si API indisponible
- Import annonces : scraping via proxy backend, gestion des changements de structure des sites sources
- React Native Web : tester le rendu web tôt, certaines limitations possibles vs natif

**Risques marché :**
- Validation par dogfooding : Michael est le premier utilisateur, feedback immédiat
- Première opération MDB = validation réelle de l'outil

**Risques ressources :**
- Développeur solo : risque de scope creep → s'en tenir strictement aux 14 features
- Si blocage technique : prioriser les features terrain (fiches, guide visite, offline) avant les features bureau (Kanban, DVF, simulateur)

## User Journeys

### Journey 1 : Michael — Découverte et analyse d'une opportunité (Happy Path)

**Opening Scene :** Michael, 39 ans, développeur indépendant, scrolle LeBonCoin un samedi matin. Il repère un appartement T3 à rénover dans un quartier qu'il connaît, affiché à un prix qui semble bas. Son instinct lui dit "opportunité", mais son manque d'expérience MDB lui dit "attention".

**Rising Action :** Il ouvre MDB Copilot et **colle le lien LeBonCoin** — l'app extrait automatiquement les infos (surface, prix, localisation, photos). Il complète avec les coordonnées de l'agent et l'urgence de vente (succession mentionnée). L'intégration DVF lui montre que le prix est 15% en dessous des transactions récentes. Le score d'opportunité passe au vert. **Une fiche mémo "Signaux d'urgence vendeur" apparaît en suggestion contextuelle** — Michael la consulte en 30 secondes et confirme son intuition. Il appelle l'agent, prend RDV, et la fiche passe en statut "RDV" dans le Kanban. La checklist pré-visite se génère automatiquement.

**Climax :** Sur place, Michael ouvre le guide de visite interactif en mode offline. Il parcourt chaque catégorie : structure, électricité, plomberie, division possible. Il répond aux questions guidées, prend des photos contextualisées, note les échanges avec l'agent. De retour dans sa voiture, il ouvre la synthèse post-visite : récap complet, 2 alertes (toiture à vérifier, tableau électrique vétuste), estimation travaux, marge prévisionnelle. Il consulte le simulateur TVA sur marge. Le verdict est clair.

**Resolution :** Michael passe une offre en confiance. Pour la première fois, il n'a rien oublié, ses chiffres sont fiables, et il sait exactement où sont les risques. L'outil est devenu indispensable.

### Journey 2 : Michael — Red flags et décision No Go

**Opening Scene :** Michael a identifié un immeuble de rapport prometteur. Le prix est attractif, la localisation correcte. Il importe l'annonce SeLoger via le lien et lance l'analyse.

**Rising Action :** Le score DVF est neutre — prix dans la moyenne du marché. L'urgence de vente est faible. Michael décide quand même de visiter. Sur place, le guide de visite révèle des problèmes : fissures structurelles, amiante probable, réseau d'évacuation défaillant. Il documente tout avec photos et notes.

**Climax :** La synthèse post-visite affiche 5 alertes rouges. **Un lien vers la fiche mémo "Red flags structurels" s'affiche automatiquement** — Michael comprend pourquoi ces signaux sont critiques. L'estimation travaux explose le budget. Le simulateur TVA sur marge confirme que même avec une revente au prix fort, la marge serait négative. **Le guide fiscalité lui rappelle les délais de revente** à respecter.

**Resolution :** Michael classe le projet en "No Go" dans le Kanban. Sans l'outil, il aurait pu sous-estimer les travaux et faire une offre désastreuse. L'erreur évitée vaut plus que l'outil lui-même.

### Journey 3 : Artisan partenaire — Collaboration professionnelle

**Opening Scene :** Karim, plombier-chauffagiste indépendant, jongle entre 15 demandes de devis par semaine. La plupart arrivent par SMS avec des infos incomplètes — "faut refaire la salle de bain, tu passes quand ?". Il perd du temps à rappeler pour avoir les détails.

**Rising Action :** Karim reçoit un lien de Michael vers une fiche projet dans MDB Copilot. Il ouvre le lien — **pas de compte à créer, accès immédiat**. Il découvre une fiche structurée : photos organisées par zone (cuisine, salle de bain, WC), description claire des travaux (état actuel → état souhaité), contraintes chantier (accès, stationnement), niveau de finition attendu. **Tout ce dont il a besoin est là, sans avoir à poser 10 questions.**

**Climax :** Karim prépare son estimation en 15 minutes au lieu d'une heure. Il soumet sa fourchette directement via l'app avec ses commentaires. **Il sauvegarde le lien dans ses favoris** — c'est le genre de client organisé avec qui il aime travailler.

**Resolution :** Michael reçoit l'estimation et l'intègre dans son analyse. Karim reçoit une notification quand Michael accepte son devis. **La collaboration est fluide, professionnelle, et Karim recommande MDB Copilot à ses clients investisseurs.**

### Journey 4 : Associé potentiel — Consultation portfolio

**Opening Scene :** Sophie, ancienne collègue de Michael, s'intéresse à l'activité MDB. Michael lui propose de consulter son portfolio.

**Rising Action :** Sophie se connecte avec un compte invité étendu. Elle voit le pipeline Kanban avec les projets en cours, les fiches annonces (sans données sensibles de négociation), et l'historique des opérations.

**Climax :** Sophie comprend la méthode de travail, le volume d'activité, et la rigueur de l'approche. **Elle consulte les fiches mémo pour comprendre le métier MDB** — ça la rassure sur la solidité de l'approche. La transparence de l'outil lui donne confiance.

**Resolution :** Elle décide de s'associer sur une opération. Le partage d'information structuré a permis une prise de décision éclairée.

### Journey 5 : Michael — Première utilisation (Onboarding)

**Opening Scene :** Michael vient d'installer MDB Copilot. Il a lu des articles sur l'activité MDB mais n'a jamais utilisé d'outil dédié. Il se demande par où commencer.

**Rising Action :** L'app l'accueille avec un écran simple : "Bienvenue Michael ! Commençons par créer votre première fiche annonce." **Trois options** : coller un lien d'annonce, saisir manuellement, ou explorer l'app d'abord. Michael choisit d'explorer. **Un tour guidé de 5 écrans** lui montre le pipeline Kanban, le guide de visite, et les fiches mémo. Il comprend le workflow en 2 minutes.

**Climax :** Michael revient à l'accueil et colle un lien LeBonCoin qu'il avait repéré. L'extraction fonctionne, la fiche se crée. **Il voit immédiatement la valeur** : "Ah, c'est beaucoup plus rapide que mon tableur Excel !"

**Resolution :** Michael est autonome. Il sait où trouver chaque fonction et comprend comment l'outil va l'accompagner. **Le moment "aha!" d'onboarding : "Enfin un outil fait pour mon activité."**

### Journey 6 : Michael — Import dégradé (extraction partielle)

**Opening Scene :** Michael trouve une annonce sur un site moins courant (PAP, particulier). Il colle le lien dans MDB Copilot.

**Rising Action :** L'app affiche : **"On a trouvé des infos ! Aide-nous à compléter."** L'extraction a récupéré l'adresse et le prix, mais pas la surface ni les photos. **Le formulaire est pré-rempli partiellement** avec les données extraites. Michael complète manuellement la surface (mentionnée dans le texte de l'annonce) et upload les photos depuis sa galerie.

**Climax :** En 2 minutes, la fiche est complète. **Michael ne se sent pas frustré** — l'app a fait le maximum et lui a facilité la complétion. Le score d'opportunité se calcule normalement.

**Resolution :** Michael apprend que l'import fonctionne mieux sur LeBonCoin/SeLoger, mais que l'app reste utile même pour les autres sources. **La confiance dans l'outil est préservée** grâce à la récupération gracieuse.

### Journey → Capabilities Mapping

| Journey | Capabilities révélées |
|---------|----------------------|
| Michael — Happy Path | Import via lien, fiche annonce, DVF, score, Kanban, checklist, guide visite offline, synthèse, simulateur TVA, **fiches mémo contextuelles** |
| Michael — No Go | Alertes rouges, estimation travaux, guide fiscalité, classement Kanban, **liens mémo automatiques sur red flags** |
| Artisan — Collaboration | Partage lien public, vue consultation, photos par zone, soumission devis, **notification acceptation**, **accès sans compte** |
| Associé — Portfolio | Compte invité étendu, vue Kanban, fiches filtrées, **accès mémos éducatifs** |
| Michael — Onboarding | **Tour guidé, options de démarrage, valeur immédiate** |
| Michael — Import dégradé | **Extraction partielle, formulaire pré-rempli, récupération gracieuse** |

## Domain-Specific Requirements

### Compliance & Réglementaire

| Exigence | Description |
|----------|-------------|
| **RGPD** | Données personnelles des contacts (agents, artisans) — consentement, droit à l'effacement, chiffrement |
| **Fiscalité MDB** | TVA sur marge vs TVA sur total, délais de revente (2 ans régime MDB), plus-value professionnelle |
| **DVF (data.gouv.fr)** | API publique, données ouvertes — pas de contrainte d'usage, mais cache nécessaire pour fiabilité |

### Contraintes Techniques

| Contrainte | Exigence |
|------------|----------|
| **Mode offline** | Indispensable — visites en cave, parking souterrain, zone blanche |
| **Scraping annonces** | Sites sources (LeBonCoin, SeLoger) peuvent changer leur structure — prévoir fallback gracieux |
| **Photos** | Compression avant upload, stockage sécurisé, cache local pour offline |
| **Sync** | Last-write-wins suffisant pour usage solo, delta incrémental via `updated_at` |

### Intégrations Requises

| Intégration | Priorité | Notes |
|-------------|----------|-------|
| **DVF API** | MVP | Proxy backend Laravel, cache 24h, fallback si indisponible |
| **Scraping annonces** | MVP | Backend proxy, extraction HTML, gestion erreurs |
| **Stockage photos** | MVP | Upload serveur, cache local |
| **Pennylane / FEC** | Phase 2 | Export comptable futur |

### Risques Domaine & Mitigations

| Risque | Mitigation |
|--------|------------|
| **Scraping cassé** | Fallback vers saisie manuelle avec formulaire pré-rempli partiellement (Journey 6) |
| **DVF indisponible** | Cache local + message "données marché non disponibles" — score calculé sans DVF |
| **Erreur calcul fiscal** | Disclaimer légal "outil d'aide, non conseil fiscal" + validation formules par expert-comptable |
| **Perte données offline** | Sauvegarde continue, pas de bouton "Sauvegarder" |

## Technical Requirements

### Platform & Architecture

| Aspect | Décision |
|--------|----------|
| **Framework mobile** | React Native (cross-platform iOS + Android) |
| **Framework web** | React (SPA) |
| **Partage de code** | Maximum de composants partagés entre mobile et web |
| **Architecture** | Offline-first, sync au retour réseau |
| **SEO** | Non requis (app privée, authentification requise) |
| **Real-time** | Non requis (sync périodique suffit) |
| **App Store** | Publication iOS App Store + Google Play prévue |

### Responsive Design

| Device | Taille min | Priorité |
|--------|-----------|----------|
| iPhone (SE+) | 375px | **Haute** — usage terrain principal |
| Android Phone | 360px | **Haute** — alternative terrain |
| iPad / Tablet | 768px | Moyenne — analyse au bureau |
| Desktop Web | 1024px | Moyenne — analyse au bureau |

### Design Language

- **Material Design 3** (Material You) — dernières guidelines 2025/2026
- **Navigation adaptative** :
  - Mobile (< 600dp) : Bottom Navigation Bar
  - Tablet/Desktop (≥ 600dp) : Navigation Rail latérale
- **Palette couleurs** : Violet/Magenta (light), Indigo/Orchidée (dark)
- **Composants** : MUI (React Web) + React Native Paper (mobile), customisés avec coins arrondis max

### Offline Strategy

| Aspect | Implémentation |
|--------|----------------|
| **Stockage local mobile** | WatermelonDB ou expo-sqlite + SQLCipher (chiffré) |
| **Stockage local web** | IndexedDB via Dexie.js ou similar |
| **Données offline** | Fiches annonces, checklists, guide visite, fiches mémo, photos |
| **Sync** | Delta incrémental via `updated_at`, last-write-wins, `POST /api/sync` |
| **DVF cache** | Cache local des dernières requêtes, consultation offline des données téléchargées |

### Browser Support (Web)

| Navigateur | Support |
|-----------|---------|
| Safari 17+ | Oui |
| Chrome 120+ | Oui |
| Firefox 120+ | Oui |
| Edge 120+ | Oui |

### Device Features (Mobile)

| Feature | Usage |
|---------|-------|
| **Caméra** | Photos contextualisées pendant visite |
| **Stockage** | Cache photos, DB locale |
| **Réseau** | Détection online/offline, sync auto |
| **Notifications push** | Phase 2 — alertes délais fiscaux, rappels |

### Implementation Stack

| Composant | Technologie |
|-----------|-------------|
| **Mobile** | React Native + Expo |
| **Web** | React + Vite |
| **State management** | Zustand ou Redux Toolkit |
| **Navigation** | React Navigation (mobile), React Router (web) |
| **UI Kit** | React Native Paper (mobile), MUI (web) |
| **Offline DB mobile** | WatermelonDB ou expo-sqlite |
| **Offline DB web** | Dexie.js (IndexedDB) |
| **Backend** | Laravel 12 + Sanctum (existant, **inchangé**) |
| **API** | REST JSON |
| **Auth** | Sanctum tokens avec abilities (owner, guest-read, guest-extended) |
| **Hébergement** | Serveur OVH (backend + web), App Store/Play Store (mobile) |

### Backend Architecture Patterns (Laravel)

| Pattern | Description |
|---------|-------------|
| **Policy sur chaque route** | Toutes les routes protégées par une Policy — autorisation explicite |
| **FormRequest systématique** | Chaque appel de controller a son Request associé — validation centralisée |
| **Resources en sortie** | Chaque réponse de controller utilise une Resource — formatage uniforme |
| **Controllers ultra-light** | Aucune logique métier dans les controllers — orchestration uniquement |
| **Actions** | Logique métier unitaire dans des classes Action (single responsibility) |
| **Services** | Logique métier complexe avec maintien d'état, cohérence, appels externes |

**Flux type :**
```
Route → Policy (authz) → Controller → FormRequest (validation)
                              ↓
                         Action/Service (logique métier)
                              ↓
                         Resource (formatage réponse)
```

## Functional Requirements

### Gestion de compte & Authentification

- **FR1 :** L'utilisateur peut créer un compte avec prénom, nom, email et mot de passe
- **FR2 :** L'utilisateur peut se connecter et se déconnecter
- **FR3 :** L'utilisateur peut réinitialiser son mot de passe via email
- **FR4 :** L'utilisateur peut gérer son profil (prénom, nom, email, mot de passe)
- **FR5 :** Le propriétaire peut inviter des utilisateurs avec un rôle (guest-read, guest-extended)
- **FR6 :** L'utilisateur invité accède uniquement aux données autorisées par son rôle

### Onboarding

- **FR7 :** Le nouvel utilisateur voit un écran d'accueil avec options de démarrage (import lien, saisie manuelle, explorer)
- **FR8 :** Le nouvel utilisateur peut suivre un tour guidé présentant les fonctionnalités principales

### Carnet d'Adresses

- **FR9 :** L'utilisateur peut créer un contact professionnel (prénom, nom, entreprise, téléphone, email, type, notes)
- **FR10 :** L'utilisateur peut consulter, modifier et supprimer un contact
- **FR11 :** L'utilisateur peut filtrer les contacts par type (agent immobilier, artisan, notaire, courtier, autre)

### Fiches Annonces

- **FR12 :** L'utilisateur peut créer une fiche annonce par saisie manuelle (adresse, surface, prix, type de bien)
- **FR13 :** L'utilisateur peut créer une fiche annonce par import de lien (LeBonCoin, SeLoger, PAP, Logic-Immo)
- **FR14 :** Le système extrait automatiquement les données disponibles depuis le lien importé
- **FR15 :** Si l'extraction est partielle, le système affiche un formulaire pré-rempli à compléter
- **FR16 :** L'utilisateur peut associer un agent immobilier depuis le carnet d'adresses ou en créer un nouveau inline
- **FR17 :** L'utilisateur peut indiquer le niveau d'urgence de vente (faible, moyen, élevé, non renseigné)
- **FR18 :** L'utilisateur peut ajouter des notes libres à une fiche
- **FR19 :** L'utilisateur peut consulter, modifier et supprimer une fiche annonce
- **FR20 :** L'utilisateur peut consulter la liste de toutes ses fiches annonces

### Score d'opportunité

- **FR21 :** Le système calcule un score d'opportunité combinant prix vs marché (DVF), urgence de vente et potentiel
- **FR22 :** L'utilisateur peut consulter le détail du score et ses composantes
- **FR23 :** Si les données DVF ne sont pas disponibles, le score est calculé sans cette composante avec mention

### Pipeline Kanban

- **FR24 :** L'utilisateur peut visualiser toutes ses annonces dans un pipeline Kanban
- **FR25 :** L'utilisateur peut déplacer une annonce entre les étapes (Prospection → RDV → Visite → Analyse → Offre → Acheté → Travaux → Vente → Vendu → No Go)
- **FR26 :** L'utilisateur peut filtrer et trier les annonces dans le pipeline

### Checklist Pré-visite

- **FR27 :** Le système génère automatiquement une checklist lors du passage au statut "RDV"
- **FR28 :** L'utilisateur peut consulter la checklist (questions à poser, documents à demander, points à vérifier)
- **FR29 :** L'utilisateur peut cocher les éléments de la checklist

### Guide de Visite Interactif

- **FR30 :** L'utilisateur peut parcourir un guide de visite organisé par catégorie (structure, électricité, plomberie, division, etc.)
- **FR31 :** L'utilisateur peut répondre aux questions guidées pour chaque catégorie
- **FR32 :** L'utilisateur peut prendre des photos contextualisées liées à un point du guide
- **FR33 :** L'utilisateur peut saisir des notes sur les échanges avec l'agent
- **FR34 :** Le guide de visite fonctionne intégralement en mode offline

### Synthèse Post-visite

- **FR35 :** Le système génère automatiquement une synthèse basée sur les réponses du guide
- **FR36 :** La synthèse affiche des alertes sur les points critiques détectés (red flags)
- **FR37 :** La synthèse inclut une estimation de marge prévisionnelle
- **FR38 :** La synthèse propose des liens contextuels vers les fiches mémo pertinentes
- **FR39 :** L'utilisateur peut marquer sa décision (Go, No Go, À approfondir)

### Fiches Mémo MDB

- **FR40 :** L'utilisateur peut consulter des guides complets sur les sujets MDB (fiscalité, juridique, bonnes pratiques)
- **FR41 :** L'utilisateur peut consulter des fiches mémo synthétiques pour chaque sujet
- **FR42 :** Les fiches mémo sont consultables en mode offline
- **FR43 :** Le système suggère des fiches mémo contextuelles selon l'action en cours

### Mode Offline & Sync

- **FR44 :** L'utilisateur peut consulter ses fiches annonces sans connexion
- **FR45 :** L'utilisateur peut créer et modifier des données sans connexion
- **FR46 :** Le système synchronise automatiquement les données au retour du réseau
- **FR47 :** L'utilisateur peut consulter les photos stockées localement sans connexion

### Intégration DVF

- **FR48 :** Le système récupère les données de transactions récentes DVF pour une localisation donnée
- **FR49 :** L'utilisateur peut consulter les prix de transactions comparables autour d'une annonce
- **FR50 :** Les données DVF téléchargées sont consultables en mode offline

### Partage & Collaboration

- **FR51 :** L'utilisateur peut générer un lien public de consultation vers une fiche projet
- **FR52 :** Le lien public masque les données financières sensibles du MDB
- **FR53 :** L'artisan peut consulter les informations du bien via le lien partagé (photos, travaux, contraintes)
- **FR54 :** L'artisan peut soumettre une fourchette estimative de devis via le lien partagé
- **FR55 :** Le propriétaire reçoit une notification quand un artisan soumet une estimation
- **FR56 :** L'associé invité peut consulter le pipeline et les fiches via son compte

### Simulateur TVA sur Marge

- **FR57 :** L'utilisateur peut saisir les paramètres d'une opération (prix achat, travaux, frais)
- **FR58 :** Le système calcule automatiquement la base TVA et la TVA due à la revente
- **FR59 :** L'utilisateur peut simuler différents scénarios de prix de revente

### Guide Fiscalité MDB

- **FR60 :** L'utilisateur peut consulter les règles TVA sur marge vs TVA sur total
- **FR61 :** L'utilisateur peut consulter les règles de plus-value professionnelle
- **FR62 :** L'utilisateur peut consulter les différents régimes d'imposition applicables
- **FR63 :** Le système affiche des alertes sur les délais de revente fiscaux

## Non-Functional Requirements

### Performance

| NFR ID | Exigence | Mesure |
|--------|----------|--------|
| **NFR-P1** | Temps de démarrage app mobile < 2 secondes | Cold start mesuré sur device mid-range |
| **NFR-P2** | Navigation entre écrans < 300ms | Transition mesurée sur 95e percentile |
| **NFR-P3** | Temps de réponse API < 500ms | 95e percentile sous charge normale |
| **NFR-P4** | Sync delta complète < 5 secondes | Pour 100 fiches modifiées, réseau 4G |
| **NFR-P5** | Chargement liste Kanban < 1 seconde | Jusqu'à 200 fiches, données locales |

### Sécurité

| NFR ID | Exigence | Mesure |
|--------|----------|--------|
| **NFR-S1** | Données locales chiffrées (SQLCipher) | Audit du stockage local |
| **NFR-S2** | Tokens Sanctum avec expiration 7 jours | Configuration vérifiable |
| **NFR-S3** | HTTPS obligatoire pour toutes les API | Certificat SSL/TLS valide |
| **NFR-S4** | Pas de données sensibles dans les logs | Audit code + tests |
| **NFR-S5** | Photos stockées avec accès authentifié | URLs signées ou proxy authentifié |

### Scalabilité

| NFR ID | Exigence | Mesure |
|--------|----------|--------|
| **NFR-SC1** | Support jusqu'à 1000 fiches par utilisateur | Tests de charge locaux |
| **NFR-SC2** | Support jusqu'à 10 utilisateurs actifs simultanés | Tests de charge API (Phase 2) |
| **NFR-SC3** | Photos compressées < 500KB avant upload | Validation côté client |

### Fiabilité

| NFR ID | Exigence | Mesure |
|--------|----------|--------|
| **NFR-R1** | Zéro perte de données en mode offline | Tests de sync après interruption réseau |
| **NFR-R2** | Sauvegarde automatique continue (pas de bouton "Save") | Vérification comportement app |
| **NFR-R3** | Récupération gracieuse si DVF indisponible | Fallback fonctionnel testé |
| **NFR-R4** | Récupération gracieuse si scraping échoue | Formulaire pré-rempli partiel |

### Intégration

| NFR ID | Exigence | Mesure |
|--------|----------|--------|
| **NFR-I1** | DVF API via proxy Laravel avec cache 24h | Logs de cache hit/miss |
| **NFR-I2** | Scraping annonces via backend (pas de client-side) | Architecture vérifiable |
| **NFR-I3** | Compatibilité navigateurs Safari/Chrome/Firefox/Edge 120+ | Tests cross-browser |

### Accessibilité

| NFR ID | Exigence | Mesure |
|--------|----------|--------|
| **NFR-A1** | Contraste texte minimum 4.5:1 (WCAG AA) | Audit palette couleurs |
| **NFR-A2** | Tailles de touch targets minimum 44x44dp | Audit composants UI |
| **NFR-A3** | Support lecteur d'écran (labels accessibles) | Tests VoiceOver/TalkBack |

