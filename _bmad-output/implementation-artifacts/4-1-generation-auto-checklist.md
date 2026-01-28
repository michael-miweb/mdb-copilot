# Story 4.1 : Génération automatique de la checklist pré-visite

Status: ready-for-dev

## Story

As a utilisateur,
I want qu'une checklist de préparation se génère automatiquement quand une annonce passe au statut "RDV",
So that je n'oublie aucune étape de préparation avant la visite.

## Acceptance Criteria

1. **Given** une fiche annonce
   **When** son statut passe à "RDV" dans le pipeline
   **Then** une checklist pré-visite est créée automatiquement et liée à la fiche
   **And** la checklist contient les catégories : questions à poser à l'agent, documents à demander, points à vérifier sur place
   **And** chaque catégorie contient des items prédéfinis adaptés au type de bien

## Tasks / Subtasks

- [ ] Task 1 : Créer les modèles Laravel pour la checklist (AC: #1)
  - [ ] 1.1 Créer la migration `create_checklists_table` avec : `id` (UUID), `property_id` (UUID FK), `created_at`, `updated_at`, `deleted_at`
  - [ ] 1.2 Créer la migration `create_checklist_items_table` avec : `id` (UUID), `checklist_id` (UUID FK), `category` (enum: questions_agent, documents, points_verification), `label` (string), `is_checked` (boolean default false), `order` (integer), `created_at`, `updated_at`
  - [ ] 1.3 Créer le modèle `Checklist` avec relation `hasMany(ChecklistItem)` et `belongsTo(Property)`
  - [ ] 1.4 Créer le modèle `ChecklistItem` avec relation `belongsTo(Checklist)`
  - [ ] 1.5 Ajouter les casts UUID v4 sur les modèles

- [ ] Task 2 : Implémenter le service de génération de checklist (AC: #1)
  - [ ] 2.1 Créer `ChecklistService` avec méthode `generateForProperty(Property $property): Checklist`
  - [ ] 2.2 Définir les templates d'items par type de bien (appartement, maison, immeuble, terrain) dans une config ou un seeder
  - [ ] 2.3 Implémenter la logique de génération : créer Checklist + ChecklistItems selon le type de bien
  - [ ] 2.4 Catégoriser les items : questions_agent (ex: "Motif de vente?"), documents (ex: "DPE"), points_verification (ex: "État toiture")
  - [ ] 2.5 Assigner un ordre à chaque item pour affichage cohérent

- [ ] Task 3 : Déclencher la génération lors du passage au statut "RDV" (AC: #1)
  - [ ] 3.1 Créer un Event `PropertyStatusChanged` avec `$property` et `$newStatus`
  - [ ] 3.2 Créer un Listener `GenerateChecklistOnRdvStatus` qui appelle `ChecklistService::generateForProperty()` si `$newStatus === 'RDV'`
  - [ ] 3.3 Enregistrer l'Event/Listener dans `EventServiceProvider`
  - [ ] 3.4 Dispatcher l'Event `PropertyStatusChanged` dans `PipelineController` lors de la mise à jour du statut

- [ ] Task 4 : Créer l'API REST pour les checklists (AC: #1)
  - [ ] 4.1 Créer `ChecklistController` avec méthode `show(Property $property): ChecklistResource`
  - [ ] 4.2 Créer `ChecklistResource` qui inclut `ChecklistItemResource` nested
  - [ ] 4.3 Créer la route `GET /api/properties/{property}/checklist` dans `api.php` avec middleware `auth:sanctum`
  - [ ] 4.4 Retourner 404 si pas de checklist existante pour la property
  - [ ] 4.5 Ajouter tests Feature : génération checklist, récupération via API

- [ ] Task 5 : Créer la table Drift et le repository Flutter (AC: #1)
  - [ ] 5.1 Créer `checklists_table.dart` dans `lib/core/db/tables/` avec colonnes : `id` (text, PK), `propertyId` (text), `createdAt` (datetime), `updatedAt` (datetime), `syncStatus` (text)
  - [ ] 5.2 Créer `checklist_items_table.dart` avec colonnes : `id` (text, PK), `checklistId` (text, FK), `category` (text), `label` (text), `isChecked` (boolean), `order` (integer), `updatedAt` (datetime), `syncStatus` (text)
  - [ ] 5.3 Ajouter les tables à `AppDatabase` dans `app_database.dart`
  - [ ] 5.4 Générer le code Drift : `flutter pub run build_runner build`
  - [ ] 5.5 Créer `ChecklistRepository` dans `lib/features/checklist/data/` avec méthodes : `getChecklistForProperty(String propertyId)`, `markItemChecked(String itemId, bool checked)`, `syncChecklist(ChecklistModel checklist)`

- [ ] Task 6 : Implémenter la feature Flutter checklist (AC: #1)
  - [ ] 6.1 Créer `ChecklistModel` et `ChecklistItemModel` dans `lib/features/checklist/data/models/`
  - [ ] 6.2 Créer `ChecklistCubit` avec states : `ChecklistInitial`, `ChecklistLoading`, `ChecklistLoaded`, `ChecklistError`
  - [ ] 6.3 Implémenter `loadChecklistForProperty(String propertyId)` dans le Cubit : appel Repository local → si vide, fetch remote via API → store local
  - [ ] 6.4 Créer `checklist_page.dart` dans `lib/features/checklist/presentation/pages/` affichant les items groupés par catégorie
  - [ ] 6.5 Ajouter la route GoRouter vers ChecklistPage depuis PropertyDetailPage

- [ ] Task 7 : Validation finale (AC: #1)
  - [ ] 7.1 Tester backend : créer Property → changer statut vers "RDV" → vérifier génération Checklist en DB
  - [ ] 7.2 Tester API : `GET /api/properties/{uuid}/checklist` retourne 200 avec checklist + items
  - [ ] 7.3 Tester Flutter : accéder à une fiche au statut "RDV" → voir checklist avec items par catégorie
  - [ ] 7.4 Vérifier stockage Drift : checklist et items enregistrés localement
  - [ ] 7.5 Commit : `git add . && git commit -m "feat: génération auto checklist pré-visite au statut RDV

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"`

## Dev Notes

### Architecture & Contraintes

- **Event-driven** : Utiliser Laravel Events/Listeners pour déclencher la génération de checklist lors du changement de statut [Source: architecture.md#Communication Patterns]
- **Templates checklist** : Items prédéfinis adaptés au type de bien (appartement, maison, immeuble, terrain). Stocker les templates dans une config Laravel ou via un seeder [Source: epics.md#Story 4.1]
- **Catégories** : questions_agent, documents, points_verification [Source: epics.md#Story 4.1 AC]
- **Repository pattern** : Abstraction local/remote obligatoire. Le `ChecklistRepository` Flutter gère Drift (local) et API (remote) [Source: architecture.md#Frontend Architecture]
- **Sync** : Checklist et ChecklistItems sont des entités synchronisables avec `syncStatus: pending/synced` [Source: architecture.md#Data Architecture]

### Versions techniques confirmées

- **UUID v4** : Tous les IDs d'entités (checklists, checklist_items) [Source: architecture.md#Format Patterns]
- **Drift** : Type-safe queries, reactive streams, migrations [Source: architecture.md#DB locale Flutter]
- **Laravel Events** : `PropertyStatusChanged` → `GenerateChecklistOnRdvStatus` [Source: architecture.md#Communication Patterns]
- **Sanctum** : Middleware `auth:sanctum` sur toutes les routes API checklist [Source: architecture.md#API & Communication Patterns]

### Modèle de données — Backend

**Table `checklists` :**
```
id (UUID, PK)
property_id (UUID, FK → properties)
created_at
updated_at
deleted_at (soft delete)
```

**Table `checklist_items` :**
```
id (UUID, PK)
checklist_id (UUID, FK → checklists)
category (enum: questions_agent, documents, points_verification)
label (string, 255)
is_checked (boolean, default false)
order (integer)
created_at
updated_at
```

**Relations Eloquent :**
- `Checklist belongsTo Property`
- `Checklist hasMany ChecklistItem`
- `ChecklistItem belongsTo Checklist`

### Modèle de données — Flutter Drift

**Table `checklists_table` :**
```dart
class ChecklistsTable extends Table {
  TextColumn get id => text()();
  TextColumn get propertyId => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Table `checklist_items_table` :**
```dart
class ChecklistItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get checklistId => text()();
  TextColumn get category => text()();
  TextColumn get label => text()();
  BoolColumn get isChecked => boolean().withDefault(const Constant(false))();
  IntColumn get order => integer()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Exemple de template checklist (config Laravel)

```php
// config/checklist_templates.php
return [
    'appartement' => [
        'questions_agent' => [
            'Motif de vente du propriétaire ?',
            'Durée de mise en vente ?',
            'Historique des visites ?',
            'Charges de copropriété mensuelles ?',
            'Travaux votés en AG ?',
        ],
        'documents' => [
            'DPE (Diagnostic Performance Énergétique)',
            'Procès-verbaux AG 3 dernières années',
            'Règlement de copropriété',
            'État des charges',
            'Diagnostics obligatoires (amiante, plomb, etc.)',
        ],
        'points_verification' => [
            'État général des murs et plafonds',
            'État des fenêtres (simple/double vitrage)',
            'État de l\'installation électrique',
            'État de la plomberie',
            'Isolation phonique entre étages',
        ],
    ],
    'maison' => [
        'questions_agent' => [
            'Motif de vente du propriétaire ?',
            'Travaux récents effectués ?',
            'Assainissement (tout-à-l\'égout ou fosse) ?',
            'Problèmes connus (humidité, fissures) ?',
        ],
        'documents' => [
            'DPE',
            'Diagnostics obligatoires',
            'Plans cadastraux',
            'Titre de propriété',
            'Certificat de conformité assainissement',
        ],
        'points_verification' => [
            'État de la toiture (date dernière réfection)',
            'État des façades (fissures)',
            'État charpente et combles',
            'État installation électrique',
            'État plomberie et chauffage',
            'État extérieurs (portail, clôtures)',
        ],
    ],
    // immeuble, terrain, etc.
];
```

### Logique de génération — ChecklistService

```php
class ChecklistService
{
    public function generateForProperty(Property $property): Checklist
    {
        $templates = config('checklist_templates');
        $propertyType = $property->type; // appartement, maison, etc.

        if (!isset($templates[$propertyType])) {
            $propertyType = 'appartement'; // fallback
        }

        $checklist = Checklist::create([
            'id' => Str::uuid(),
            'property_id' => $property->id,
        ]);

        $order = 1;
        foreach ($templates[$propertyType] as $category => $items) {
            foreach ($items as $label) {
                ChecklistItem::create([
                    'id' => Str::uuid(),
                    'checklist_id' => $checklist->id,
                    'category' => $category,
                    'label' => $label,
                    'is_checked' => false,
                    'order' => $order++,
                ]);
            }
        }

        return $checklist->load('items');
    }
}
```

### Event/Listener

```php
// app/Events/PropertyStatusChanged.php
class PropertyStatusChanged
{
    public function __construct(public Property $property, public string $newStatus) {}
}

// app/Listeners/GenerateChecklistOnRdvStatus.php
class GenerateChecklistOnRdvStatus
{
    public function __construct(private ChecklistService $checklistService) {}

    public function handle(PropertyStatusChanged $event): void
    {
        if ($event->newStatus === 'RDV') {
            $existingChecklist = Checklist::where('property_id', $event->property->id)->first();
            if (!$existingChecklist) {
                $this->checklistService->generateForProperty($event->property);
            }
        }
    }
}
```

### API Endpoint

```php
// routes/api.php
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/properties/{property}/checklist', [ChecklistController::class, 'show']);
});

// app/Http/Controllers/Api/ChecklistController.php
class ChecklistController extends Controller
{
    public function show(Property $property): JsonResponse
    {
        $checklist = Checklist::with('items')->where('property_id', $property->id)->first();

        if (!$checklist) {
            return response()->json(['message' => 'Checklist non trouvée.'], 404);
        }

        return response()->json(new ChecklistResource($checklist));
    }
}
```

### Flutter ChecklistRepository

```dart
class ChecklistRepository {
  final AppDatabase _database;
  final ApiClient _apiClient;

  ChecklistRepository(this._database, this._apiClient);

  Future<ChecklistModel?> getChecklistForProperty(String propertyId) async {
    // Try local first
    final localChecklist = await _database.checklistsDao.getByPropertyId(propertyId);
    if (localChecklist != null) {
      final items = await _database.checklistItemsDao.getByChecklistId(localChecklist.id);
      return ChecklistModel.fromDrift(localChecklist, items);
    }

    // Fetch remote
    try {
      final response = await _apiClient.get('/properties/$propertyId/checklist');
      final checklist = ChecklistModel.fromJson(response.data);

      // Store locally
      await _database.checklistsDao.insert(checklist.toDrift());
      for (final item in checklist.items) {
        await _database.checklistItemsDao.insert(item.toDrift());
      }

      return checklist;
    } catch (e) {
      return null;
    }
  }

  Future<void> markItemChecked(String itemId, bool checked) async {
    await _database.checklistItemsDao.updateChecked(itemId, checked, DateTime.now());
  }
}
```

### Project Structure Notes

Structure cible après cette story :

**Backend (`backend-api/`) :**
```
app/
├── Events/
│   └── PropertyStatusChanged.php
├── Listeners/
│   └── GenerateChecklistOnRdvStatus.php
├── Models/
│   ├── Checklist.php
│   └── ChecklistItem.php
├── Services/
│   └── ChecklistService.php
├── Http/Controllers/Api/
│   └── ChecklistController.php
└── Http/Resources/
    ├── ChecklistResource.php
    └── ChecklistItemResource.php
database/migrations/
├── xxxx_create_checklists_table.php
└── xxxx_create_checklist_items_table.php
config/
└── checklist_templates.php
tests/Feature/
└── Checklist/
    └── ChecklistGenerationTest.php
```

**Frontend (`mobile-app/`) :**
```
lib/
├── core/db/tables/
│   ├── checklists_table.dart
│   └── checklist_items_table.dart
└── features/checklist/
    ├── data/
    │   ├── checklist_repository.dart
    │   └── models/
    │       ├── checklist_model.dart
    │       └── checklist_item_model.dart
    └── presentation/
        ├── cubit/
        │   ├── checklist_cubit.dart
        │   └── checklist_state.dart
        └── pages/
            └── checklist_page.dart
test/features/checklist/
└── data/
    └── checklist_repository_test.dart
```

### References

- [Source: architecture.md#Frontend Architecture] — Repository pattern, Bloc/Cubit par feature
- [Source: architecture.md#Data Architecture] — Drift + SQLCipher, sync delta incrémental
- [Source: architecture.md#Communication Patterns] — Laravel Events/Listeners
- [Source: architecture.md#Format Patterns] — UUID v4, snake_case DB/API, camelCase Dart
- [Source: architecture.md#Project Structure & Boundaries] — Structure folder-by-feature
- [Source: epics.md#Story 4.1] — Acceptance criteria, catégories checklist, adaptation type de bien

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
