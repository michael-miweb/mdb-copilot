---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
lastStep: 14
inputDocuments:
  - _bmad-output/planning-artifacts/product-brief-mdb-copilot-2026-01-27.md
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/epics.md
  - _bmad-output/planning-artifacts/architecture.md
revision:
  date: 2026-02-03
  reason: "Pivot technologique Flutter → React Native + React Web"
  sections_updated:
    - Design System Foundation
    - Component Strategy
    - Implementation Guidelines
    - User Journey Flows
    - Implementation Status
---

# UX Design Specification MDB Copilot

**Author:** Michael
**Date:** 2026-01-28
**Révision:** 2026-02-03 (pivot React)

---

## Executive Summary

### Project Vision

**MDB Copilot** est un assistant numérique pour Marchands de Biens débutants en France. L'application accompagne l'utilisateur dans tout le cycle d'achat-revente immobilière : prospection, visite terrain, analyse de rentabilité et prise de décision.

L'objectif UX principal : **éviter les erreurs coûteuses** en guidant l'utilisateur à chaque étape avec des checklists, calculs automatisés et contenus éducatifs.

### Target Users

**Persona principal : Michael, 39 ans**
- Développeur indépendant avec expérience en investissement locatif
- Débutant en activité Marchand de Bien
- Expert tech, mais pas d'expérience terrain MDB
- Besoin : un filet de sécurité pour éviter les erreurs coûteuses

**Utilisateurs secondaires :**
- **Artisan partenaire** : accès consultation pour comprendre le bien et soumettre des devis
- **Associé potentiel** : accès étendu pour consulter le portfolio et la stratégie

### Key Design Challenges

- **Usage terrain critique** : Le guide de visite doit fonctionner parfaitement offline, être rapide à utiliser sur place, et permettre la saisie one-handed
- **Complexité fiscale** : Rendre accessible des concepts complexes (TVA sur marge, plus-value pro) pour un débutant
- **Workflow dense** : 13 capabilities à intégrer sans surcharger l'interface

### Design Opportunities

1. **Moment "aha!" terrain** : La synthèse post-visite générée automatiquement = différenciateur majeur
2. **Anti-erreur proactif** : Alertes visuelles intelligentes (red flags) pour protéger l'utilisateur
3. **Éducation contextuelle** : Fiches mémo accessibles au bon moment dans le workflow
4. **Collaboration fluide** : Partage de fiches avec artisans = professionnalisme de l'outil

## Design System

### Framework

**Material 3** (Material You) comme système de design unique.

### Palette de couleurs

- **Cohérente** : Palette unique déclinée sur tous les écrans
- **Professionnelle** : Tons sobres, éviter les couleurs criardes ou ludiques
- **Rassurante** : Couleurs qui inspirent confiance et sérénité (bleus, verts sourds, neutres chauds)
- Couleurs sémantiques claires : succès (vert), alerte (orange), erreur/red flag (rouge)

### Modes d'affichage

- **Light Mode** : Mode par défaut, adapté à l'usage terrain en extérieur
- **Dark Mode** : Mode alternatif, confortable pour l'analyse en intérieur/soirée
- Basculement automatique selon les préférences système ou manuel

### Esthétique générale

- **Harmonieux, gracieux, élégant**
- Formes arrondies au maximum (boutons, cartes, inputs, modales)
- Transitions fluides et animations subtiles

### Champs de saisie (inputs)

- **Pas de labels flottants** : labels fixes au-dessus du champ
- Bordures arrondies prononcées
- États clairs : repos, focus, erreur, désactivé

### Composants

- Material 3 via MUI (React Web) et React Native Paper (mobile), customisés pour les coins arrondis
- Design tokens cohérents sur toutes les plateformes (mobile, tablette, web)
- Responsive : mobile-first (usage terrain) puis desktop (analyse)

## Core User Experience

### Defining Experience

L'expérience centrale de MDB Copilot est le **guide de visite terrain** : l'utilisateur parcourt un bien immobilier avec son téléphone, répond aux questions guidées, prend des photos contextualisées, et obtient instantanément une synthèse complète avec alertes et estimation de marge.

Le moment "aha!" : remonter dans sa voiture avec un verdict complet sans avoir rien oublié.

### Platform Strategy

| Plateforme | Usage | Priorité |
|------------|-------|----------|
| **Mobile (iOS/Android)** | Terrain : visites, photos, checklists | **Haute** |
| **Web desktop** | Bureau : analyse, Kanban, simulations | Moyenne |
| **Tablette** | Hybride : visite confortable + analyse | Moyenne |

- **Offline obligatoire** : visite en cave, parking souterrain, zone blanche
- **Touch-first** sur mobile, souris/clavier sur desktop
- **Sync transparente** au retour réseau

### Effortless Interactions

1. **Créer une fiche annonce** : saisie rapide, le minimum vital d'abord
2. **Lancer une visite** : un tap et c'est parti, pas de configuration
3. **Prendre une photo contextualisée** : appareil photo intégré au guide, photo auto-taggée
4. **Consulter une fiche mémo** : accessible en 1 tap depuis n'importe quel écran pertinent
5. **Voir le verdict post-visite** : synthèse générée automatiquement, rien à faire

### Critical Success Moments

| Moment | Critère de succès |
|--------|-------------------|
| **Première visite avec l'app** | Utilisateur complète la visite sans se perdre dans l'interface |
| **Synthèse post-visite** | "Wow, je n'ai rien oublié, j'ai tout sous les yeux" |
| **Red flag détecté** | Alerte visible et comprise immédiatement |
| **Décision Go/No Go** | Confiance suffisante pour agir |

### Experience Principles

