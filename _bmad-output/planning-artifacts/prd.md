---
stepsCompleted: ['step-01-init', 'step-02-discovery', 'step-03-success', 'step-04-journeys', 'step-05-domain', 'step-06-innovation', 'step-07-project-type', 'step-08-scoping', 'step-09-functional', 'step-10-nonfunctional', 'step-11-polish', 'step-12-complete']
classification:
  projectType: web_app
  domain: general
  complexity: medium
  projectContext: greenfield
inputDocuments:
  - _bmad-output/planning-artifacts/product-brief-mdb-copilot-2026-01-27.md
  - _bmad-output/brainstorming/brainstorming-session-2026-01-26.md
workflowType: 'prd'
documentCounts:
  briefs: 1
  research: 0
  brainstorming: 1
  projectDocs: 0
---

# Product Requirements Document — MDB Copilot

**Author:** Michael
**Date:** 2026-01-27

## Executive Summary

**MDB Copilot** est une application Flutter multi-plateforme (iOS, Android, Web) destinée aux Marchands de Biens débutants en France. Elle accompagne l'utilisateur à chaque étape de son activité d'achat-revente immobilière : prospection, visite, analyse de rentabilité et prise de décision.

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
| Esthétique iOS 26+ | Rendu Liquid Glass cohérent sur tous devices |
| Multi-utilisateur ready | Architecture prête même si usage solo initial |

### Measurable Outcomes

- Taux de conversion pipeline : annonce → visite → offre (suivi via Kanban)
- Nombre de fiches mémo consultées par opération
- Ratio visites avec checklist complète / total visites

## Product Scope

### MVP Strategy

**Approche :** Problem-solving — livrer un outil complet couvrant le workflow MDB de bout en bout dès la V1, pour éviter les erreurs coûteuses sur la première opération.

**Ressources :** Développeur solo (Michael), full-stack Flutter + backend Dart.

### MVP Feature Set (Phase 1) — 13 capabilities, livrées en bloc

| # | Feature | Justification MVP |
|---|---------|-------------------|
| 1 | Authentification | Pré-requis technique, multi-utilisateur ready |
| 2 | Fiches annonces | Cœur du produit — sans fiche, pas de workflow |
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

### Phase 2 (Growth)

- Calculateurs financiers (marge, plus-value pro, calcul inversé)
- Suivi travaux avec alertes dérapage
- Comparateur devis artisans
- Dashboard financier (P&L par projet, trésorerie)
- Intégration comptable (Pennylane, export FEC)
- Générateur dossier bancaire

### Phase 3 (Expansion)

- Veille marché continue
- Scoring prédictif (apprentissage sur opérations passées)
- Mode présentation investisseur/associé
- Rapport annuel auto-généré
- Collaboration artisan avancée
- Commercialisation : ouverture à d'autres MDB débutants, modèle freemium/abonnement

### Risk Mitigation

**Risques techniques :**
- Mode offline + sync : architecture offline-first dès le départ, pas en retrofit
- DVF API : proxy serveur avec cache, fallback gracieux si API indisponible
- Flutter Web : tester le rendu web tôt, certaines limitations possibles vs natif

**Risques marché :**
- Validation par dogfooding : Michael est le premier utilisateur, feedback immédiat
- Première opération MDB = validation réelle de l'outil

**Risques ressources :**
- Développeur solo : risque de scope creep → s'en tenir strictement aux 13 features
- Si blocage technique : prioriser les features terrain (fiches, guide visite, offline) avant les features bureau (Kanban, DVF, simulateur)

## User Journeys

### Journey 1 : Michael — Découverte et analyse d'une opportunité (Happy Path)

**Opening Scene :** Michael, 39 ans, développeur indépendant, scrolle LeBonCoin un samedi matin. Il repère un appartement T3 à rénover dans un quartier qu'il connaît, affiché à un prix qui semble bas. Son instinct lui dit "opportunité", mais son manque d'expérience MDB lui dit "attention".

**Rising Action :** Il ouvre MDB Copilot et crée une fiche annonce. Il saisit les infos clés : surface, prix, localisation, coordonnées de l'agent. L'intégration DVF lui montre immédiatement que le prix est 15% en dessous des transactions récentes du quartier. Il note l'urgence de vente (succession mentionnée dans l'annonce). Le score d'opportunité passe au vert. Il appelle l'agent, prend RDV, et la fiche passe en statut "RDV" dans le Kanban. La checklist pré-visite se génère : questions à poser à l'agent, documents à demander, points à vérifier sur place.

