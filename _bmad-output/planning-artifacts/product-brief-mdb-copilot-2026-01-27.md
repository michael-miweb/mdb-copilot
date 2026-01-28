---
stepsCompleted: [1, 2, 3, 4, 5, 6]
inputDocuments:
  - _bmad-output/brainstorming/brainstorming-session-2026-01-26.md
date: 2026-01-27
author: Michael
---

# Product Brief: MDB Copilot

## Executive Summary

**MDB Copilot** est une application web et mobile destinée aux Marchands de Biens débutants en France. Elle accompagne l'utilisateur à chaque étape de son activité d'achat-revente immobilière : prospection, visite, analyse de rentabilité et prise de décision.

Le produit répond à un besoin fondamental : **éviter les erreurs coûteuses** lorsqu'on se lance dans une activité complexe mêlant immobilier, finance, fiscalité et travaux, sans expérience terrain préalable.

MDB Copilot se positionne comme un **assistant structurant** qui guide l'utilisateur à travers des checklists, des calculs automatisés et des fiches éducatives, comblant le vide entre les connaissances théoriques et la pratique opérationnelle.

---

## Core Vision

### Problem Statement

Se lancer en tant que Marchand de Bien en France implique de maîtriser simultanément plusieurs domaines : évaluation immobilière, estimation de travaux, fiscalité spécifique (TVA sur marge, plus-value professionnelle), négociation, financement bancaire et gestion de projet. Un débutant navigue sans filet, avec un risque financier réel à chaque décision.

### Problem Impact

- **Financier :** Une erreur d'estimation (travaux, fiscalité, prix de revente) peut transformer une opération rentable en perte sèche
- **Opérationnel :** Sans méthode structurée, des éléments critiques sont oubliés (vérifications juridiques, questions en visite, frais cachés)
- **Psychologique :** L'incertitude permanente freine la prise de décision et l'engagement dans l'activité
- **Temporel :** Rechercher manuellement chaque information (prix marché, fiscalité, documents notaire) consomme un temps considérable

### Why Existing Solutions Fall Short

| Solution existante | Lacune |
|-------------------|--------|
| Tableurs Excel/Sheets | Pas de structure MDB, pas mobile, pas offline, pas de workflow guidé |
| CRM immobiliers (Hektor, Immofacile) | Conçus pour les agents immobiliers, pas pour le workflow d'achat-revente |
| Apps investissement locatif (Horiz.io) | Focus sur la location, pas sur l'achat-revente |
| Tableurs MDB partagés en ligne | Pas d'app mobile, pas de checklist terrain, pas d'éducation intégrée |

**Aucun outil ne couvre le workflow complet du MDB débutant en France**, de la prospection à la revente, avec une dimension éducative et un accompagnement terrain (offline, checklists de visite).

### Proposed Solution

MDB Copilot est un **tableau de bord décisionnel et assistant opérationnel** pour l'activité Marchand de Bien, articulé autour de :

1. **Fiches annonces** avec saisie manuelle, suivi de statut et informations agent
2. **Pipeline visuel Kanban** pour suivre tous les projets en un coup d'œil
3. **Checklists pré et post visite** avec réponses guidées pour ne rien oublier
4. **Fiches mémo MDB** (fiscalité, juridique, bonnes pratiques) en double format : guide complet + mémo synthétique
5. **Mode offline** pour une utilisation terrain sans réseau
6. **Partage flexible** (lien public ou compte invité) pour collaborer avec artisans et partenaires
7. **Intégration DVF** pour des données marché objectives et gratuites

### Key Differentiators

| Différenciateur | Avantage compétitif |
|-----------------|---------------------|
| **Spécifique MDB France** | Workflow adapté à la réalité du Marchand de Bien français (fiscalité, notariat, DVF) |
| **Conçu pour les débutants** | Dimension éducative intégrée, checklists guidées, alertes proactives |
| **Terrain-first** | Mode offline, checklists de visite, capture photos contextualisée |
| **Workflow complet** | De la prospection à la revente, pas juste un calculateur |
| **Copilote anti-erreur** | L'outil structure, alerte et éduque pour éviter les erreurs coûteuses |

## Target Users

### Primary Users

**Persona : Michael, 39 ans - Développeur indépendant & investisseur immobilier**

