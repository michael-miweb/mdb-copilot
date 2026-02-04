# Story 10.1 : Simulateur TVA sur marge

Status: ready-for-dev

## Story

As a utilisateur,
I want saisir les paramètres d'une opération et simuler la TVA sur marge,
So that je maîtrise l'impact fiscal avant de faire une offre.

## Acceptance Criteria

1. **Given** l'écran simulateur TVA
   **When** l'utilisateur saisit : prix d'achat, montant travaux, frais (notaire, agence)
   **Then** le système calcule automatiquement la base TVA et la TVA due à la revente
   **And** le calcul distingue TVA sur marge vs TVA sur total

2. **Given** les paramètres saisis
   **When** l'utilisateur modifie le prix de revente
   **Then** le calcul se met à jour en temps réel
   **And** la marge nette après TVA est affichée

3. **Given** le simulateur
   **When** l'utilisateur teste différents scénarios de prix de revente
   **Then** il peut comparer les résultats côte à côte ou en séquence
   **And** chaque scénario affiche : prix revente, TVA due, marge nette

## Tasks / Subtasks

- [ ] Task 1 : Créer la feature `vat_simulator` côté client (AC: #1, #2, #3)
  - [ ] 1.1 Créer `lib/features/vat_simulator/` avec structure data/presentation
  - [ ] 1.2 Créer `VatSimulatorPage` avec formulaire de saisie (prix achat, travaux, frais)
  - [ ] 1.3 Créer `VatSimulatorCubit` pour gérer l'état du simulateur
  - [ ] 1.4 Créer `VatSimulatorState` avec états Initial/Loaded/Error

- [ ] Task 2 : Implémenter la logique de calcul TVA (AC: #1)
  - [ ] 2.1 Créer `VatCalculator` service dans `data/services/`
  - [ ] 2.2 Implémenter méthode `calculateVatOnMargin(purchasePrice, works, fees, salePrice)`
  - [ ] 2.3 Implémenter méthode `calculateVatOnTotal(salePrice)`
  - [ ] 2.4 Retourner objet `VatCalculation` avec base TVA, TVA due, marge nette
  - [ ] 2.5 Utiliser montants en centimes (integer) pour tous les calculs

- [ ] Task 3 : Implémenter la mise à jour en temps réel (AC: #2)
  - [ ] 3.1 Ajouter `TextEditingController` pour champ prix de revente
  - [ ] 3.2 Ajouter listener sur changement prix de revente
  - [ ] 3.3 Appeler `VatSimulatorCubit.updateSalePrice()` à chaque changement
  - [ ] 3.4 Cubit recalcule automatiquement et émet nouveau state
  - [ ] 3.5 UI se met à jour via `BlocBuilder`

- [ ] Task 4 : Implémenter la comparaison de scénarios (AC: #3)
  - [ ] 4.1 Créer modèle `VatScenario` (nom, paramètres, résultats)
  - [ ] 4.2 Ajouter liste de scénarios dans `VatSimulatorState`
  - [ ] 4.3 Ajouter méthode `saveScenario(name)` dans Cubit
  - [ ] 4.4 Créer widget `VatScenarioComparison` pour afficher les scénarios côte à côte
  - [ ] 4.5 Permettre suppression et renommage des scénarios

- [ ] Task 5 : Créer l'interface utilisateur (AC: #1, #2, #3)
  - [ ] 5.1 Design formulaire de saisie avec labels clairs (prix achat, travaux, frais, prix revente)
  - [ ] 5.2 Afficher résultats calculés : base TVA, TVA due marge, TVA due total, marge nette
  - [ ] 5.3 Afficher comparaison TVA sur marge vs TVA sur total
  - [ ] 5.4 Ajouter bouton "Sauvegarder scénario"
  - [ ] 5.5 Afficher liste des scénarios sauvegardés avec résultats

- [ ] Task 6 : Tests unitaires et validation (AC: #1, #2, #3)
  - [ ] 6.1 Tester `VatCalculator.calculateVatOnMargin()` avec cas typiques
  - [ ] 6.2 Tester `VatCalculator.calculateVatOnTotal()` avec cas typiques
  - [ ] 6.3 Tester `VatSimulatorCubit.updateSalePrice()` et mise à jour state
  - [ ] 6.4 Tester `VatSimulatorCubit.saveScenario()` et gestion liste
  - [ ] 6.5 Vérifier calculs en centimes (pas de problèmes d'arrondi)

## Dev Notes

### Architecture & Contraintes

- **Client-only feature** : Aucune API backend nécessaire, logique 100% embarquée [Source: architecture.md#Requirements → Structure Mapping]
- **Montants en centimes** : Tous les montants sont des `int` (centimes) pour éviter les erreurs d'arrondi [Source: architecture.md#Format Patterns]
- **Cubit pattern** : `VatSimulatorCubit` gère l'état, pas besoin de Bloc car logique simple [Source: architecture.md#Communication Patterns]
- **Offline-first** : Fonctionne sans connexion, pas besoin de sync

### Formules TVA

**TVA sur marge** :
```
base_tva = prix_revente - (prix_achat + travaux + frais)
tva_due = base_tva * 0.20
marge_nette = prix_revente - prix_achat - travaux - frais - tva_due
```

**TVA sur total** :
```
tva_due = prix_revente * 0.20 / 1.20
marge_nette = prix_revente - prix_achat - travaux - frais - tva_due
```

### Versions techniques confirmées

- **Flutter** : 3.38.x
- **Bloc** : v8.x (très_good_cli standard)
- **Pas de dépendance externe** pour les calculs

### Structure cible

```
lib/features/vat_simulator/
├── data/
│   ├── models/
│   │   ├── vat_calculation.dart
│   │   └── vat_scenario.dart
│   └── services/
│       └── vat_calculator.dart
└── presentation/
    ├── cubit/
    │   ├── vat_simulator_cubit.dart
    │   └── vat_simulator_state.dart
    ├── pages/
    │   └── vat_simulator_page.dart
    └── widgets/
        ├── vat_input_form.dart
        ├── vat_results_display.dart
        └── vat_scenario_comparison.dart
```

### Project Structure Notes

Cette story ajoute une nouvelle feature dans `mobile-app/lib/features/vat_simulator/`. La feature est isolée et ne dépend d'aucune autre feature métier. Elle est accessible via le menu principal de l'application.

- Pas de table Drift nécessaire (calcul en mémoire uniquement)
- Pas de controller Laravel nécessaire
- Scénarios sauvegardés optionnellement en local storage (SharedPreferences) si demandé par l'utilisateur

### References

- [Source: epics.md#Story 10.1] — Acceptance criteria BDD
- [Source: architecture.md#Requirements → Structure Mapping] — Feature client-only
- [Source: architecture.md#Format Patterns] — Montants en centimes integer
- [Source: architecture.md#Communication Patterns] — Cubit pattern
- [Source: architecture.md#Frontend Architecture] — folder-by-feature VGV

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