**Climax :** Sur place, Michael ouvre le guide de visite interactif en mode offline. Il parcourt chaque catégorie : structure, électricité, plomberie, division possible. Il répond aux questions guidées, prend des photos contextualisées, note les échanges avec l'agent. De retour dans sa voiture, il ouvre la synthèse post-visite : récap complet, 2 alertes (toiture à vérifier, tableau électrique vétuste), estimation travaux, marge prévisionnelle. Il consulte le simulateur TVA sur marge. Le verdict est clair.

**Resolution :** Michael passe une offre en confiance. Pour la première fois, il n'a rien oublié, ses chiffres sont fiables, et il sait exactement où sont les risques. L'outil est devenu indispensable.

### Journey 2 : Michael — Red flags et décision No Go

**Opening Scene :** Michael a identifié un immeuble de rapport prometteur. Le prix est attractif, la localisation correcte. Il crée la fiche et lance l'analyse.

**Rising Action :** Le score DVF est neutre — prix dans la moyenne du marché. L'urgence de vente est faible. Michael décide quand même de visiter. Sur place, le guide de visite révèle des problèmes : fissures structurelles, amiante probable, réseau d'évacuation défaillant. Il documente tout avec photos et notes.

**Climax :** La synthèse post-visite affiche 5 alertes rouges. L'estimation travaux explose le budget. Le simulateur TVA sur marge confirme que même avec une revente au prix fort, la marge serait négative. Le guide fiscalité lui rappelle les délais de revente à respecter.

**Resolution :** Michael classe le projet en "No Go" dans le Kanban. Sans l'outil, il aurait pu sous-estimer les travaux et faire une offre désastreuse. L'erreur évitée vaut plus que l'outil lui-même.

### Journey 3 : Artisan partenaire — Consultation et estimation

**Opening Scene :** Karim, plombier-chauffagiste, reçoit un lien de Michael vers une fiche projet dans MDB Copilot.

**Rising Action :** Karim ouvre le lien et accède à la fiche en mode consultation. Il voit les photos organisées par zone (cuisine, salle de bain, WC), la description structurée des travaux (état actuel → état souhaité), les plans si disponibles, les contraintes chantier et le niveau de finition attendu. Aucune donnée financière du MDB n'est visible.

**Climax :** Karim a toutes les informations nécessaires sans avoir à rappeler Michael pour poser 10 questions. Il soumet une fourchette estimative directement via l'app.

**Resolution :** Michael reçoit l'estimation et l'intègre dans son analyse de rentabilité. La collaboration est fluide et professionnelle.

### Journey 4 : Associé potentiel — Consultation portfolio

**Opening Scene :** Sophie, ancienne collègue de Michael, s'intéresse à l'activité MDB. Michael lui propose de consulter son portfolio.

**Rising Action :** Sophie se connecte avec un compte invité étendu. Elle voit le pipeline Kanban avec les projets en cours, les fiches annonces (sans données sensibles de négociation), et l'historique des opérations.

**Climax :** Sophie comprend la méthode de travail, le volume d'activité, et la rigueur de l'approche. La transparence de l'outil la rassure.

**Resolution :** Elle décide de s'associer sur une opération. Le partage d'information structuré a permis une prise de décision éclairée.

### Journey → Capabilities Mapping

| Journey | Capabilities révélées |
|---------|----------------------|
| Michael — Happy Path | Fiche annonce, DVF, score d'opportunité, Kanban, checklist pré-visite, guide visite offline, synthèse post-visite, simulateur TVA |
| Michael — No Go | Alertes rouges, estimation travaux, guide fiscalité, classement Kanban, documentation terrain |
| Artisan — Consultation | Partage lien public, vue consultation restreinte, photos par zone, description travaux, soumission devis |
| Associé — Portfolio | Compte invité étendu, vue Kanban, fiches annonces filtrées, historique opérations |

## Technical Requirements

### Platform & Architecture

