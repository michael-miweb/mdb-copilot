# Story 7.1 : Calcul et affichage du score d'opportunité

Status: ready-for-dev

## Story

As a utilisateur,
I want que le système calcule un score d'opportunité pour chaque annonce,
So that je priorise rapidement les meilleures opportunités.

## Acceptance Criteria

1. **Given** une fiche annonce avec prix, localisation et urgence renseignés
   **When** le système calcule le score d'opportunité
   **Then** un score est généré combinant : écart prix vs marché (DVF si disponible), urgence de vente, potentiel estimé
   **And** le score est affiché avec un code couleur (vert/orange/rouge)
   **And** si les données DVF ne sont pas disponibles, le score est calculé sans cette composante avec une mention "données marché non disponibles"

2. **Given** l'écran détail d'une fiche
   **When** l'utilisateur consulte le score
   **Then** les composantes du score sont détaillées : contribution prix/marché, contribution urgence, contribution potentiel
   **And** chaque composante est expliquée clairement

## Tasks / Subtasks

- [ ] Task 1 : Créer le modèle de données pour le score (AC: #1, #2)
  - [ ] 1.1 Créer le modèle Dart `OpportunityScore` dans `lib/features/scoring/data/models/`
  - [ ] 1.2 Définir les champs : property_id, overall_score (0-100), market_component, urgency_component, potential_component, calculated_at, dvf_available (bool)
  - [ ] 1.3 Ajouter factory fromJson/toJson
  - [ ] 1.4 Le score n'a pas de table Drift dédiée, il est calculé à la demande et peut être caché dans la fiche property (colonne JSON)

- [ ] Task 2 : Implémenter la logique de calcul côté client (AC: #1)
  - [ ] 2.1 Créer `ScoringService` dans `lib/features/scoring/data/`
  - [ ] 2.2 Implémenter la méthode `calculateScore(Property property, DvfData? dvfData)` qui retourne `OpportunityScore`
  - [ ] 2.3 Calcul de la composante marché (0-40 points) :
    - Si DVF disponible : comparer prix/m² de la fiche vs médiane DVF
    - Si prix < médiane DVF -20% → 40 pts
    - Si prix dans médiane ± 10% → 20 pts
    - Si prix > médiane DVF +20% → 0 pts
    - Si DVF indisponible : composante marché = 0, dvf_available = false
  - [ ] 2.4 Calcul de la composante urgence (0-30 points) :
    - Urgence élevée → 30 pts
    - Urgence moyenne → 15 pts
    - Urgence faible → 5 pts
    - Non renseigné → 0 pts
  - [ ] 2.5 Calcul de la composante potentiel (0-30 points) :
    - Basé sur les notes de l'utilisateur et les indicateurs dans la fiche (division possible, travaux légers, localisation attractive)
    - Potentiel élevé → 30 pts
    - Potentiel moyen → 15 pts
    - Potentiel faible → 5 pts
  - [ ] 2.6 Score global = market_component + urgency_component + potential_component (max 100)
  - [ ] 2.7 Tester le calcul avec différents scénarios (avec/sans DVF, urgences variables, potentiels différents)

- [ ] Task 3 : Implémenter la logique de calcul côté backend (AC: #1)
  - [ ] 3.1 Créer `ScoringService` dans `app/Services/` (Laravel)
  - [ ] 3.2 Créer `ScoringController` dans `app/Http/Controllers/Api/`
  - [ ] 3.3 Implémenter la route `POST /api/properties/{property}/score` qui :
    - Récupère la property
    - Interroge DvfService pour obtenir les données de marché si disponibles
    - Calcule le score avec la même logique que côté client
    - Retourne le score via `OpportunityScoreResource`
  - [ ] 3.4 Ajouter middleware `auth:sanctum` + vérification ownership
  - [ ] 3.5 Tester l'endpoint avec PHPUnit (Feature test)

- [ ] Task 4 : Créer le Repository Flutter (AC: #1)
  - [ ] 4.1 Créer `ScoringRepository` dans `lib/features/scoring/data/`
  - [ ] 4.2 Créer `ScoringRemoteSource` qui appelle `POST /api/properties/{property}/score`
  - [ ] 4.3 Implémenter `calculateScore(String propertyId)` qui :
    - Tente d'appeler le backend si connecté
    - Si offline ou backend indisponible, utilise le `ScoringService` client
  - [ ] 4.4 Cache le résultat dans la fiche property (colonne JSON) pour consultation offline
  - [ ] 4.5 Tester le Repository avec mocks

- [ ] Task 5 : Créer le Cubit de présentation (AC: #1, #2)
  - [ ] 5.1 Créer `ScoringCubit` dans `lib/features/scoring/presentation/cubit/`
  - [ ] 5.2 Définir les states : Initial, Loading, Loaded(score), Error(message)
  - [ ] 5.3 Implémenter la méthode `calculateScore(String propertyId)` qui appelle le Repository
  - [ ] 5.4 Implémenter `loadCachedScore(String propertyId)` pour consultation du score caché
  - [ ] 5.5 Tester le Cubit avec mocks

- [ ] Task 6 : Créer le widget de badge de score (AC: #1)
  - [ ] 6.1 Créer `ScoreBadgeWidget` dans `packages/mdb_ui/lib/widgets/`
  - [ ] 6.2 Afficher le score global (0-100) avec code couleur :
    - Vert si score >= 70
    - Orange si score 40-69
    - Rouge si score < 40
  - [ ] 6.3 Afficher une icône indicatrice (pouce vert/orange/rouge)
  - [ ] 6.4 Afficher "Données marché non disponibles" si dvf_available = false
  - [ ] 6.5 Widget tappable pour ouvrir le détail du score

- [ ] Task 7 : Créer l'écran de détail du score (AC: #2)
  - [ ] 7.1 Créer `ScoreDetailPage` dans `lib/features/scoring/presentation/pages/`
  - [ ] 7.2 Afficher le score global en grand avec code couleur
  - [ ] 7.3 Afficher les 3 composantes sous forme de barres de progression :
    - Marché : X/40 pts (ou "Non disponible")
    - Urgence : Y/30 pts
    - Potentiel : Z/30 pts
  - [ ] 7.4 Pour chaque composante, afficher une explication textuelle :
    - Marché : "Le prix est 15% sous la médiane du marché local" (si DVF dispo)
    - Urgence : "Vente urgente déclarée par le vendeur"
    - Potentiel : "Possibilité de division en 2 lots"
  - [ ] 7.5 Afficher la date de calcul
  - [ ] 7.6 Ajouter un bouton "Recalculer" qui déclenche `ScoringCubit.calculateScore`

- [ ] Task 8 : Intégrer le score dans la liste des fiches (AC: #1)
  - [ ] 8.1 Ajouter le `ScoreBadgeWidget` dans la carte de chaque fiche (PropertyCard)
  - [ ] 8.2 Afficher le score en haut à droite de la carte
  - [ ] 8.3 Au tap sur le badge, naviguer vers `ScoreDetailPage`
  - [ ] 8.4 Si le score n'est pas calculé, afficher "Calculer le score" au lieu du badge

- [ ] Task 9 : Intégrer le score dans le détail de la fiche (AC: #2)
  - [ ] 9.1 Ajouter une section "Score d'opportunité" dans `PropertyDetailPage`
  - [ ] 9.2 Afficher le `ScoreBadgeWidget` avec le score actuel
  - [ ] 9.3 Ajouter un bouton "Voir le détail du score" qui navigue vers `ScoreDetailPage`
  - [ ] 9.4 Si pas de score, afficher un bouton "Calculer le score"

- [ ] Task 10 : Gérer le fallback sans DVF (AC: #1)
  - [ ] 10.1 Si `DvfService` retourne une erreur ou aucune donnée
  - [ ] 10.2 Le score est calculé avec market_component = 0
  - [ ] 10.3 Afficher clairement "Données marché non disponibles" dans le badge et le détail
  - [ ] 10.4 Expliquer que le score est partiel (urgence + potentiel seulement)
  - [ ] 10.5 Tester le comportement avec DVF indisponible

- [ ] Task 11 : Tests d'intégration (AC: #1, #2)
  - [ ] 11.1 Tester le calcul de score avec DVF disponible
  - [ ] 11.2 Tester le calcul de score sans DVF (fallback)
  - [ ] 11.3 Tester l'affichage du badge dans la liste des fiches
  - [ ] 11.4 Tester l'affichage du détail du score avec explications
  - [ ] 11.5 Tester le recalcul du score après modification de la fiche
  - [ ] 11.6 Tester le cache offline du score

- [ ] Task 12 : Validation finale (AC: #1, #2)
  - [ ] 12.1 Vérifier que le score combine bien les 3 composantes (marché, urgence, potentiel)
  - [ ] 12.2 Vérifier le code couleur vert/orange/rouge selon le score
  - [ ] 12.3 Vérifier le fallback "données marché non disponibles" si DVF indisponible
  - [ ] 12.4 Vérifier que les composantes sont détaillées et expliquées
  - [ ] 12.5 Vérifier que le score est calculable offline avec le client
  - [ ] 12.6 Commit backend : `git add . && git commit -m "feat(api): scoring service et endpoint calcul score"`
  - [ ] 12.7 Commit frontend : `git add . && git commit -m "feat: calcul et affichage score opportunité avec détail composantes"`

## Dev Notes

### Architecture & Contraintes

- **Logique hybride client/serveur** : Le score peut être calculé côté client (offline) ou côté serveur (avec accès DVF frais). Le Repository Flutter gère le fallback [Source: architecture.md#Requirements → Structure Mapping, ligne "Score d'opportunité : scoring/ + backend ScoringService/ScoringController"]
- **Dépendance DVF** : Le calcul de la composante marché nécessite les données DVF. Si DVF indisponible, la composante marché vaut 0 et le score est partiel [Source: epics.md#Story 7.1, AC#1]
- **Cache dans property** : Le score calculé est caché dans la fiche property (colonne JSON) pour consultation offline ultérieure [Source: architecture.md#Data Architecture]
- **Backend ScoringService** : Le service Laravel interroge `DvfService` pour obtenir les données de marché, puis calcule le score [Source: architecture.md#Requirements → Structure Mapping]
- **Code couleur** : Vert >= 70, Orange 40-69, Rouge < 40 [Source: epics.md#Story 7.1, AC#1]

### Formule de calcul détaillée

**Composante marché (0-40 points) :**

```dart
// Comparaison prix/m² fiche vs médiane DVF
double pricePerSqm = property.priceCents / property.surfaceSqm;
double medianDvf = dvfData.medianPricePerSqm;
double deviation = (pricePerSqm - medianDvf) / medianDvf;

int marketScore;
if (deviation <= -0.20) {
  marketScore = 40;  // 20% sous le marché
} else if (deviation <= -0.10) {
  marketScore = 30;  // 10% sous le marché
} else if (deviation <= 0.10) {
  marketScore = 20;  // Dans la moyenne
} else if (deviation <= 0.20) {
  marketScore = 10;  // 10% au-dessus
} else {
  marketScore = 0;   // 20%+ au-dessus
}
```

**Composante urgence (0-30 points) :**

```dart
int urgencyScore;
switch (property.saleUrgency) {
  case SaleUrgency.high:
    urgencyScore = 30;
    break;
  case SaleUrgency.medium:
    urgencyScore = 15;
    break;
  case SaleUrgency.low:
    urgencyScore = 5;
    break;
  default:
    urgencyScore = 0;
}
```

**Composante potentiel (0-30 points) :**

```dart
// Analyse des indicateurs dans les notes de la fiche
int potentialScore = 0;

if (property.notes.contains('division possible')) potentialScore += 10;
if (property.notes.contains('travaux légers')) potentialScore += 10;
if (property.notes.contains('localisation attractive')) potentialScore += 10;

// Limiter à 30 max
potentialScore = min(potentialScore, 30);
```

### Structure API Laravel

**Endpoint :**

```
POST /api/properties/{property}/score
Authorization: Bearer {token}

Response 200:
{
  "data": {
    "property_id": "uuid",
    "overall_score": 75,
    "market_component": 30,
    "urgency_component": 30,
    "potential_component": 15,
    "calculated_at": "2026-01-27T14:30:00Z",
    "dvf_available": true,
    "explanations": {
      "market": "Le prix est 12% sous la médiane du marché local (2500€/m² vs 2850€/m²)",
      "urgency": "Vente urgente déclarée",
      "potential": "Possibilité de division en 2 lots"
    }
  }
}
```

**ScoringService Laravel :**

```php
class ScoringService
{
    public function __construct(private DvfService $dvfService) {}

    public function calculateScore(Property $property): array
    {
        $dvfData = $this->dvfService->getDataForProperty($property);

        $marketScore = $this->calculateMarketComponent($property, $dvfData);
        $urgencyScore = $this->calculateUrgencyComponent($property);
        $potentialScore = $this->calculatePotentialComponent($property);

        return [
            'overall_score' => $marketScore + $urgencyScore + $potentialScore,
            'market_component' => $marketScore,
            'urgency_component' => $urgencyScore,
            'potential_component' => $potentialScore,
            'dvf_available' => $dvfData !== null,
            'calculated_at' => now()->toIso8601String(),
        ];
    }
}
```

### Project Structure Notes

Structure cible après cette story :

```
mobile-app/
├── lib/
│   ├── features/
│   │   └── scoring/                          # Nouvelle feature
│   │       ├── data/
│   │       │   ├── scoring_repository.dart
│   │       │   ├── scoring_remote_source.dart
│   │       │   ├── scoring_service.dart      # Calcul client
│   │       │   └── models/
│   │       │       └── opportunity_score_model.dart
│   │       └── presentation/
│   │           ├── cubit/
│   │           │   ├── scoring_cubit.dart
│   │           │   └── scoring_state.dart
│   │           ├── pages/
│   │           │   └── score_detail_page.dart
│   │           └── widgets/
│   │               └── score_explanation_card.dart
│   └── packages/
│       └── mdb_ui/
│           └── widgets/
│               └── mdb_score_badge.dart      # Nouveau widget réutilisable
└── test/
    └── features/
        └── scoring/
            ├── data/
            │   ├── scoring_repository_test.dart
            │   └── scoring_service_test.dart
            └── presentation/
                └── cubit/
                    └── scoring_cubit_test.dart

backend-api/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       └── ScoringController.php      # Nouveau
│   │   └── Resources/
│   │       └── OpportunityScoreResource.php   # Nouveau
│   └── Services/
│       └── ScoringService.php                 # Nouveau
└── tests/
    └── Feature/
        └── Scoring/
            └── CalculateScoreTest.php          # Nouveau
```

### References

- [Source: epics.md#Epic 7 : Score d'Opportunité] — Description fonctionnelle complète
- [Source: epics.md#Story 7.1] — Acceptance criteria BDD, calcul score combinant 3 composantes
- [Source: architecture.md#Requirements → Structure Mapping] — Scoring avec backend ScoringService/ScoringController
- [Source: architecture.md#Frontend Architecture] — Repository pattern, Bloc/Cubit
- [Source: architecture.md#API & Communication Patterns] — REST JSON, validation, erreurs standard
- [Source: architecture.md#Implementation Patterns & Consistency Rules] — Naming conventions
- [Source: epics.md#Story 9.1] — Intégration DVF pour données marché

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
