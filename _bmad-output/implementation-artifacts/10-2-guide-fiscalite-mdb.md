# Story 10.2 : Guide fiscalité MDB

Status: ready-for-dev

## Story

As a utilisateur débutant MDB,
I want consulter les règles fiscales applicables aux marchands de biens,
So that je comprends les implications fiscales de mes opérations.

## Acceptance Criteria

1. **Given** l'écran Guide Fiscalité
   **When** l'utilisateur consulte les règles TVA
   **Then** les règles TVA sur marge et TVA sur total sont expliquées clairement
   **And** des exemples chiffrés illustrent chaque cas

2. **Given** l'écran Guide Fiscalité
   **When** l'utilisateur consulte la section plus-value professionnelle
   **Then** les règles de calcul et d'imposition sont détaillées
   **And** les différents régimes d'imposition applicables sont listés avec leurs conditions

3. **Given** une fiche annonce avec une date d'achat
   **When** le système vérifie les délais de revente
   **Then** une alerte est affichée si un délai fiscal approche (ex: délai de revente pour exonération)
   **And** l'alerte précise le délai restant et les conséquences fiscales

## Tasks / Subtasks

- [ ] Task 1 : Créer la feature `tax_guide` côté client (AC: #1, #2, #3)
  - [ ] 1.1 Créer `lib/features/tax_guide/` avec structure data/presentation
  - [ ] 1.2 Créer `TaxGuidePage` avec navigation par section
  - [ ] 1.3 Créer `TaxGuideCubit` pour gérer l'état de navigation
  - [ ] 1.4 Créer `TaxGuideState` avec états Initial/Loaded/Error

- [ ] Task 2 : Structurer le contenu fiscal (AC: #1, #2)
  - [ ] 2.1 Créer modèle `TaxGuideSection` (titre, contenu, exemples)
  - [ ] 2.2 Créer modèle `TaxGuideExample` (description, calcul, résultat)
  - [ ] 2.3 Définir contenu JSON pour section "TVA sur marge vs TVA sur total"
  - [ ] 2.4 Définir contenu JSON pour section "Plus-value professionnelle"
  - [ ] 2.5 Définir contenu JSON pour section "Régimes d'imposition" (BIC, IS, micro-BIC)
  - [ ] 2.6 Stocker contenu dans `assets/tax_guide/` en JSON

- [ ] Task 3 : Créer le repository contenu (AC: #1, #2)
  - [ ] 3.1 Créer `TaxGuideRepository` dans `data/`
  - [ ] 3.2 Méthode `loadSections()` charge le JSON depuis assets
  - [ ] 3.3 Parser JSON vers modèles `TaxGuideSection`
  - [ ] 3.4 Retourner liste de sections ordonnées
  - [ ] 3.5 Gérer erreurs de chargement (fichier manquant)

- [ ] Task 4 : Implémenter les alertes délais de revente (AC: #3)
  - [ ] 4.1 Créer `TaxDeadlineService` dans `data/services/`
  - [ ] 4.2 Méthode `checkResaleDeadline(purchaseDate)` calcule délais fiscaux
  - [ ] 4.3 Retourner objet `TaxDeadlineAlert` (type, délai restant, description)
  - [ ] 4.4 Définir règles fiscales (ex: 5 ans pour exonération plus-value)
  - [ ] 4.5 Intégrer appel depuis feature `properties` (affichage dans détail fiche)

- [ ] Task 5 : Créer l'interface utilisateur (AC: #1, #2, #3)
  - [ ] 5.1 Design page avec liste des sections fiscales
  - [ ] 5.2 Page détail section avec texte explicatif structuré
  - [ ] 5.3 Widget `TaxExampleCard` pour afficher exemples chiffrés
  - [ ] 5.4 Widget `TaxDeadlineAlert` pour afficher alertes avec code couleur (rouge/orange/vert)
  - [ ] 5.5 Navigation tap sur section → page détail
  - [ ] 5.6 Permettre recherche texte dans le contenu

- [ ] Task 6 : Contenu rédactionnel fiscal (AC: #1, #2)
  - [ ] 6.1 Rédiger section "TVA sur marge" avec règles et exemples
  - [ ] 6.2 Rédiger section "TVA sur total" avec règles et exemples
  - [ ] 6.3 Rédiger section "Plus-value professionnelle" avec règles de calcul
  - [ ] 6.4 Rédiger section "Régimes d'imposition" (BIC réel, BIC simplifié, IS, micro-BIC)
  - [ ] 6.5 Rédiger section "Délais de revente" avec implications fiscales
  - [ ] 6.6 Valider contenu avec expert fiscal (si disponible)

- [ ] Task 7 : Tests et validation (AC: #1, #2, #3)
  - [ ] 7.1 Tester `TaxGuideRepository.loadSections()` charge bien le JSON
  - [ ] 7.2 Tester parsing JSON vers modèles
  - [ ] 7.3 Tester `TaxDeadlineService.checkResaleDeadline()` avec dates variées
  - [ ] 7.4 Tester affichage alertes dans UI
  - [ ] 7.5 Vérifier accessibilité contenu sans connexion (offline)

## Dev Notes

### Architecture & Contraintes

- **Client-only feature** : Contenu statique embarqué, aucune API backend [Source: architecture.md#Requirements → Structure Mapping]
- **Contenu statique** : Fichiers JSON dans `assets/tax_guide/`, chargés au démarrage de la feature [Source: architecture.md#Cross-Cutting Concerns]
- **Offline-first** : Tout le contenu accessible sans connexion une fois l'app installée [Source: architecture.md#NFRs]
- **Cubit pattern** : `TaxGuideCubit` gère navigation et état de chargement [Source: architecture.md#Communication Patterns]

### Structure contenu JSON

**Format `assets/tax_guide/sections.json` :**

```json
{
  "sections": [
    {
      "id": "tva-marge",
      "title": "TVA sur marge",
      "content": "La TVA sur marge s'applique...",
      "examples": [
        {
          "description": "Achat 100k€, travaux 30k€, revente 180k€",
          "calculation": "Base TVA = 180k - (100k + 30k) = 50k\nTVA due = 50k * 20% = 10k€",
          "result": "TVA due : 10 000 €"
        }
      ]
    },
    {
      "id": "plus-value",
      "title": "Plus-value professionnelle",
      "content": "La plus-value professionnelle...",
      "examples": []
    }
  ]
}
```

### Règles fiscales délais de revente

- **Moins de 5 ans** : Plus-value professionnelle imposée au barème progressif IR + cotisations sociales
- **5-22 ans** : Abattement progressif pour durée de détention
- **Plus de 22 ans** : Exonération totale de la plus-value (hors prélèvements sociaux)

*Note : Ces règles sont indicatives et doivent être validées avec un expert fiscal.*

### Versions techniques confirmées

- **Flutter** : 3.38.x
- **Pas de dépendance externe** pour le contenu statique

### Structure cible

```
lib/features/tax_guide/
├── data/
│   ├── models/
│   │   ├── tax_guide_section.dart
│   │   ├── tax_guide_example.dart
│   │   └── tax_deadline_alert.dart
│   ├── repositories/
│   │   └── tax_guide_repository.dart
│   └── services/
│       └── tax_deadline_service.dart
└── presentation/
    ├── cubit/
    │   ├── tax_guide_cubit.dart
    │   └── tax_guide_state.dart
    ├── pages/
    │   ├── tax_guide_page.dart
    │   └── tax_section_detail_page.dart
    └── widgets/
        ├── tax_section_card.dart
        ├── tax_example_card.dart
        └── tax_deadline_alert.dart

assets/tax_guide/
└── sections.json
```

### Project Structure Notes

Cette story ajoute une nouvelle feature dans `mobile-app/lib/features/tax_guide/`. La feature charge du contenu statique depuis `assets/` et ne nécessite aucune synchronisation ou API backend.

- Pas de table Drift nécessaire (contenu statique en JSON)
- Pas de controller Laravel nécessaire
- Le widget `TaxDeadlineAlert` sera réutilisé dans `features/properties/` pour afficher les alertes sur les fiches annonces

### References

- [Source: epics.md#Story 10.2] — Acceptance criteria BDD
- [Source: architecture.md#Requirements → Structure Mapping] — Feature client-only
- [Source: architecture.md#Cross-Cutting Concerns] — Contenu statique
- [Source: architecture.md#Frontend Architecture] — folder-by-feature VGV
- [Source: architecture.md#NFRs] — Offline-first

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