| Aspect | Décision |
|--------|----------|
| **Framework** | Flutter (Dart) |
| **Plateformes cibles** | iOS, Android, Web |
| **Architecture** | SPA, offline-first |
| **SEO** | Non requis (app privée) |
| **Real-time** | Non requis (sync au retour réseau) |
| **App Store** | Publication iOS App Store + Google Play envisagée |

### Responsive Design

| Device | Taille min | Priorité |
|--------|-----------|----------|
| iPhone (SE+) | 375px | Haute — usage terrain principal |
| iPad | 768px | Moyenne — analyse au bureau |
| Desktop Web | 1024px | Moyenne — analyse au bureau |
| Android Phone | 360px | Haute — alternative terrain |

### Design Language

- **iOS 26+ Liquid Glass** : transparences, flous, typographie SF Pro
- Appliqué uniformément sur tous les devices via le rendu custom Flutter
- Composants Material Design 3 adaptés au style iOS 26+

### Offline Strategy

- **Stockage local** : base de données embarquée (Hive, Isar ou SQLite)
- **Données offline** : fiches annonces, checklists, guide visite, fiches mémo, photos
- **Sync** : automatique au retour réseau, résolution de conflits simple (last-write-wins)
- **DVF** : cache local des dernières requêtes, consultation offline des données déjà téléchargées

### Browser Support (Web)

| Navigateur | Support |
|-----------|---------|
| Safari 17+ | Oui |
| Chrome 120+ | Oui |
| Firefox 120+ | Oui |
| Edge 120+ | Oui |

### Implementation Stack

- **Hébergement** : serveur privé OVH (backend API + web app)
- **Backend** : API REST (Dart Shelf/Serverpod ou alternative légère)
- **Auth** : JWT avec refresh token, multi-utilisateur ready
- **Stockage photos** : upload vers serveur OVH, cache local pour offline
- **DVF** : proxy API côté serveur vers data.gouv.fr

## Functional Requirements

### Gestion de compte & Authentification

- **FR1 :** L'utilisateur peut créer un compte et s'authentifier
- **FR2 :** L'utilisateur peut gérer son profil (nom, email, mot de passe)
- **FR3 :** Le propriétaire peut inviter des utilisateurs avec un rôle (consultation, étendu)
- **FR4 :** L'utilisateur invité peut accéder uniquement aux données autorisées par son rôle

### Fiches Annonces

- **FR5 :** L'utilisateur peut créer une fiche annonce avec saisie manuelle (adresse, surface, prix, type de bien)
- **FR6 :** L'utilisateur peut renseigner les informations de l'agent immobilier (nom, agence, téléphone)
- **FR7 :** L'utilisateur peut indiquer le niveau d'urgence de vente
- **FR8 :** L'utilisateur peut ajouter des notes libres à une fiche annonce
- **FR9 :** L'utilisateur peut modifier et supprimer une fiche annonce
- **FR10 :** L'utilisateur peut consulter la liste de toutes ses fiches annonces

### Score d'opportunité

- **FR11 :** Le système calcule un score d'opportunité combinant prix vs marché (DVF), urgence de vente et potentiel
- **FR12 :** L'utilisateur peut consulter le détail du score et ses composantes

### Pipeline Kanban

- **FR13 :** L'utilisateur peut visualiser toutes ses annonces dans un pipeline Kanban
- **FR14 :** L'utilisateur peut déplacer une annonce entre les étapes (Prospection → RDV → Visite → Analyse → Offre → Acheté → Travaux → Vente → Vendu)
- **FR15 :** L'utilisateur peut filtrer et trier les annonces dans le pipeline

### Checklist Pré-visite

- **FR16 :** L'utilisateur peut consulter une checklist de préparation avant visite (questions à poser, documents à demander, points à vérifier)
- **FR17 :** L'utilisateur peut cocher les éléments de la checklist pré-visite
- **FR18 :** La checklist pré-visite se génère automatiquement lors du passage au statut "RDV"

### Guide de Visite Interactif

- **FR19 :** L'utilisateur peut parcourir un guide de visite organisé par catégorie (structure, électricité, plomberie, division, etc.)
- **FR20 :** L'utilisateur peut répondre à des questions guidées pour chaque catégorie
- **FR21 :** L'utilisateur peut prendre des photos contextualisées liées à un point du guide
- **FR22 :** L'utilisateur peut saisir des notes sur les échanges avec l'agent pendant la visite
- **FR23 :** Le guide de visite est utilisable en mode offline