1. **Terrain d'abord** : Chaque feature doit fonctionner parfaitement sur mobile, offline, d'une main
2. **Zéro oubli** : L'app guide, alerte, rappelle — l'utilisateur ne peut pas rater un point critique
3. **Verdict instantané** : Après chaque action significative, un feedback clair et actionnable
4. **Éducation au bon moment** : L'aide contextuelle apparaît quand elle est utile, pas avant

## Desired Emotional Response

### Primary Emotional Goals

**Émotion dominante : Confiance sereine**
L'utilisateur doit se sentir **accompagné et en contrôle**, jamais submergé ni seul face à des décisions lourdes financièrement.

**Émotions de soutien :**
- **Compétence** : "Je sais ce que je fais" (même en tant que débutant)
- **Sécurité** : "Je ne peux pas rater un point critique"
- **Clarté** : "J'ai toutes les infos pour décider"

### Emotional Journey Mapping

| Moment | Émotion visée |
|--------|---------------|
| **Découverte de l'app** | Curiosité + soulagement ("enfin un outil pour ça") |
| **Création de la première fiche** | Satisfaction rapide ("c'est simple et bien structuré") |
| **Pendant la visite terrain** | Focus + confiance ("je suis guidé, rien ne m'échappe") |
| **Synthèse post-visite** | Fierté + clarté ("j'ai un verdict professionnel") |
| **Détection d'un red flag** | Gratitude ("heureusement que l'app m'a alerté") |
| **Erreur ou problème** | Calme ("ce n'est pas grave, l'app me guide pour corriger") |
| **Retour dans l'app** | Familiarité ("mon cockpit, mon outil de travail") |

### Micro-Emotions

- **Confiance > Confusion** : Chaque écran doit être immédiatement lisible
- **Accomplissement > Frustration** : Chaque action complétée = feedback positif
- **Sérénité > Anxiété** : Les alertes informent sans alarmer inutilement

### Design Implications

| Émotion | Approche UX |
|---------|-------------|
| **Confiance** | Interface épurée, hiérarchie visuelle claire, pas de surcharge |
| **Sécurité** | Alertes visibles mais pas anxiogènes, couleurs douces pour les avertissements |
| **Compétence** | Terminologie accessible, fiches mémo à portée de main |
| **Clarté** | Verdicts visuels (score, couleurs sémantiques), synthèses concises |
| **Calme en cas d'erreur** | Messages d'erreur bienveillants, actions de correction suggérées |

### Emotional Design Principles

1. **Rassurer, jamais alarmer** : Les red flags informent avec clarté, pas avec panique
2. **Célébrer les progrès** : Feedback positif à chaque étape franchie
3. **Guider sans infantiliser** : L'utilisateur est un professionnel en devenir, pas un novice perdu
4. **Simplicité = confiance** : Moins il y a de bruit visuel, plus l'utilisateur se sent en contrôle

## UX Pattern Analysis & Inspiration

### Inspiring Products Analysis

**1. Notion** — Organisation & structure
- Navigation latérale claire, hiérarchie visuelle forte
- Blocs modulaires adaptables à chaque besoin
- Interface épurée qui ne distrait jamais du contenu
- **À retenir** : La sensation de contrôle et de structure sans rigidité

**2. Things 3** — Productivité mobile-first
- Design élégant, coins arrondis, animations fluides
- Interactions gestuelles naturelles (swipe, drag)
- Feedback subtil à chaque action complétée
- **À retenir** : L'élégance et la satisfaction d'usage au quotidien

**3. Google Maps** — Usage terrain offline
- Fonctionne parfaitement en mode dégradé/offline
- Interface adaptée à l'usage one-handed en déplacement
- Informations contextuelles au bon moment
- **À retenir** : La fiabilité terrain et l'information contextuelle

### Transferable UX Patterns

**Navigation :**
- **Bottom navigation bar** (mobile) : accès rapide aux sections principales d'une main
- **Navigation rail** (desktop/tablette) : barre latérale compacte avec icônes + labels
- Même structure de navigation, adaptée au form factor
- **Hiérarchie en profondeur** : liste → détail → sous-détail sans se perdre

**Interaction :**
- **Swipe actions** (Things 3) : actions rapides sur les fiches (archiver, changer statut)
- **Pull-to-refresh** : sync manuelle en complément de la sync auto
- **Progressive disclosure** (Notion) : montrer l'essentiel d'abord, le détail sur demande

**Visuel :**
- **Cartes arrondies avec ombres douces** : fiches annonces lisibles et élégantes
- **Couleurs sémantiques discrètes** : badges de statut, scores, alertes
- **Espacement généreux** : respiration visuelle, pas de surcharge

### Anti-Patterns to Avoid

- **Surcharge d'informations** : Ne pas afficher toutes les données d'une fiche sur un seul écran
- **Modales bloquantes** : Pas de pop-ups agressifs, préférer les bottom sheets arrondis
- **Navigation profonde sans retour clair** : Toujours savoir où on est et comment revenir
- **Formulaires géants** : Découper la saisie en étapes courtes plutôt qu'un long formulaire

### Design Inspiration Strategy

**Adopter :**
- Bottom navigation (mobile) + Navigation rail (desktop/tablette) + hiérarchie liste/détail
- Cards arrondies comme unité visuelle principale
- Feedback positif à chaque action (micro-animations)

**Adapter :**
- Le Kanban de Notion → simplifié en vue pipeline horizontale tactile
- Le mode offline de Google Maps → appliqué à la sync des fiches et du guide visite

**Éviter :**
- L'aspect "tableur" des apps immobilières pro
- Les interfaces trop denses type CRM desktop
- Les animations lourdes qui ralentissent l'usage terrain

## Design System Foundation

### Design System Choice

**Material 3** (Material You) — Système thématisable via MUI (React Web) et React Native Paper (mobile).

### Rationale for Selection