| Attribut | Détail |
|----------|--------|
| **Âge** | 39 ans |
| **Activité principale** | Développeur d'applications sur mesure, 18+ ans en indépendant |
| **Expérience immo** | Investissement locatif existant, débutant en Marchand de Bien |
| **Rapport à la tech** | Expert - développe lui-même ses outils |
| **Motivation** | Diversification d'activité, recherche de nouveaux leviers de revenus |
| **Besoin fondamental** | Un assistant structurant pour éviter les erreurs de débutant MDB |

**Comment il vit le problème :**
- Il a les compétences analytiques et techniques, mais pas l'expérience terrain MDB
- Il sait que les erreurs coûtent cher et veut un filet de sécurité
- Il veut avancer vite mais de manière méthodique

**Ce qui le rendrait satisfait :**
- Se sentir accompagné à chaque étape
- Ne jamais se dire "j'aurais dû vérifier ça"
- Avoir confiance dans ses calculs de rentabilité

### Secondary Users

**Artisan partenaire (accès consultation)**
- Consulte la fiche projet pour comprendre le bien et les travaux attendus
- Soumet une fourchette estimative de devis
- N'a pas accès aux données financières du MDB

**Associé potentiel (accès étendu)**
- Consulte le portfolio et le pipeline de projets
- Peut partager la vision et la stratégie
- Accès contrôlé via compte invité

### User Journey

| Étape | Action Michael | MDB Copilot |
|-------|---------------|-------------|
| **Découverte annonce** | Repère un bien intéressant en ligne | Crée une fiche, saisit les infos, note l'agent |
| **Screening** | Évalue rapidement le potentiel | Score d'opportunité, prix vs marché (DVF) |
| **Prise de RDV** | Appelle l'agent, note l'urgence de vente | Met à jour le statut, prépare la checklist pré-visite |
| **Visite terrain** | Parcourt le bien avec la checklist | Mode offline, réponses guidées, capture photos |
| **Analyse post-visite** | Remonte en voiture | Dashboard verdict : alertes + estimation travaux + marge |
| **Décision Go/No Go** | Compare avec d'autres projets | Pipeline Kanban, vue comparative |
| **Moment "aha!"** | Première visite structurée sans oubli | "C'est exactement ce dont j'avais besoin" |
| **Usage long terme** | Routine sur chaque nouvelle annonce | L'outil devient indispensable, portfolio se remplit |

### Exigences techniques utilisateur

- **Écran de connexion** requis dès la V1 (authentification)
- Multi-utilisateur ready (architecture prévue même si usage solo initial)
- Gestion des rôles : propriétaire / invité consultation / invité étendu
- **UI/UX iOS 26+** : Design language Apple moderne (Liquid Glass, transparences, typographie SF) appliqué sur tous les devices (mobile, tablette, desktop web)

## Success Metrics

### Métriques de succès utilisateur

| Métrique | Indicateur | Cible |
|----------|-----------|-------|
| **Adoption** | L'outil est utilisé à chaque nouvelle annonce identifiée | 100% des annonces saisies dans MDB Copilot |
| **Fiabilité** | Aucune erreur majeure sur la première opération MDB | 0 erreur coûteuse (fiscalité, travaux, juridique) |
| **Gain de temps** | Temps d'analyse d'une annonce réduit vs méthode manuelle | Réduction significative perçue |
| **Confiance** | Décisions Go/No Go prises avec sérénité | Utilisation systématique de la checklist visite |
| **Complétude** | Aucun oubli lors des visites terrain | 100% de la checklist complétée à chaque visite |

### Business Objectives

| Horizon | Objectif | Mesure |
|---------|----------|--------|
| **3 mois** | Première opération MDB rentable réalisée avec l'outil | Marge nette positive sur l'opération |
| **6 mois** | Outil utilisé en routine sur toutes les opportunités | Nombre d'annonces trackées et analysées |
| **12 mois** | Activité MDB structurée et rentable | Nombre d'opérations + marge cumulée |
| **Commercialisation** | Utilisateurs actifs payants | Nombre d'inscrits, rétention mensuelle, revenu récurrent |

### Key Performance Indicators

**V1 (usage personnel) :**

| KPI | Méthode de mesure |
|-----|-------------------|
| Annonces saisies / mois | Compteur dans l'app |
| Visites réalisées avec checklist | Ratio checklists complétées / visites |
| Taux de conversion annonce → visite → offre | Pipeline Kanban |
| Opérations rentables / total opérations | P&L par projet |
| Utilisation du mode offline | Logs de sync |