### Synthèse Post-visite

- **FR24 :** Le système génère automatiquement une synthèse basée sur les réponses du guide de visite
- **FR25 :** La synthèse affiche des alertes sur les points critiques détectés
- **FR26 :** La synthèse inclut une première estimation de marge prévisionnelle
- **FR27 :** L'utilisateur peut consulter la synthèse pour prendre une décision Go/No Go

### Fiches Mémo MDB

- **FR28 :** L'utilisateur peut consulter des guides complets sur les sujets MDB (fiscalité, juridique, bonnes pratiques)
- **FR29 :** L'utilisateur peut consulter des fiches mémo synthétiques pour chaque sujet
- **FR30 :** Les fiches mémo sont consultables en mode offline

### Mode Offline

- **FR31 :** L'utilisateur peut consulter ses fiches annonces sans connexion
- **FR32 :** L'utilisateur peut saisir et modifier des données sans connexion
- **FR33 :** Le système synchronise automatiquement les données au retour du réseau
- **FR34 :** L'utilisateur peut consulter les photos stockées localement sans connexion

### Intégration DVF

- **FR35 :** Le système récupère les données de transactions récentes DVF pour une localisation donnée
- **FR36 :** L'utilisateur peut consulter les prix de transactions comparables autour d'une annonce
- **FR37 :** Les données DVF déjà téléchargées sont consultables en mode offline

### Partage de Fiches

- **FR38 :** L'utilisateur peut générer un lien public de consultation vers une fiche projet
- **FR39 :** Le lien public masque les données financières sensibles du MDB
- **FR40 :** L'artisan peut consulter les informations du bien (photos, plans, description travaux) via le lien partagé
- **FR41 :** L'artisan peut soumettre une fourchette estimative de devis via le lien partagé
- **FR42 :** L'associé invité peut consulter le pipeline et les fiches via son compte

### Simulateur TVA sur Marge

- **FR43 :** L'utilisateur peut saisir les paramètres d'une opération (prix achat, travaux, frais)
- **FR44 :** Le système calcule automatiquement la base TVA et la TVA due à la revente
- **FR45 :** L'utilisateur peut simuler différents scénarios de prix de revente

### Guide Fiscalité MDB

- **FR46 :** L'utilisateur peut consulter les règles TVA sur marge vs TVA sur total
- **FR47 :** L'utilisateur peut consulter les règles de plus-value professionnelle
- **FR48 :** L'utilisateur peut consulter les différents régimes d'imposition applicables
- **FR49 :** Le système alerte l'utilisateur sur les délais de revente fiscaux

## Non-Functional Requirements

### Performance

| Critère | Cible |
|---------|-------|
| Chargement initial (mobile natif) | < 2s |
| Chargement initial (web) | < 3s |
| Navigation entre écrans | < 300ms |
| Synchronisation après offline (10 fiches) | < 5s |
| Recherche DVF (avec réseau) | < 3s |
| Taille app installée | < 50 MB |

### Security

- Authentification JWT avec refresh token
- Mots de passe hashés (bcrypt/argon2)
- Communications HTTPS exclusivement
- Données stockées localement chiffrées sur le device
- Liens de partage publics avec token unique, révocables
- Séparation stricte des données par rôle (artisan ne voit pas les données financières)
- Conformité RGPD : données personnelles des agents immo stockées avec consentement, suppression possible

### Scalability

- Usage initial : 1 utilisateur, quelques dizaines de fiches
- Architecture prête pour multi-utilisateur (scaling horizontal du backend si commercialisation future)
- Base de données relationnelle classique suffisante pour la V1

### Integration

- **DVF (data.gouv.fr)** : API REST, proxy serveur, cache avec TTL de 24h, fallback gracieux si indisponible
- **Stockage photos** : upload serveur OVH, compression côté client avant upload
- **Export futur (V2)** : architecture prévue pour intégration Pennylane / export FEC

### Reliability

- Disponibilité cible : 99%
- Mode offline = résilience naturelle aux pannes serveur
- Backup automatique de la base de données (quotidien)
- Pas de perte de données en cas de coupure réseau pendant la saisie