| Facteur | Justification |
|---------|---------------|
| **Stack React** | MUI et React Native Paper offrent un support M3 mature et bien documenté |
| **Développeur solo** | Composants prêts à l'emploi, pas de design system custom à maintenir |
| **Multi-plateforme** | Rendu cohérent mobile (React Native) + web (React) |
| **Thématisation** | `createTheme()` (MUI) et `MD3Theme` (Paper) entièrement personnalisables |
| **Accessibilité** | Contrastes, tailles tactiles, sémantique intégrés nativement |

### Implementation Approach

- Utiliser les systèmes de tokens M3 natifs : MUI `createTheme()` pour React Web, React Native Paper `MD3LightTheme`/`MD3DarkTheme` pour mobile
- Implémenter un layout responsive custom avec `useMediaQuery` pour le switch Navigation Bar ↔ Navigation Rail selon la largeur d'écran
- Police Inter via `@fontsource/inter` (web) et `expo-google-fonts` (mobile)
- Icônes Material Symbols Rounded via `@mui/icons-material` (web) et `react-native-vector-icons/MaterialCommunityIcons` (mobile)
- Labels fixes au-dessus des inputs (pas de floating labels)
- Fichier de référence visuelle : `_bmad-output/planning-artifacts/ux-design-directions.html`

**Composants personnalisés :**
- Cards arrondies avec ombres douces (fiches annonces)
- Bottom sheets arrondis (actions contextuelles)
- Badges sémantiques (score, statut pipeline, alertes)

### Customization Strategy

| Composant Material 3 | Web (MUI) | Mobile (React Native Paper) |
|----------------------|-----------|----------------------------|
| Button | `Button` variant="contained", borderRadius pills | `Button` mode="contained", style arrondis |
| Card | `Card`, borderRadius 16px, elevation douce | `Card` mode="elevated", roundness 16 |
| TextField | `TextField` variant="outlined", label externe | `TextInput` mode="outlined", label externe |
| Navigation (mobile) | `BottomNavigation` | `BottomNavigation` avec 4-5 destinations |
| Navigation (desktop) | `Drawer` variant="permanent" compact | Navigation Rail custom |
| Bottom Sheet | `SwipeableDrawer` anchor="bottom" | `@gorhom/bottom-sheet` |
| Chip / Badge | `Chip`, `Badge` | `Chip`, `Badge` |

## Defining Core Experience

### Defining Experience

**L'expérience fondatrice : Le guide de visite terrain → synthèse automatique**

> "Je visite un bien avec mon téléphone, l'app me guide point par point, et en remontant dans ma voiture j'ai un verdict complet avec alertes et estimation de marge."

C'est le moment clé de MDB Copilot : parcourir un bien catégorie par catégorie (structure, électricité, plomberie...), répondre à des questions simples, prendre des photos, et obtenir un verdict actionnable sans effort supplémentaire.

### User Mental Model

**Modèle actuel (sans outil) :**
- Carnet papier ou notes téléphone en vrac
- Questions oubliées, photos non organisées
- Analyse manuelle le soir en essayant de se souvenir
- Tableur Excel pour les calculs, si on y pense

**Modèle attendu (avec MDB Copilot) :**
- L'app est un co-pilote qui pose les bonnes questions
- L'utilisateur répond et documente, l'app synthétise
- Le verdict arrive automatiquement, structuré et fiable

**Point de friction potentiel :**
- Trop de questions pendant la visite → sensation de corvée
- Solution : questions courtes (oui/non/sélection), saisie libre optionnelle

### Success Criteria

| Critère | Indicateur |
|---------|-----------|
| **Rapidité** | Visite guidée complétable en moins de temps qu'une visite non guidée |
| **Complétude** | 100% des points critiques couverts sans oubli |
| **Clarté du verdict** | Décision Go/No Go possible immédiatement après la visite |
| **Zéro friction** | Pas besoin de lire un mode d'emploi pour utiliser le guide |
| **Confiance** | L'utilisateur fait confiance au verdict sans recalculer manuellement |

### Novel UX Patterns

**Approche : Patterns établis combinés de manière innovante**

- **Checklist guidée** (pattern établi) → enrichie de photos contextualisées et réponses structurées
- **Synthèse auto-générée** (innovation) → verdict basé sur les réponses, pas de saisie supplémentaire
- **Alertes proactives** (innovation) → red flags détectés automatiquement depuis les réponses

Pas besoin d'éduquer l'utilisateur sur un nouveau paradigme. Patterns familiers (checklist, formulaire, cartes) assemblés dans un workflow intelligent.

### Experience Mechanics

**1. Initiation :**
- Depuis la fiche annonce, un bouton proéminent "Lancer la visite"
- Le guide s'ouvre directement sur la première catégorie
- Indicateur de progression visible (étape X/Y)

**2. Interaction :**
- Navigation par catégorie (swipe ou tap)
- Questions courtes : boutons de réponse (Bon / Moyen / Mauvais), sélection multiple, toggle
- Bouton photo accessible en permanence, photo auto-taggée à la catégorie en cours
- Zone de notes libres optionnelle en bas de chaque catégorie

**3. Feedback :**
- Progression visuelle (barre ou dots)
- Catégorie complétée = check mark vert
- Red flag détecté en temps réel = badge d'alerte sur la catégorie

**4. Completion :**
- Dernière catégorie terminée → transition vers la synthèse
- Synthèse affichée automatiquement : score global, alertes, estimation travaux, marge prévisionnelle
- Bouton d'action clair : "Classer en Go" / "Classer en No Go" / "À approfondir"

## Visual Design Foundation

### Color System

#### Light Mode

| Rôle | Hex | Usage |
|------|-----|-------|
| **Primary (Violet)** | `#7c4dff` | Actions principales, éléments interactifs |
| **Accent (Magenta)** | `#f3419f` | Accents, highlights, CTAs secondaires |
| **Warn (Rouge)** | `#dc2626` | Erreurs, alertes, actions destructives |

