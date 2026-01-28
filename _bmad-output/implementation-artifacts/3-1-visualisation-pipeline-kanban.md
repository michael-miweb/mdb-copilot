# Story 3.1 : Visualisation du pipeline Kanban

Status: ready-for-dev

## Story

As a utilisateur,
I want visualiser toutes mes annonces dans un pipeline Kanban avec les étapes de mon workflow MDB,
So that j'ai une vue d'ensemble de la progression de chaque projet.

## Acceptance Criteria

1. **Given** un utilisateur connecté avec des fiches annonces
   **When** il accède à l'écran Pipeline
   **Then** un Kanban s'affiche avec les colonnes : Prospection, RDV, Visite, Analyse, Offre, Acheté, Travaux, Vente, Vendu
   **And** chaque fiche apparaît dans la colonne correspondant à son statut
   **And** chaque carte affiche adresse, prix et urgence

## Tasks / Subtasks

- [ ] Task 1 : Créer le modèle de données pipeline (AC: #1)
  - [ ] 1.1 Ajouter le champ `status` (enum) au modèle Property dans Drift
  - [ ] 1.2 Créer l'enum `PropertyStatus` avec 9 valeurs : prospection, rdv, visite, analyse, offre, achete, travaux, vente, vendu
  - [ ] 1.3 Ajouter la migration Drift pour le champ `status`
  - [ ] 1.4 Créer la migration Laravel `add_status_to_properties_table` avec enum ou string
  - [ ] 1.5 Mettre à jour le modèle Eloquent Property avec le cast `status`

- [ ] Task 2 : Créer le repository pipeline (AC: #1)
  - [ ] 2.1 Créer `PipelineRepository` dans `features/pipeline/data/`
  - [ ] 2.2 Implémenter `getPropertiesByStatus()` → retourne Map<PropertyStatus, List<Property>>
  - [ ] 2.3 Implémenter `getPropertiesForStage(PropertyStatus status)` → List<Property>
  - [ ] 2.4 Ajouter les méthodes au `PropertyLocalSource` (requêtes Drift)
  - [ ] 2.5 Ajouter les méthodes au `PropertyRemoteSource` (endpoint `/api/pipeline`)

- [ ] Task 3 : Créer l'API endpoint pipeline (AC: #1)
  - [ ] 3.1 Créer `PipelineController` dans `app/Http/Controllers/Api/`
  - [ ] 3.2 Implémenter `index()` → retourne properties groupées par status
  - [ ] 3.3 Créer `PipelineResource` pour formatter la réponse JSON
  - [ ] 3.4 Ajouter la route `GET /api/pipeline` dans `routes/api.php` avec middleware `auth:sanctum`
  - [ ] 3.5 Créer les tests Feature `PipelineControllerTest`

- [ ] Task 4 : Créer le widget Kanban column (AC: #1)
  - [ ] 4.1 Créer `mdb_kanban_column.dart` dans `packages/mdb_ui/lib/widgets/`
  - [ ] 4.2 Implémenter le widget avec paramètres : title, color, cards
  - [ ] 4.3 Styliser selon le design system (iOS 26 Liquid Glass via adaptive_platform_ui)
  - [ ] 4.4 Ajouter un header avec le titre de la colonne et le count des cartes
  - [ ] 4.5 Créer les tests widget pour `MdbKanbanColumn`

- [ ] Task 5 : Créer le widget Property card (AC: #1)
  - [ ] 5.1 Créer `mdb_property_card.dart` dans `packages/mdb_ui/lib/widgets/`
  - [ ] 5.2 Afficher adresse, prix formaté (en euros), badge urgence (couleur selon niveau)
  - [ ] 5.3 Gérer le tap pour navigation vers détail fiche
  - [ ] 5.4 Ajouter un placeholder si pas de données
  - [ ] 5.5 Créer les tests widget pour `MdbPropertyCard`

- [ ] Task 6 : Créer le Cubit pipeline (AC: #1)
  - [ ] 6.1 Créer `PipelineCubit` dans `features/pipeline/presentation/cubit/`
  - [ ] 6.2 Créer les states : `PipelineInitial`, `PipelineLoading`, `PipelineLoaded`, `PipelineError`
  - [ ] 6.3 Implémenter `loadPipeline()` → appelle repository et émet `PipelineLoaded` avec Map<PropertyStatus, List<Property>>
  - [ ] 6.4 Gérer les erreurs réseau et émettre `PipelineError`
  - [ ] 6.5 Créer les tests unitaires pour `PipelineCubit`

- [ ] Task 7 : Créer la page Pipeline (AC: #1)
  - [ ] 7.1 Créer `pipeline_page.dart` dans `features/pipeline/presentation/pages/`
  - [ ] 7.2 Utiliser `BlocProvider` pour injecter `PipelineCubit`
  - [ ] 7.3 Créer un `BlocBuilder` qui affiche les 9 colonnes Kanban horizontales (scrollable)
  - [ ] 7.4 Mapper chaque `PropertyStatus` à une `MdbKanbanColumn` avec ses cartes
  - [ ] 7.5 Afficher un skeleton/shimmer pendant `PipelineLoading`
  - [ ] 7.6 Afficher un message d'erreur si `PipelineError`
  - [ ] 7.7 Ajouter la route `/pipeline` dans `app/routes.dart`

- [ ] Task 8 : Validation finale (AC: #1)
  - [ ] 8.1 Vérifier que les 9 colonnes s'affichent correctement
  - [ ] 8.2 Vérifier que les cartes affichent adresse, prix et urgence
  - [ ] 8.3 Vérifier le scroll horizontal fonctionne
  - [ ] 8.4 Tester avec 0 fiche, 1 fiche, plusieurs fiches réparties
  - [ ] 8.5 Vérifier que le tap sur une carte ouvre le détail (navigation)
  - [ ] 8.6 Tester en mode offline avec données locales
  - [ ] 8.7 Commit : `git add . && git commit -m "feat: visualisation pipeline Kanban avec 9 colonnes et cartes annonces"`

## Dev Notes

### Architecture & Contraintes

- **Pipeline Kanban** : Les 9 étapes reflètent le workflow MDB réel : Prospection → RDV → Visite → Analyse → Offre → Acheté → Travaux → Vente → Vendu [Source: epics.md#Story 3.1]
- **Widget réutilisable** : `mdb_kanban_column` dans le package `mdb_ui` pour cohérence design system [Source: architecture.md#Frontend Architecture]
- **Property card** : Affiche adresse, prix (formaté en euros depuis centimes), urgence (badge couleur) [Source: epics.md#Acceptance Criteria]
- **Repository pattern** : `PipelineRepository` abstrait l'accès local (Drift) et remote (API) [Source: architecture.md#Implementation Patterns]
- **Offline-first** : Les données pipeline sont stockées localement et accessibles sans connexion [Source: architecture.md#Data Architecture]

### Versions techniques confirmées

- **Flutter** : 3.38.x avec Very Good CLI
- **adaptive_platform_ui** : pour rendu iOS 26+ Liquid Glass automatique
- **Drift** : base de données locale type-safe avec SQLCipher
- **Laravel** : 12.x avec Sanctum auth

### Modèle de données — PropertyStatus enum

Dart (Flutter) :
```dart
enum PropertyStatus {
  prospection,
  rdv,
  visite,
  analyse,
  offre,
  achete,
  travaux,
  vente,
  vendu;
}
```

Migration Drift :
```dart
TextColumn get status => text().withDefault(const Constant('prospection'))();
```

Migration Laravel :
```php
$table->string('status')->default('prospection');
// ou
$table->enum('status', ['prospection', 'rdv', 'visite', 'analyse', 'offre', 'achete', 'travaux', 'vente', 'vendu'])->default('prospection');
```

### API Response format

```json
{
  "data": {
    "prospection": [
      {
        "id": "uuid-1",
        "adresse": "12 Rue de la Paix, Paris",
        "prix": 350000,
        "urgence": "elevee",
        "status": "prospection",
        "created_at": "2026-01-27T10:00:00Z"
      }
    ],
    "rdv": [],
    "visite": [
      {
        "id": "uuid-2",
        "adresse": "45 Avenue Victor Hugo, Lyon",
        "prix": 280000,
        "urgence": "moyenne",
        "status": "visite",
        "created_at": "2026-01-26T14:30:00Z"
      }
    ],
    ...
  }
}
```

### Widget structure — MdbKanbanColumn

```dart
class MdbKanbanColumn extends StatelessWidget {
  const MdbKanbanColumn({
    required this.title,
    required this.cards,
    this.color,
    super.key,
  });

  final String title;
  final List<Widget> cards;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Expanded(child: _buildCardsList()),
        ],
      ),
    );
  }
}
```

### UI Layout — Scroll horizontal

- Utiliser `ListView.builder` horizontal pour les 9 colonnes
- Chaque colonne a une largeur fixe (300px)
- Les cartes dans chaque colonne scrollent verticalement
- Total viewport horizontal ≈ 9 × 300px = 2700px

### Project Structure Notes

Structure cible après cette story :

```
mobile-app/
├── lib/
│   ├── features/
│   │   └── pipeline/
│   │       ├── data/
│   │       │   └── pipeline_repository.dart
│   │       └── presentation/
│   │           ├── cubit/
│   │           │   ├── pipeline_cubit.dart
│   │           │   └── pipeline_state.dart
│   │           └── pages/
│   │               └── pipeline_page.dart
│   └── core/
│       └── db/
│           └── tables/
│               └── properties_table.dart (modifié : + status)
├── packages/
│   └── mdb_ui/
│       └── lib/
│           └── widgets/
│               ├── mdb_kanban_column.dart (nouveau)
│               └── mdb_property_card.dart (nouveau)
└── test/
    ├── features/
    │   └── pipeline/
    │       ├── cubit/
    │       │   └── pipeline_cubit_test.dart
    │       └── pages/
    │           └── pipeline_page_test.dart
    └── packages/
        └── mdb_ui/
            └── widgets/
                ├── mdb_kanban_column_test.dart
                └── mdb_property_card_test.dart

backend-api/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       └── PipelineController.php (nouveau)
│   │   └── Resources/
│   │       └── PipelineResource.php (nouveau)
│   └── Models/
│       └── Property.php (modifié : + status cast)
├── database/
│   └── migrations/
│       └── xxxx_add_status_to_properties_table.php (nouveau)
└── tests/
    └── Feature/
        └── Pipeline/
            └── PipelineControllerTest.php (nouveau)
```

### References

- [Source: epics.md#Story 3.1] — User story et acceptance criteria complets
- [Source: epics.md#FR13] — Visualisation pipeline Kanban avec 9 colonnes
- [Source: architecture.md#Frontend Architecture] — Bloc/Cubit pattern, package mdb_ui
- [Source: architecture.md#Data Architecture] — Repository pattern, Drift + MySQL sync
- [Source: architecture.md#Naming Patterns] — snake_case DB/API, camelCase Dart, PascalCase classes
- [Source: architecture.md#Project Structure & Boundaries] — Structure folder-by-feature

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
