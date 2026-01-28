# Story 6.2 : Alertes et estimation de marge

Status: ready-for-dev

## Story

As a utilisateur,
I want voir les alertes sur les points critiques et une estimation de marge prévisionnelle,
So that je prends une décision Go/No Go éclairée.

## Acceptance Criteria

1. **Given** une synthèse post-visite générée
   **When** l'utilisateur consulte la synthèse
   **Then** les alertes rouges sont affichées en priorité (problèmes structurels, amiante, électricité vétuste, etc.)
   **And** le nombre d'alertes par sévérité est résumé (critique, attention, info)

2. **Given** une synthèse avec les données financières de la fiche
   **When** le système calcule la marge prévisionnelle
   **Then** une estimation est affichée : prix achat + travaux estimés vs prix de revente estimé
   **And** la marge est affichée en euros et en pourcentage

3. **Given** la synthèse complète (alertes + marge)
   **When** l'utilisateur consulte le verdict
   **Then** un indicateur visuel Go/No Go est affiché basé sur les alertes et la marge
   **And** l'utilisateur peut marquer sa décision (Go, No Go, À approfondir)

## Tasks / Subtasks

- [ ] Task 1 : Enrichir le modèle de synthèse avec alertes et marge (AC: #1, #2, #3)
  - [ ] 1.1 Ajouter au modèle `PostVisitSummary` les champs : alerts (liste), margin_estimate (objet), user_decision (enum)
  - [ ] 1.2 Définir l'enum `UserDecision` : go, noGo, toInvestigate, notSet
  - [ ] 1.3 Mettre à jour le schema Drift `post_visit_summaries_table.dart` avec colonnes JSON alerts et margin_estimate
  - [ ] 1.4 Ajouter user_decision (string nullable) dans la table Drift

- [ ] Task 2 : Implémenter la détection d'alertes (AC: #1)
  - [ ] 2.1 Créer `AlertDetectionService` dans `lib/features/post_visit_summary/data/`
  - [ ] 2.2 Définir les règles de détection par catégorie :
    - Structurel : fissures importantes, affaissement, humidité sévère → critique
    - Amiante : présence détectée ou suspectée → critique
    - Électricité : tableau vétuste, absence de terre → critique
    - Plomberie : fuites importantes, canalisation plomb → attention
    - Toiture : infiltrations, tuiles cassées → attention
  - [ ] 2.3 Implémenter la méthode `detectAlerts(VisitGuideResponses responses)` retournant List<Alert>
  - [ ] 2.4 Chaque Alert contient : severity (critique/attention/info), category, title, description
  - [ ] 2.5 Tester la détection avec différents jeux de réponses

- [ ] Task 3 : Implémenter le calcul de marge prévisionnelle (AC: #2)
  - [ ] 3.1 Créer `MarginEstimationService` dans `lib/features/post_visit_summary/data/`
  - [ ] 3.2 Implémenter `calculateMargin(Property property, List<Alert> alerts)` qui :
    - Récupère le prix d'achat depuis la fiche property
    - Estime les travaux en fonction des alertes détectées (montants forfaitaires par type d'alerte)
    - Récupère le prix de revente estimé (saisi par l'utilisateur ou estimé via DVF si disponible)
    - Calcule : marge = prix_revente - (prix_achat + travaux_estimes)
    - Calcule : marge_percent = (marge / prix_achat) * 100
  - [ ] 3.3 Retourner un objet `MarginEstimate` avec purchase_price, estimated_work, resale_price, margin, margin_percent
  - [ ] 3.4 Tester le calcul avec différents scénarios (avec/sans travaux, avec/sans prix revente)

- [ ] Task 4 : Calculer le verdict Go/No Go automatique (AC: #3)
  - [ ] 4.1 Créer `VerdictService` dans `lib/features/post_visit_summary/data/`
  - [ ] 4.2 Implémenter `calculateVerdict(List<Alert> alerts, MarginEstimate margin)` qui retourne un enum `Verdict` : go, noGo, toInvestigate
  - [ ] 4.3 Règles de verdict :
    - Si alertes critiques >= 3 OU marge < 5% → noGo
    - Si alertes critiques 1-2 OU marge 5-15% → toInvestigate
    - Si alertes critiques 0 ET marge >= 15% → go
  - [ ] 4.4 Tester les règles de verdict

- [ ] Task 5 : Mettre à jour PostVisitSummaryService (AC: #1, #2, #3)
  - [ ] 5.1 Modifier la méthode `generateSummary` pour appeler `AlertDetectionService`
  - [ ] 5.2 Modifier la méthode `generateSummary` pour appeler `MarginEstimationService`
  - [ ] 5.3 Modifier la méthode `generateSummary` pour appeler `VerdictService`
  - [ ] 5.4 Stocker alerts, margin_estimate et calculated_verdict dans summary_data JSON
  - [ ] 5.5 Tester la génération complète avec alertes + marge + verdict

- [ ] Task 6 : Créer les widgets d'affichage des alertes (AC: #1)
  - [ ] 6.1 Créer `AlertListWidget` dans `lib/features/post_visit_summary/presentation/widgets/`
  - [ ] 6.2 Afficher les alertes critiques en priorité avec icône rouge + titre + description
  - [ ] 6.3 Afficher les alertes "attention" avec icône orange
  - [ ] 6.4 Afficher les alertes "info" avec icône bleue
  - [ ] 6.5 Afficher un résumé en haut : "3 alertes critiques, 5 alertes attention, 2 infos"
  - [ ] 6.6 Rendre les alertes expandables pour voir la description complète

- [ ] Task 7 : Créer le widget d'affichage de la marge (AC: #2)
  - [ ] 7.1 Créer `MarginEstimateWidget` dans `lib/features/post_visit_summary/presentation/widgets/`
  - [ ] 7.2 Afficher le détail du calcul :
    - Prix achat : X €
    - Travaux estimés : Y €
    - Prix de revente estimé : Z €
    - Marge prévisionnelle : M € (P%)
  - [ ] 7.3 Code couleur pour la marge : vert si >= 15%, orange si 5-15%, rouge si < 5%
  - [ ] 7.4 Afficher un disclaimer : "Estimation indicative, à affiner avec devis réels"

- [ ] Task 8 : Créer le widget de verdict et décision utilisateur (AC: #3)
  - [ ] 8.1 Créer `VerdictWidget` dans `lib/features/post_visit_summary/presentation/widgets/`
  - [ ] 8.2 Afficher le verdict calculé avec icône visuelle (pouce vert/rouge/orange)
  - [ ] 8.3 Afficher 3 boutons pour la décision utilisateur : "Go", "No Go", "À approfondir"
  - [ ] 8.4 Mettre en surbrillance le bouton correspondant à la décision de l'utilisateur si déjà marquée
  - [ ] 8.5 Au clic sur un bouton, appeler `PostVisitSummaryCubit.markDecision(UserDecision decision)`

- [ ] Task 9 : Mettre à jour le Cubit (AC: #3)
  - [ ] 9.1 Ajouter la méthode `markDecision(String summaryId, UserDecision decision)` dans `PostVisitSummaryCubit`
  - [ ] 9.2 Mettre à jour la synthèse via le Repository
  - [ ] 9.3 Mettre à jour le state avec la nouvelle décision
  - [ ] 9.4 Tester la persistance de la décision

- [ ] Task 10 : Intégrer les widgets dans PostVisitSummaryPage (AC: #1, #2, #3)
  - [ ] 10.1 Ajouter une section "Alertes" avec `AlertListWidget`
  - [ ] 10.2 Ajouter une section "Estimation de marge" avec `MarginEstimateWidget`
  - [ ] 10.3 Ajouter une section "Verdict" avec `VerdictWidget`
  - [ ] 10.4 Organiser les sections avec des cartes et espacement cohérent
  - [ ] 10.5 Gérer l'état de chargement pendant le calcul

- [ ] Task 11 : Tests d'intégration (AC: #1, #2, #3)
  - [ ] 11.1 Tester l'affichage des alertes avec différents niveaux de sévérité
  - [ ] 11.2 Tester le calcul de marge avec différents scénarios (prix saisis, travaux variables)
  - [ ] 11.3 Tester le verdict automatique selon les règles
  - [ ] 11.4 Tester la persistance de la décision utilisateur
  - [ ] 11.5 Tester le flow complet : génération synthèse → alertes → marge → verdict → décision

- [ ] Task 12 : Validation finale (AC: #1, #2, #3)
  - [ ] 12.1 Vérifier que les alertes rouges sont affichées en priorité
  - [ ] 12.2 Vérifier que le résumé par sévérité est correct
  - [ ] 12.3 Vérifier que la marge est calculée et affichée en € et %
  - [ ] 12.4 Vérifier que le verdict Go/No Go est affiché avec indicateur visuel
  - [ ] 12.5 Vérifier que l'utilisateur peut marquer sa décision et qu'elle persiste
  - [ ] 12.6 Commit : `git add . && git commit -m "feat: alertes, marge et verdict Go/No Go dans synthèse post-visite"`

## Dev Notes

### Architecture & Contraintes

- **Dépend de Story 6.1** : Cette story enrichit la synthèse post-visite créée dans la Story 6.1. Elle nécessite le modèle `PostVisitSummary` et le `PostVisitSummaryService` existants
- **Client-only logic** : Toute la logique (détection alertes, calcul marge, verdict) se fait côté client Flutter, sans appel backend [Source: architecture.md#Requirements → Structure Mapping]
- **Drift storage** : Les alertes, margin_estimate et user_decision sont stockés dans la table Drift existante `post_visit_summaries` [Source: architecture.md#Data Architecture]
- **Alertes prioritaires** : Les alertes critiques (structurel, amiante, électricité) doivent être affichées en priorité dans l'UI [Source: epics.md#Story 6.2, AC#1]
- **Estimation de marge** : Utilise les données financières de la fiche property + estimation forfaitaire des travaux basée sur les alertes [Source: epics.md#Story 6.2, AC#2]
- **Montants en centimes** : Les prix (achat, travaux, revente, marge) sont stockés en centimes integer dans la DB et convertis en euros pour l'affichage [Source: architecture.md#Format Patterns, ligne "Monnaie : integer centimes"]

### Règles de détection des alertes

Mapping catégorie → type d'alerte :

| Catégorie | Déclencheur alerte critique | Déclencheur alerte attention |
|-----------|----------------------------|------------------------------|
| Structure | Fissures importantes, affaissement, humidité sévère | Fissures mineures, humidité localisée |
| Amiante | Présence confirmée ou suspectée | Matériaux à risque à vérifier |
| Électricité | Tableau non aux normes, absence de terre | Prises défectueuses, câblage apparent |
| Plomberie | Fuites importantes, canalisation plomb | Fuites mineures, robinetterie usée |
| Toiture | Infiltrations actives, charpente endommagée | Tuiles cassées, gouttières bouchées |

### Règles de calcul de la marge

```dart
// Estimation forfaitaire des travaux en fonction des alertes
Map<AlertSeverity, int> workCostByAlert = {
  AlertSeverity.critique: 5000_00,  // 5000€ en centimes
  AlertSeverity.attention: 1500_00,  // 1500€ en centimes
  AlertSeverity.info: 500_00,        // 500€ en centimes
};

int estimatedWork = alerts.fold(0, (sum, alert) => sum + workCostByAlert[alert.severity]!);

// Calcul marge
int margin = resalePrice - (purchasePrice + estimatedWork);
double marginPercent = (margin / purchasePrice) * 100;
```

### Structure de alerts JSON

```json
{
  "alerts": [
    {
      "severity": "critique",
      "category": "electricite",
      "title": "Tableau électrique vétuste",
      "description": "Le tableau n'est pas aux normes, absence de terre sur plusieurs prises."
    },
    {
      "severity": "attention",
      "category": "toiture",
      "title": "Tuiles cassées",
      "description": "5 tuiles cassées sur la façade sud, risque d'infiltration."
    }
  ]
}
```

### Structure de margin_estimate JSON

```json
{
  "purchase_price_cents": 150000_00,
  "estimated_work_cents": 25000_00,
  "resale_price_cents": 200000_00,
  "margin_cents": 25000_00,
  "margin_percent": 16.67,
  "calculated_at": "2026-01-27T14:30:00Z"
}
```

### Project Structure Notes

Structure enrichie après cette story :

```
mobile-app/
├── lib/
│   ├── features/
│   │   └── post_visit_summary/
│   │       ├── data/
│   │       │   ├── alert_detection_service.dart      # Nouveau
│   │       │   ├── margin_estimation_service.dart    # Nouveau
│   │       │   ├── verdict_service.dart              # Nouveau
│   │       │   └── models/
│   │       │       ├── alert_model.dart              # Nouveau
│   │       │       ├── margin_estimate_model.dart    # Nouveau
│   │       │       └── verdict_model.dart            # Nouveau
│   │       └── presentation/
│   │           ├── cubit/
│   │           │   └── post_visit_summary_cubit.dart # Modifié
│   │           └── widgets/
│   │               ├── alert_list_widget.dart        # Nouveau
│   │               ├── margin_estimate_widget.dart   # Nouveau
│   │               └── verdict_widget.dart           # Nouveau
└── test/
    └── features/
        └── post_visit_summary/
            └── data/
                ├── alert_detection_service_test.dart
                ├── margin_estimation_service_test.dart
                └── verdict_service_test.dart
```

### References

- [Source: epics.md#Epic 6 : Synthèse Post-visite] — Description fonctionnelle complète
- [Source: epics.md#Story 6.2] — Acceptance criteria BDD, alertes + marge + verdict
- [Source: architecture.md#Format Patterns] — Monnaie en centimes integer
- [Source: architecture.md#Frontend Architecture] — Repository pattern, Bloc/Cubit
- [Source: architecture.md#Implementation Patterns & Consistency Rules] — Naming conventions Dart
- [Source: architecture.md#Requirements → Structure Mapping] — Synthèse post-visite est client-only

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