**Échelle Primary (Violet) :**
50: `#ede7f6` · 100: `#d1c4e9` · 200: `#b39ddb` · 300: `#9575cd` · 400: `#7e57c2` · 500: `#7c4dff` · 600: `#5e35b1` · 700: `#512da8` · 800: `#4527a0` · 900: `#311b92` · 950: `#1a0a52`

**Échelle Accent (Magenta) :**
50: `#fce4ec` · 100: `#f8bbd9` · 200: `#f48fb1` · 300: `#f06292` · 400: `#ec407a` · 500: `#f3419f` · 600: `#d81b60` · 700: `#c2185b` · 800: `#ad1457` · 900: `#880e4f` · 950: `#560027`

#### Dark Mode

| Rôle | Hex | Usage |
|------|-----|-------|
| **Primary (Indigo)** | `#5750d8` | Actions principales, éléments interactifs |
| **Accent (Orchidée)** | `#d063de` | Accents, highlights, CTAs secondaires |
| **Warn (Rouge)** | `#dc2626` | Erreurs, alertes, actions destructives |

**Échelle Primary (Indigo) :**
50: `#e8eaf6` · 100: `#c5cae9` · 200: `#9fa8da` · 300: `#7986cb` · 400: `#5c6bc0` · 500: `#5750d8` · 600: `#3f51b5` · 700: `#3949ab` · 800: `#303f9f` · 900: `#1a237e` · 950: `#0d1240`

**Échelle Accent (Orchidée) :**
50: `#f3e5f5` · 100: `#e1bee7` · 200: `#ce93d8` · 300: `#ba68c8` · 400: `#ab47bc` · 500: `#d063de` · 600: `#8e24aa` · 700: `#7b1fa2` · 800: `#6a1b9a` · 900: `#4a148c` · 950: `#2a0a50`

### Typography System

**Police : Inter** (via @fontsource/inter sur web, expo-google-fonts sur mobile)

| Rôle | Taille | Poids | Usage |
|------|--------|-------|-------|
| **Display** | 28-32sp | 700 | Titres de page |
| **Headline** | 22-24sp | 500 | Titres de section |
| **Title** | 18-20sp | 500 | Titres de carte |
| **Body** | 14-16sp | 400 | Contenu principal |
| **Label** | 12-14sp | 500 | Labels, badges, boutons |
| **Caption** | 11-12sp | 400 | Notes, dates, métadonnées |

### Spacing & Layout Foundation

**Unité de base : 8px**
- Multiples : 4, 8, 16, 24, 32, 48
- Padding intérieur cartes : 16px
- Gap entre cartes : 12-16px
- Marges de page : 16px (mobile), 24px (tablette), 32px (desktop)

**Layout :**
- Espacement généreux — respiration visuelle, pas de densité
- Cards comme unité de base, jamais de tableaux denses

**Border radius :**
- Boutons : 24px (pilule)
- Cards : 16px
- Inputs : 12px
- Bottom sheets : 24px en haut
- Chips/badges : full round

### Accessibility Considerations

- Contraste WCAG AA minimum (4.5:1 texte, 3:1 éléments interactifs)
- Tailles tactiles minimum 48x48dp
- Texte jamais en dessous de 12sp
- Couleurs sémantiques toujours accompagnées d'icônes (pas de communication par la couleur seule)

## Design Direction Decision

### Design Directions Explored

7 directions visuelles ont été générées sous forme de mockups interactifs HTML couvrant l'ensemble des écrans clés : Dashboard, Fiche Annonce, Pipeline Kanban, Guide de Visite, Synthèse Post-Visite, Formulaire de Création, et Dark Mode avec vue Desktop.

Chaque direction applique le système Material 3 complet avec : Navigation Bar M3 (pill indicator, icônes Material Symbols Rounded outlined/filled), surfaces hiérarchiques M3, typographie Inter, élévation M3, et composants arrondis au maximum.

### Chosen Direction

**Direction unifiée Material 3** — Une seule direction cohérente intégrant :