**Futur (commercialisation) :**

| KPI | Cible indicative |
|-----|-----------------|
| Utilisateurs actifs mensuels | À définir au lancement |
| Rétention M1 / M3 / M6 | > 60% / > 40% / > 30% |
| NPS (Net Promoter Score) | > 40 |
| Taux de conversion free → paid | À définir selon modèle |

## MVP Scope

### Core Features

| # | Feature | Description |
|---|---------|-------------|
| 1 | **Authentification** | Écran de connexion, gestion de compte, multi-utilisateur ready |
| 2 | **Fiches annonces** | Saisie manuelle, infos bien + agent immo + urgence vente |
| 3 | **Score d'opportunité** | Note combinant : prix vs marché (DVF) + urgence vente + potentiel |
| 4 | **Pipeline Kanban** | Prospection → RDV → Visite → Analyse → Offre → Acheté → Travaux → Vente → Vendu |
| 5 | **Checklist pré-visite** | Préparation : questions à poser, documents à demander, points à vérifier |
| 6 | **Guide de visite interactif** | Réponses guidées par catégorie, prise de photos contextualisées, notes échanges agent |
| 7 | **Synthèse post-visite** | Récap automatique basé sur réponses du guide + alertes + première analyse |
| 8 | **Fiches mémo MDB** | Guides complets + fiches mémo synthétiques (fiscalité, juridique, bonnes pratiques) |
| 9 | **Mode offline** | Consultation et saisie hors connexion, synchronisation au retour |
| 10 | **Intégration DVF** | Données de transactions récentes pour estimation prix marché |
| 11 | **Partage fiches** | Lien public ou compte invité pour partager avec artisan/partenaire |
| 12 | **Simulateur TVA sur marge** | Calcul automatique : prix achat + travaux + frais → base TVA → TVA due à la revente |
| 13 | **Guide fiscalité MDB** | TVA sur marge vs TVA sur total, plus-value professionnelle, régimes d'imposition, alertes délai revente |

### Out of Scope for MVP

| Feature | Raison du report | Version cible |
|---------|------------------|---------------|
| Partie compta (P&L, trésorerie, projections) | Complexe, pas indispensable pour la première opération | V2 |
| Générateur dossier bancaire | Utile mais pas bloquant pour démarrer | V2 |
| Suivi avancement travaux + alertes | Nécessaire une fois en opération, pas au démarrage | V2 |
| Comparateur devis artisans | Fonctionnel mais secondaire pour la première opération | V2 |
| Intégration Pennylane / export compta | Pas nécessaire tant que l'activité n'est pas lancée | V2 |
| Mode vocal | Confort, pas essentiel | V2+ |
| Veille marché continue | Utile mais complexe à implémenter | V2 |
| Calcul marge inversée | Très utile mais faisable manuellement au début | V2 |
| Rapport annuel / mode investisseur | Pas pertinent avant d'avoir un historique | V2+ |

### MVP Success Criteria

| Critère | Validation |
|---------|------------|
| **Workflow complet** | Pouvoir traiter une annonce de la découverte à la décision Go/No Go |
| **Utilisation terrain** | Guide de visite fonctionnel en mode offline |
| **Zéro oubli** | Checklist complète = aucun point critique raté |
| **Décision éclairée** | Score d'opportunité + synthèse post-visite = confiance dans le Go/No Go |
| **Maîtrise fiscale** | Calcul TVA sur marge fiable, alertes fiscales pertinentes |
| **Première opération** | Première opération MDB rentable réalisée avec l'outil |

### Future Vision

**V2 - Pilotage opérationnel :**
- Calculateurs financiers (marge, plus-value pro, calcul inversé)
- Suivi travaux avec alertes dérapage
- Comparateur devis artisans
- Dashboard financier (P&L par projet, trésorerie)
- Intégration comptable (Pennylane, export FEC)

**V3 - Intelligence & Scale :**
- Veille marché continue
- Scoring prédictif (apprentissage sur les opérations passées)
- Mode présentation investisseur/associé
- Rapport annuel auto-généré
- Collaboration artisan avancée (suivi avancement, paiements jalonnés)

**Commercialisation :**
- Ouverture à d'autres MDB débutants en France
- Modèle freemium ou abonnement
- Contenu éducatif enrichi (vidéos, cas pratiques)

