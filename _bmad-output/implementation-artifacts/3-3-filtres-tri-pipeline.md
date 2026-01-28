# Story 3.3 : Filtres et tri du pipeline

Status: ready-for-dev

## Story

As a utilisateur,
I want filtrer et trier mes annonces dans le pipeline,
So that je retrouve rapidement les projets qui m'intéressent.

## Acceptance Criteria

1. **Given** le pipeline Kanban affiché
   **When** l'utilisateur applique un filtre par type de bien
   **Then** seules les fiches correspondantes sont affichées

2. **Given** le pipeline Kanban affiché
   **When** l'utilisateur applique un tri (prix croissant/décroissant, date, urgence)
   **Then** les cartes dans chaque colonne sont réordonnées

3. **Given** des filtres actifs
   **When** l'utilisateur réinitialise les filtres
   **Then** toutes les fiches sont à nouveau visibles

## Tasks / Subtasks

- [ ] Task 1 : Dépendances Stories 3.1 et 3.2 (AC: #1, #2, #3)
  - [ ] 1.1 Vérifier que Story 3.1 est complète (pipeline Kanban)
  - [ ] 1.2 Vérifier que Story 3.2 est complète (déplacement annonces)
  - [ ] 1.3 Vérifier que `PipelineCubit` et `PipelineRepository` existent

- [ ] Task 2 : Modéliser les filtres et tri (AC: #1, #2)
  - [ ] 2.1 Créer l'enum `PropertyType` : appartement, maison, immeuble, terrain, commercial
  - [ ] 2.2 Créer l'enum `PipelineSortBy` : prix_asc, prix_desc, date_asc, date_desc, urgence_asc, urgence_desc
  - [ ] 2.3 Créer la classe `PipelineFilters` avec champs : `List<PropertyType>? types`, `PipelineSortBy? sortBy`
  - [ ] 2.4 Ajouter le champ `type_de_bien` au modèle Property (Drift + Laravel) si pas encore présent
  - [ ] 2.5 Créer les migrations Drift et Laravel pour `type_de_bien`

- [ ] Task 3 : Étendre le Cubit pour gérer les filtres (AC: #1, #2, #3)
  - [ ] 3.1 Ajouter un champ `PipelineFilters currentFilters` dans `PipelineState`
  - [ ] 3.2 Ajouter la méthode `applyFilters(PipelineFilters filters)` dans `PipelineCubit`
  - [ ] 3.3 Implémenter `applyFilters()` : recharger le pipeline avec filtres appliqués
  - [ ] 3.4 Ajouter la méthode `applySorting(PipelineSortBy sortBy)` dans `PipelineCubit`
  - [ ] 3.5 Ajouter la méthode `resetFilters()` dans `PipelineCubit`
  - [ ] 3.6 Créer les tests unitaires pour les méthodes de filtrage

- [ ] Task 4 : Implémenter le filtrage dans le Repository (AC: #1, #2)
  - [ ] 4.1 Ajouter les paramètres `filters` et `sortBy` à `getPropertiesByStatus()` dans `PipelineRepository`
  - [ ] 4.2 Implémenter le filtrage par `type_de_bien` dans `PropertyLocalSource` (requête Drift avec WHERE)
  - [ ] 4.3 Implémenter le tri dans `PropertyLocalSource` (ORDER BY)
  - [ ] 4.4 Implémenter le filtrage côté API dans `PropertyRemoteSource` : query params `?types[]=appartement&sort_by=prix_asc`
  - [ ] 4.5 Créer les tests pour le repository avec filtres

- [ ] Task 5 : Étendre l'API pour supporter filtres et tri (AC: #1, #2)
  - [ ] 5.1 Modifier `PipelineController@index()` pour accepter les query params `types[]` et `sort_by`
  - [ ] 5.2 Valider les query params avec une Form Request `PipelineIndexRequest`
  - [ ] 5.3 Appliquer les filtres via Eloquent : `whereIn('type_de_bien', $types)`
  - [ ] 5.4 Appliquer le tri via Eloquent : `orderBy('prix', 'asc')` etc.
  - [ ] 5.5 Créer les tests Feature pour l'API avec filtres

- [ ] Task 6 : Créer l'UI des filtres (AC: #1, #3)
  - [ ] 6.1 Créer `pipeline_filters_widget.dart` dans `features/pipeline/presentation/widgets/`
  - [ ] 6.2 Afficher un bouton "Filtres" dans l'AppBar de `pipeline_page`
  - [ ] 6.3 Ouvrir un bottom sheet avec les options de filtrage
  - [ ] 6.4 Ajouter des checkboxes pour chaque `PropertyType`
  - [ ] 6.5 Ajouter un bouton "Appliquer" et un bouton "Réinitialiser"
  - [ ] 6.6 Appeler `PipelineCubit.applyFilters()` lors du clic sur "Appliquer"
  - [ ] 6.7 Appeler `PipelineCubit.resetFilters()` lors du clic sur "Réinitialiser"
  - [ ] 6.8 Créer les tests widget pour `PipelineFiltersWidget`

- [ ] Task 7 : Créer l'UI du tri (AC: #2)
  - [ ] 7.1 Créer `pipeline_sort_widget.dart` dans `features/pipeline/presentation/widgets/`
  - [ ] 7.2 Afficher un bouton "Trier" dans l'AppBar de `pipeline_page`
  - [ ] 7.3 Ouvrir un menu déroulant ou bottom sheet avec les options de tri
  - [ ] 7.4 Lister les options : Prix croissant, Prix décroissant, Date création, Date modification, Urgence faible→élevée, Urgence élevée→faible
  - [ ] 7.5 Appeler `PipelineCubit.applySorting(selectedSort)` lors de la sélection
  - [ ] 7.6 Créer les tests widget pour `PipelineSortWidget`

- [ ] Task 8 : Indicateurs visuels des filtres actifs (AC: #3)
  - [ ] 8.1 Afficher un badge sur le bouton "Filtres" si des filtres sont actifs
  - [ ] 8.2 Afficher une chip row avec les filtres actifs sous l'AppBar
  - [ ] 8.3 Permettre de retirer un filtre en tapant sur la chip
  - [ ] 8.4 Afficher le tri actif dans le bouton "Trier"

- [ ] Task 9 : Validation finale (AC: #1, #2, #3)
  - [ ] 9.1 Tester le filtre par type de bien (sélectionner "Appartement" uniquement)
  - [ ] 9.2 Vérifier que seules les fiches de type appartement sont affichées
  - [ ] 9.3 Tester le filtre multi-types (Appartement + Maison)
  - [ ] 9.4 Tester le tri par prix croissant/décroissant
  - [ ] 9.5 Vérifier que les cartes sont réordonnées dans chaque colonne
  - [ ] 9.6 Tester le tri par date et par urgence
  - [ ] 9.7 Tester la réinitialisation des filtres
  - [ ] 9.8 Vérifier que toutes les fiches réapparaissent après reset
  - [ ] 9.9 Tester la combinaison filtre + tri
  - [ ] 9.10 Tester en mode offline (filtres appliqués localement)
  - [ ] 9.11 Commit : `git add . && git commit -m "feat: filtres et tri pipeline par type de bien, prix, date, urgence"`

## Dev Notes

### Architecture & Contraintes

- **Dépendances Stories 3.1 et 3.2** : Cette story s'appuie sur le pipeline Kanban et le déplacement d'annonces [Source: epics.md#Story 3.3]
- **Filtres multi-critères** : Filtre par type de bien (checkbox multiple) [Source: epics.md#FR15]
- **Tri multi-critères** : Tri par prix, date ou urgence (ascendant/descendant) [Source: epics.md#FR15]
- **Réinitialisation** : Bouton pour retirer tous les filtres d'un coup [Source: epics.md#FR15]
- **Offline-first** : Les filtres et tri s'appliquent sur les données locales Drift [Source: architecture.md#Data Architecture]
- **Query params API** : Utiliser des query params standard pour filtres et tri [Source: architecture.md#API & Communication Patterns]

### Versions techniques confirmées

- **Flutter** : 3.38.x
- **Drift** : requêtes SQL avec WHERE et ORDER BY
- **Laravel** : Eloquent whereIn, orderBy
- **API** : query params `?types[]=appartement&types[]=maison&sort_by=prix_asc`

### Modèle de données — PropertyType enum

Dart (Flutter) :
```dart
enum PropertyType {
  appartement,
  maison,
  immeuble,
  terrain,
  commercial;
}
```

Migration Drift :
```dart
TextColumn get typeDeBien => text().nullable()();
```

Migration Laravel :
```php
$table->string('type_de_bien')->nullable();
// ou
$table->enum('type_de_bien', ['appartement', 'maison', 'immeuble', 'terrain', 'commercial'])->nullable();
```

### Filtres — Data model

```dart
class PipelineFilters {
  const PipelineFilters({
    this.types,
    this.sortBy,
  });

  final List<PropertyType>? types;
  final PipelineSortBy? sortBy;

  bool get isEmpty => types == null && sortBy == null;

  PipelineFilters copyWith({
    List<PropertyType>? types,
    PipelineSortBy? sortBy,
  }) {
    return PipelineFilters(
      types: types ?? this.types,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

enum PipelineSortBy {
  prixAsc,
  prixDesc,
  dateAsc,
  dateDesc,
  urgenceAsc,
  urgenceDesc;
}
```

### API Request — Filtres et tri

GET `/api/pipeline?types[]=appartement&types[]=maison&sort_by=prix_asc`

Query params :
- `types[]` : array de strings (appartement, maison, immeuble, terrain, commercial)
- `sort_by` : string (prix_asc, prix_desc, date_asc, date_desc, urgence_asc, urgence_desc)

Laravel validation (PipelineIndexRequest) :
```php
return [
    'types' => ['nullable', 'array'],
    'types.*' => ['string', Rule::in(['appartement', 'maison', 'immeuble', 'terrain', 'commercial'])],
    'sort_by' => ['nullable', 'string', Rule::in(['prix_asc', 'prix_desc', 'date_asc', 'date_desc', 'urgence_asc', 'urgence_desc'])],
];
```

Laravel controller :
```php
public function index(PipelineIndexRequest $request)
{
    $query = Property::query()->where('user_id', auth()->id());

    if ($types = $request->input('types')) {
        $query->whereIn('type_de_bien', $types);
    }

    $sortBy = $request->input('sort_by', 'created_at_desc');
    match ($sortBy) {
        'prix_asc' => $query->orderBy('prix', 'asc'),
        'prix_desc' => $query->orderBy('prix', 'desc'),
        'date_asc' => $query->orderBy('created_at', 'asc'),
        'date_desc' => $query->orderBy('created_at', 'desc'),
        'urgence_asc' => $query->orderByRaw("FIELD(urgence, 'faible', 'moyenne', 'elevee')"),
        'urgence_desc' => $query->orderByRaw("FIELD(urgence, 'elevee', 'moyenne', 'faible')"),
        default => $query->orderBy('created_at', 'desc'),
    };

    $properties = $query->get()->groupBy('status');

    return PipelineResource::collection($properties);
}
```

### Drift — Filtres et tri

```dart
// Filtrage par types
Stream<List<Property>> watchPropertiesByStatus(
  PropertyStatus status, {
  List<PropertyType>? types,
  PipelineSortBy? sortBy,
}) {
  var query = select(properties)
    ..where((p) => p.status.equals(status.name));

  if (types != null && types.isNotEmpty) {
    query = query..where((p) => p.typeDeBien.isIn(types.map((t) => t.name)));
  }

  if (sortBy != null) {
    switch (sortBy) {
      case PipelineSortBy.prixAsc:
        query = query..orderBy([(p) => OrderingTerm(expression: p.prix)]);
      case PipelineSortBy.prixDesc:
        query = query..orderBy([(p) => OrderingTerm(expression: p.prix, mode: OrderingMode.desc)]);
      case PipelineSortBy.dateAsc:
        query = query..orderBy([(p) => OrderingTerm(expression: p.createdAt)]);
      case PipelineSortBy.dateDesc:
        query = query..orderBy([(p) => OrderingTerm(expression: p.createdAt, mode: OrderingMode.desc)]);
      // ... autres cas
    }
  }

  return query.watch();
}
```

### UI — Bottom sheet filtres

```dart
class PipelineFiltersWidget extends StatefulWidget {
  const PipelineFiltersWidget({
    required this.currentFilters,
    super.key,
  });

  final PipelineFilters currentFilters;

  @override
  State<PipelineFiltersWidget> createState() => _PipelineFiltersWidgetState();
}

class _PipelineFiltersWidgetState extends State<PipelineFiltersWidget> {
  late Set<PropertyType> _selectedTypes;

  @override
  void initState() {
    super.initState();
    _selectedTypes = widget.currentFilters.types?.toSet() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Checkboxes pour chaque PropertyType
        ...PropertyType.values.map((type) {
          return CheckboxListTile(
            title: Text(_getTypeName(type)),
            value: _selectedTypes.contains(type),
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  _selectedTypes.add(type);
                } else {
                  _selectedTypes.remove(type);
                }
              });
            },
          );
        }),
        // Boutons
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<PipelineCubit>().resetFilters();
                Navigator.pop(context);
              },
              child: const Text('Réinitialiser'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<PipelineCubit>().applyFilters(
                  PipelineFilters(types: _selectedTypes.toList()),
                );
                Navigator.pop(context);
              },
              child: const Text('Appliquer'),
            ),
          ],
        ),
      ],
    );
  }

  String _getTypeName(PropertyType type) {
    return switch (type) {
      PropertyType.appartement => 'Appartement',
      PropertyType.maison => 'Maison',
      PropertyType.immeuble => 'Immeuble',
      PropertyType.terrain => 'Terrain',
      PropertyType.commercial => 'Commercial',
    };
  }
}
```

### Project Structure Notes

Structure modifiée après cette story :

```
mobile-app/
├── lib/
│   ├── features/
│   │   └── pipeline/
│   │       ├── data/
│   │       │   ├── pipeline_repository.dart (modifié : + filtres/tri params)
│   │       │   └── models/
│   │       │       ├── pipeline_filters.dart (nouveau)
│   │       │       └── pipeline_sort_by.dart (nouveau)
│   │       └── presentation/
│   │           ├── cubit/
│   │           │   ├── pipeline_cubit.dart (modifié : + applyFilters, applySorting, resetFilters)
│   │           │   └── pipeline_state.dart (modifié : + currentFilters)
│   │           ├── pages/
│   │           │   └── pipeline_page.dart (modifié : + boutons filtres/tri)
│   │           └── widgets/
│   │               ├── pipeline_filters_widget.dart (nouveau)
│   │               └── pipeline_sort_widget.dart (nouveau)
│   └── core/
│       └── db/
│           └── tables/
│               └── properties_table.dart (modifié : + type_de_bien)
└── test/
    └── features/
        └── pipeline/
            ├── cubit/
            │   └── pipeline_cubit_test.dart (modifié)
            └── widgets/
                ├── pipeline_filters_widget_test.dart (nouveau)
                └── pipeline_sort_widget_test.dart (nouveau)

backend-api/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       └── PipelineController.php (modifié : + filtres/tri query params)
│   │   └── Requests/
│   │       └── PipelineIndexRequest.php (nouveau)
│   └── Models/
│       └── Property.php (modifié : + type_de_bien)
├── database/
│   └── migrations/
│       └── xxxx_add_type_de_bien_to_properties_table.php (nouveau)
└── tests/
    └── Feature/
        └── Pipeline/
            └── PipelineFiltersTest.php (nouveau)
```

### References

- [Source: epics.md#Story 3.3] — User story et acceptance criteria complets
- [Source: epics.md#FR15] — Filtres et tri pipeline
- [Source: architecture.md#Data Architecture] — Drift queries, offline-first
- [Source: architecture.md#API & Communication Patterns] — Query params standard
- [Source: architecture.md#Naming Patterns] — snake_case API, camelCase Dart
- [Source: architecture.md#Frontend Architecture] — Bloc/Cubit pattern

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