- **Light Mode** : Palette Violet/Magenta (Primary #7c4dff, Accent #f3419f) sur surfaces M3 claires
- **Dark Mode** : Palette Indigo/Orchidée avec couleurs personnalisées :
  - Background global : `rgb(30, 35, 52)`
  - Cartes et menus : `rgb(44, 48, 73)`
  - Boutons primaires / accents : `rgb(208, 99, 222)`
- **Mobile** : Navigation Bar M3 en bas avec pill indicator 64×32px
- **Desktop/Tablet** : Navigation Rail M3 à gauche (80px) avec FAB intégré

### Design Rationale

- Material 3 assure la cohérence cross-platform via MUI (web) et React Native Paper (mobile)
- La palette Violet/Magenta inspire confiance et professionnalisme en Light Mode
- Le Dark Mode Indigo/Orchidée avec surfaces `rgb(30,35,52)` offre une ambiance apaisée pour l'analyse nocturne, distincte du noir pur
- La Navigation Rail desktop exploite l'espace horizontal pour une productivité accrue
- Les arrondis maximaux (pills, 16px cards, 12px inputs) créent l'esthétique harmonieuse et gracieuse demandée

### Implementation Approach

- Utiliser les systèmes de tokens M3 natifs : MUI `createTheme()` pour React Web, React Native Paper `MD3LightTheme`/`MD3DarkTheme` pour mobile
- Implémenter un layout responsive custom avec `useMediaQuery` pour le switch Navigation Bar ↔ Navigation Rail selon la largeur d'écran
- Police Inter via `@fontsource/inter` (web) et `expo-google-fonts` (mobile)
- Icônes Material Symbols Rounded via `@mui/icons-material` (web) et `react-native-vector-icons/MaterialCommunityIcons` (mobile)
- Labels fixes au-dessus des inputs (pas de floating labels)
- Fichier de référence visuelle : `_bmad-output/planning-artifacts/ux-design-directions.html`

## User Journey Flows

### Parcours 1 : Découverte → Analyse → Visite → Décision

**Entrée :** FAB "+" depuis Dashboard ou Pipeline Kanban

**Flow :**
1. **Créer fiche annonce** → 2 options : **coller un lien** (LeBonCoin, SeLoger, PAP, Logic-Immo) **ou** saisie manuelle
2. Si lien collé → extraction automatique (surface, prix, localisation, photos, description)
3. Si extraction partielle → formulaire pré-rempli à compléter (voir Parcours 6)
4. Associer agent immobilier (depuis carnet d'adresses ou création inline)
5. Enrichissement DVF automatique → score d'opportunité calculé
6. **Fiche mémo contextuelle suggérée** selon les données détectées
7. Si score favorable → prise RDV → statut Kanban "RDV" → checklist pré-visite générée
8. Jour J → lancer guide de visite (→ Parcours 2)
9. Synthèse post-visite générée automatiquement avec **liens mémo contextuels**
10. Décision : Offre (Kanban "Offre") ou No Go (Kanban "No Go")

**Principes :**
- Feedback continu : score mis à jour en temps réel à chaque info ajoutée
- Progressive disclosure : DVF et score apparaissent après saisie localisation + prix
- Transition Kanban automatique : le statut suit les actions (Nouveau → RDV → Visité → Offre / No Go)
- Récupération erreur : saisie sauvegardée en brouillon, retour possible à chaque étape

### Parcours 2 : Guide de visite terrain (offline)

**Entrée :** Bouton "Lancer la visite" depuis la fiche annonce

**Flow :**
1. Téléchargement données offline (transparent si déjà en cache)
2. Écran Guide de visite avec navigation libre entre catégories
3. Catégories : Structure/Gros œuvre, Électricité, Plomberie, Division possible, Environnement/Extérieur, Notes libres
4. Pour chaque catégorie : questions guidées (réponses tap) → photos contextualisées → notes vocales/texte
5. Indicateur progression par catégorie (✓) + barre globale
6. Terminer la visite (possible même si catégories incomplètes — warning doux)
7. Sync auto au retour réseau → synthèse post-visite générée

**Principes :**
- Navigation libre : catégories accessibles dans n'importe quel ordre via tabs/chips scrollables
- Mode offline total : données stockées localement via WatermelonDB/expo-sqlite (mobile) + Dexie.js (web)
- Photos contextualisées : rattachées automatiquement à la catégorie + question en cours
- Pas de blocage : visite terminable même si incomplète
- Sauvegarde continue : chaque réponse/photo/note persistée immédiatement

### Parcours 3 : Consultation invité (lien partagé)

**Entrée :** Lien de partage généré par Michael

**Flow artisan :**
1. Ouverture lien → accès direct sans login (token URL)
2. Vue consultation restreinte : photos par zone, description travaux, contraintes chantier
3. Aucune donnée financière MDB visible
4. Soumission estimation/devis → notification à Michael

**Flow associé :**
1. Ouverture lien → login requis (Sanctum guest-read / guest-extended)
2. Vue étendue : Pipeline Kanban, fiches annonces filtrées, historique
3. Lecture seule, données de négociation masquées

**Principes :**
- Lien à durée limitée configurable
- Page "Lien expiré" si dépassé
- Zéro friction pour l'artisan (pas de compte)

### Parcours 4 : Associé — Consultation portfolio

**Entrée :** Invitation envoyée par Michael (guest-extended)

**Flow :**
1. Connexion avec compte invité étendu (Sanctum guest-extended)
2. Vue Pipeline Kanban avec projets en cours
3. Fiches annonces consultables (sans données de négociation)
4. Accès aux fiches mémo éducatives
5. Lecture seule — aucune modification possible

**Principes :**
- Transparence de la méthode de travail
- Données sensibles (négociation, marge réelle) masquées
- Confiance via la rigueur visible de l'approche

### Parcours 5 : Onboarding première utilisation (NOUVEAU)

**Entrée :** Première ouverture de l'app après création de compte

**Flow :**
1. Écran d'accueil personnalisé : "Bienvenue [Prénom] !"
2. **3 options de démarrage** présentées clairement :
   - 📎 "Coller un lien d'annonce" (action rapide)
   - ✏️ "Saisir une annonce manuellement"
   - 👀 "Explorer l'app d'abord"
3. Si "Explorer" → **tour guidé en 5 écrans** :
   - Pipeline Kanban ("Suivez vos opportunités")
   - Fiche annonce ("Centralisez les infos")
   - Guide de visite ("Ne ratez rien sur le terrain")
   - Fiches mémo ("Apprenez en pratiquant")
   - Score d'opportunité ("Décidez en confiance")
4. Fin du tour → retour à l'écran d'accueil avec options de création
5. Première fiche créée → **moment "aha!" onboarding** : "Votre première opportunité est enregistrée !"

**Principes :**
- Tour skippable à tout moment
- Progression par dots (5 étapes)
- Bouton "Passer" toujours visible
- Tour accessible plus tard depuis les paramètres

### Parcours 6 : Import dégradé — extraction partielle (NOUVEAU)

**Entrée :** Lien collé depuis un site moins bien supporté ou structure HTML modifiée

**Flow :**
1. Utilisateur colle un lien (PAP, particulier, site moins courant)
2. Écran de chargement : "Analyse de l'annonce..."
3. **Message positif** : "On a trouvé des infos ! Aide-nous à compléter."
4. Formulaire **pré-rempli partiellement** :
   - Champs extraits : affichés et éditables (ex: adresse, prix)
   - Champs manquants : vides avec placeholder indicatif
   - Photos : si non extraites, bouton "Ajouter depuis galerie"
5. Utilisateur complète les champs manquants
6. Validation → fiche créée normalement
7. Score d'opportunité calculé comme d'habitude

**Principes :**
- **Jamais de message d'erreur négatif** ("Échec d'extraction")
- Toujours montrer ce qui A été trouvé
- Complétion manuelle = 2 minutes max
- Si extraction totalement vide → fallback vers saisie manuelle complète avec message "Ce site n'est pas encore supporté, créons la fiche ensemble"

### Journey → Capabilities Mapping

| Journey | Capabilities |
|---------|-------------|
| **Parcours 1** — Happy Path | **Import via lien**, fiche annonce, DVF, score, Kanban, checklist, guide visite, synthèse, simulateur TVA, **fiches mémo contextuelles** |
| **Parcours 2** — Visite terrain | Guide visite offline, photos contextualisées, notes, sync auto |
| **Parcours 3** — Consultation invité | Partage lien public, vue consultation, photos par zone, soumission devis, **accès sans compte** |
| **Parcours 4** — Associé portfolio | Compte invité étendu, vue Kanban, fiches filtrées, **accès mémos** |
| **Parcours 5** — Onboarding | **Tour guidé, options démarrage, valeur immédiate** |
| **Parcours 6** — Import dégradé | **Extraction partielle, formulaire pré-rempli, récupération gracieuse** |

### Journey Patterns

**Navigation :**
- Progressive disclosure : informations complexes (DVF, score, synthèse) au bon moment du parcours
- Kanban comme fil rouge : le pipeline reflète automatiquement l'avancement sans saisie manuelle
- Offline-first transparent : l'utilisateur ne gère jamais la sync

**Feedback :**
- Score visuel : code couleur vert/orange/rouge avec valeur numérique
- Badges de complétion : ✓ par catégorie de visite, barre de progression globale
- Alertes contextuelles : red flags dans la synthèse, pas pendant la visite terrain

**Décision :**
- Jamais de choix bloquant : retour arrière ou report toujours possible
- Données d'aide à la décision : simulateur TVA, estimation travaux, comparatif DVF — jamais de recommandation automatique

### Flow Optimization Principles

- 3 taps maximum pour lancer une visite depuis le Dashboard
- 0 friction offline : aucun message d'erreur réseau pendant la visite terrain
- Sauvegarde continue : pas de bouton "Sauvegarder", persistance immédiate
- Retour au contexte : si l'app est fermée pendant une visite, reprise exacte à l'endroit d'arrêt

## Component Strategy

### Design System Components

| Composant M3 | Web (MUI) | Mobile (React Native Paper) |
|--------------|-----------|----------------------------|
| Navigation Bar | `BottomNavigation` | `BottomNavigation` |
| Navigation Rail | `Drawer` variant="permanent" | Custom Rail component |
| Top App Bar | `AppBar` | `Appbar` |
| Cards | `Card` | `Card` |
| FAB | `Fab` | `FAB` |
| Chips | `Chip` | `Chip` |
| Text Fields | `TextField` variant="outlined" | `TextInput` mode="outlined" |
| Buttons | `Button` variants | `Button` modes |
| Bottom Sheets | `SwipeableDrawer` anchor="bottom" | `@gorhom/bottom-sheet` |
| Dialogs | `Dialog` | `Dialog` |
| Snackbar | `Snackbar` | `Snackbar` |
| Progress | `CircularProgress`, `LinearProgress` | `ActivityIndicator`, `ProgressBar` |

### Custom Components

**ScoreCard** — Score d'opportunité (0-100) avec indication visuelle couleur (vert ≥70, orange 40-69, rouge <40). Variants : compact (liste) / expanded (fiche). Semantics : "Score d'opportunité : X sur 100".

**KanbanBoard + KanbanColumn + KanbanCard** — Pipeline visuel par statut (Nouveau, RDV, Visité, Offre, No Go, Archivé). Drag & drop pour changer statut. Vue alternative Liste groupée. Navigation clavier entre colonnes.

**VisitGuideCategory** — Catégorie navigable du guide de visite. Badge complétion (✓/en cours/vide) + compteur questions répondues. Chips scrollables horizontalement pour navigation libre.

**GuidedQuestion** — Question individuelle avec réponse rapide par tap (chips choix simple, slider échelle, texte libre, photo). Persistance immédiate. Alerte si réponse critique.

**PostVisitSummary** — Synthèse automatique post-visite : alertes (rouge/orange/vert), récap par catégorie, estimation travaux, marge prévisionnelle. Vue résumé / détaillée (expandable).

**DVFComparator** — Données DVF contextualisées : prix/m² annonce vs médiane quartier, transactions récentes. Inline (fiche) ou expanded (bottom sheet).

**OfflineSyncIndicator** — État connexion/sync discret dans top bar. Jamais bloquant, jamais intrusif pendant visite terrain. Snackbar "Sync terminée" au retour réseau.

**LinkImportInput** — Champ de saisie intelligent pour coller un lien d'annonce. Détecte automatiquement le site source (LeBonCoin, SeLoger, PAP, Logic-Immo, autre). Affiche un indicateur de parsing en cours. Variants : standalone (onboarding) / inline (formulaire création).
- États : Vide → Parsing → Succès complet / Succès partiel / Non supporté

**PartialImportForm** — Formulaire de création pré-rempli partiellement suite à une extraction incomplète. Champs extraits marqués visuellement (icône check discret). Champs manquants avec placeholder indicatif. Section photos avec option "Ajouter depuis galerie" si non extraites.

**OnboardingTour** — Overlay de tour guidé en 5 étapes. Navigation par swipe ou boutons Précédent/Suivant. Indicateur de progression (dots). Bouton "Passer" permanent. Highlight de la zone concernée avec fond semi-transparent.

**OnboardingWelcome** — Écran d'accueil première utilisation. Salutation personnalisée. 3 cartes d'action cliquables (Import lien / Saisie manuelle / Explorer). Illustration ou icône accueillante. Transition fluide vers l'action choisie.

**MemoSuggestionChip** — Chip contextuel suggérant une fiche mémo pertinente. Apparaît automatiquement selon le contexte (red flag détecté, étape fiscale, etc.). Tap → ouvre la fiche mémo en bottom sheet. Dismissable (swipe ou X).
- Variants : Info (bleu), Warning (orange), Tip (violet)

### Component Implementation Strategy

- Composants custom construits sur les tokens M3 : MUI theme tokens (web), Paper theme (mobile)
- **Partage de logique** : hooks et utilitaires partagés entre web et mobile via package commun
- **UI séparée** : composants de présentation distincts pour web (MUI) et mobile (Paper) — même API, rendu adapté
- Feature-specific : `src/features/<feature>/components/` (web) et `src/features/<feature>/components/` (mobile)
- Cross-feature : `src/shared/components/` (web) et `src/shared/components/` (mobile)
- Tests visuels : Storybook (web) + tests snapshot React Native Testing Library (mobile)

### Implementation Roadmap

- **Phase 1 (Epic 1-2)** : ScoreCard, KanbanBoard/Column/Card, OfflineSyncIndicator, **LinkImportInput**, **PartialImportForm**
- **Phase 1.5 (Epic 2)** : **OnboardingWelcome**, **OnboardingTour**
- **Phase 2 (Epic 3)** : VisitGuideCategory, GuidedQuestion, PostVisitSummary, **MemoSuggestionChip**
- **Phase 3 (Epic 4+)** : DVFComparator, simulateur TVA

## UX Consistency Patterns

### Button Hierarchy

| Niveau | Composant M3 | Usage | Exemple |
|---|---|---|---|
| Primary | Filled Button (accent) | Action principale unique par écran | "Lancer la visite", "Passer l'offre" |
| Secondary | Tonal Button | Action complémentaire | "Simuler TVA", "Voir DVF" |
| Tertiary | Outlined Button | Action alternative | "Modifier", "Partager" |
| Low emphasis | Text Button | Navigation, annulation | "Annuler", "Voir tout" |
| FAB | Extended FAB (accent) | Action globale de création | "+" (nouvelle annonce) |

Règles : 1 seul Filled Button par écran. FAB uniquement sur Dashboard et Pipeline. Arrondis pills pour tous les boutons.

### Feedback Patterns

| Situation | Pattern | Durée |
|---|---|---|
| Succès action (auth) | StatusBanner gradient (vert → violet) avec bordure inversée (violet → vert) | Persistant inline |
| Erreur action (auth) | StatusBanner gradient (rouge → violet) avec bordure inversée (violet → rouge) | Persistant inline |
| Succès action (général) | Snackbar vert | 3s auto-dismiss |
| Erreur utilisateur | Inline sous le champ (rouge + icône) | Persistant |
| Erreur système | Snackbar rouge + action "Réessayer" | 6s |
| Warning | StatusBanner gradient (orange → violet) avec bordure inversée | Persistant inline |
| Info contextuelle | Tooltip / Bottom sheet | Au tap |
| Sync offline | Icône discrète top bar (wifi/wifi_off) | Continu, jamais bloquant |
| Visite terrain | Aucune interruption (pas de snackbar/dialog) | — |

**StatusBanner** — Composant réutilisable avec :
- 4 types : success (vert), error (rouge), warning (orange), info (bleu)
- Background : dégradé semi-transparent de la couleur type → primary violet (35%→25% alpha)
- Bordure : dégradé inversé du primary violet → couleur type (50% alpha)
- Layout : icône + texte en Row, border-radius 8px, padding 12px
- Implémentation : `src/shared/components/StatusBanner` (web et mobile)

### Form Patterns

- Labels toujours fixes au-dessus du champ (jamais floating)
- Outlined text field, border-radius 12px
- Validation en temps réel après premier blur
- Erreurs : texte rouge sous le champ + bordure rouge
- Sections avec titre + divider entre groupes
- Sauvegarde automatique (brouillon) pour formulaires longs — pas de bouton "Sauvegarder"
- Actions : Filled Button en bas (sticky sur mobile), Tonal Button pour "Annuler"

### Navigation Patterns

| Contexte | Pattern |
|---|---|
| Mobile (<600dp) | Navigation Bar M3, 4 destinations, pill indicator 64×32px, icônes outlined/filled |
| Desktop/Tablet (≥600dp) | Navigation Rail M3, même 4 destinations + FAB intégré |
| Retour | Top App Bar back arrow en haut à gauche |
| Actions contextuelles | Top App Bar trailing icons (max 2 + more_vert overflow) |
| Sous-navigation | Chips scrollables horizontaux (catégories visite, filtres pipeline) |
| Vue toggle | Segmented Button (Kanban / Liste) |

Breakpoint : Layout responsive custom avec `useMediaQuery` — Navigation Bar < 600dp, Navigation Rail ≥ 600dp.

### Additional Patterns

**Empty States :**
- Dashboard vide : "Commencez par ajouter votre première annonce" + FAB pulsant
- Pipeline vide : "Votre pipeline est vide" + bouton créer
- Recherche sans résultat : "Aucun résultat" + suggestion alternative

**Loading States :**
- Skeleton screens pour les listes (cards placeholder animés)
- Circular progress centré pour calculs (score, synthèse)
- Linear progress en haut pour opérations longues (sync, export)
- Jamais de spinner bloquant : navigation toujours possible

**Modal & Overlay :**
- Bottom Sheet pour informations contextuelles (swipe down pour fermer)
- Dialog uniquement pour actions destructives (2 boutons max)
- Pas de modal plein écran : toujours une navigation de sortie visible

## Responsive Design & Accessibility

### Responsive Strategy

Mobile-first — l'usage terrain (visite) est la priorité n°1.

| Device | Largeur | Priorité | Layout |
|---|---|---|---|
| iPhone SE+ / Android | 360-599dp | Haute — terrain | Navigation Bar, contenu pleine largeur, FAB bottom-right |
| iPad / Tablet | 600-839dp | Moyenne — analyse | Navigation Rail, contenu élargi, cards 2 colonnes |
| Desktop Web | 840dp+ | Moyenne — bureau | Navigation Rail, layout 2-3 colonnes, panneau latéral activité |

Adaptations clés :
- Mobile : bottom sheets pour détails, scroll vertical unique, sticky buttons en bas
- Tablet : master-detail (liste + fiche côte à côte), guide visite split view
- Desktop : dashboard multi-colonnes, pipeline Kanban horizontal complet, panneau latéral permanent

### Breakpoint Strategy

Material 3 Window Size Classes :

| Classe | Largeur | Navigation | Layout |
|---|---|---|---|
| Compact | < 600dp | Navigation Bar | Single column |
| Medium | 600-839dp | Navigation Rail | Two columns |
| Expanded | ≥ 840dp | Navigation Rail | Three columns |

Implémentation via layout responsive custom avec Context provider et `useMediaQuery` (MUI) / `useWindowDimensions` (React Native). Standards M3, pas de breakpoints custom.

### Accessibility Strategy

**Niveau cible : WCAG 2.1 AA**

- Contraste texte normal ≥ 4.5:1, texte large et éléments interactifs ≥ 3:1 (Light et Dark Mode)
- Touch targets minimum 48×48dp, espacement minimum 8dp entre cibles adjacentes
- Accessibilité web : attributs `aria-*`, `role`, `tabIndex`, focus visible
- Accessibilité mobile : `accessibilityLabel`, `accessibilityRole`, `accessibilityHint` sur chaque composant custom
- Navigation clavier (Desktop/Web) : Tab entre éléments, focus visible, raccourcis (N = nouvelle fiche, / = recherche)
- Jamais d'information transmise uniquement par la couleur — icônes + texte accompagnent les codes couleur

### Testing Strategy

- Chrome DevTools : test des 3 window size classes
- Devices physiques : iPhone SE, iPhone 15, iPad Air, Pixel 7
- React Native Testing Library + `jest-axe` pour violations accessibilité
- VoiceOver (iOS) + TalkBack (Android) sur devices physiques
- Lighthouse Accessibility (Web) score cible ≥ 90
- axe DevTools extension pour audit WCAG web
- Simulateur daltonisme (protanopie, deutéranopie, tritanopie)

### Implementation Guidelines

- `useMediaQuery` (MUI) et `useWindowDimensions` (RN) pour adaptations responsive
- Layout responsive custom avec Context provider pour switch Navigation Bar ↔ Rail
- Accessibilité web : attributs `aria-*`, `role`, `tabIndex`, focus visible
- Accessibilité mobile : `accessibilityLabel`, `accessibilityRole`, `accessibilityHint` sur chaque composant custom
- Navigation clavier (web) : `tabIndex` et gestion focus logique
- Texte en `rem` (web) pour respect du facteur d'échelle navigateur
- `PixelRatio.getFontScale()` (mobile) pour adaptation taille texte système
- Images avec `alt` (web) et `accessibilityLabel` (mobile) descriptifs
- Animations réduites si `prefers-reduced-motion` (web) ou `AccessibilityInfo.isReduceMotionEnabled()` (mobile)

## Implementation Status

> **Pivot technologique — 2026-02-03**
>
> L'implémentation Flutter initiale (Epic 1) a été abandonnée au profit d'une stack React Native (mobile) + React (web). Le backend Laravel 12 + Sanctum reste inchangé.

### Stack technique révisée

| Composant | Technologie |
|-----------|-------------|
| Mobile | React Native + Expo |
| Web | React + Vite |
| UI Kit mobile | React Native Paper (Material 3) |
| UI Kit web | MUI (Material UI v5+) |
| State management | Zustand |
| Navigation mobile | React Navigation |
| Navigation web | React Router |
| Offline DB mobile | WatermelonDB ou expo-sqlite + SQLCipher |
| Offline DB web | Dexie.js (IndexedDB) |
| Backend | Laravel 12 + Sanctum (**inchangé**) |

### Design Tokens à implémenter

| Token | Web (MUI) | Mobile (Paper) |
|-------|-----------|----------------|
| Couleurs Light | `createTheme()` avec palette Violet/Magenta | `MD3LightTheme` custom |
| Couleurs Dark | `createTheme()` avec palette Indigo/Orchidée | `MD3DarkTheme` custom (bg: rgb(30,35,52)) |
| Typographie | `@fontsource/inter` | `expo-google-fonts/inter` |
| Spacing | Theme spacing scale (4-48px) | Theme spacing scale |
| Border radius | Theme shape (pills 24px, cards 16px, inputs 12px) | Theme roundness |

### Composants prioritaires (Phase 1)

| Composant | Status | Notes |
|-----------|--------|-------|
| Navigation responsive (Bar/Rail) | 🔲 À faire | useMediaQuery + Context |
| StatusBanner | 🔲 À faire | Dégradé type→violet + bordure inversée |
| LinkImportInput | 🔲 À faire | Nouveau — import via lien |
| PartialImportForm | 🔲 À faire | Nouveau — extraction partielle |
| OnboardingWelcome | 🔲 À faire | Nouveau — première utilisation |
| OnboardingTour | 🔲 À faire | Nouveau — tour guidé 5 étapes |
| ScoreCard | 🔲 À faire | Score d'opportunité |
| KanbanBoard | 🔲 À faire | Pipeline visuel |

### Référence visuelle

Le fichier de maquettes HTML reste valide pour la direction visuelle :
`_bmad-output/planning-artifacts/ux-design-directions.html`
