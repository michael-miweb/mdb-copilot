# Story 4.2 : Consultation et cochage de la checklist

Status: ready-for-dev

## Story

As a utilisateur,
I want consulter ma checklist pré-visite et cocher les éléments au fur et à mesure,
So that je prépare méthodiquement chaque visite.

## Acceptance Criteria

1. **Given** une fiche avec une checklist générée
   **When** l'utilisateur accède à la checklist depuis la fiche
   **Then** tous les items sont affichés par catégorie avec leur état (coché/non coché)

2. **Given** un item de checklist non coché
   **When** l'utilisateur le coche
   **Then** l'état est mis à jour immédiatement
   **And** la progression globale (X/Y items complétés) est affichée
   **And** la modification est synchronisée

3. **Given** la checklist
   **When** tous les items sont cochés
   **Then** un indicateur visuel confirme que la préparation est complète

## Tasks / Subtasks

- [ ] Task 1 : Créer l'API backend pour mise à jour checklist item (AC: #2)
  - [ ] 1.1 Créer `UpdateChecklistItemRequest` avec validation : `is_checked` (boolean required)
  - [ ] 1.2 Ajouter la méthode `update(ChecklistItem $item, UpdateChecklistItemRequest $request)` dans `ChecklistController`
  - [ ] 1.3 Créer la route `PATCH /api/checklist-items/{item}` dans `api.php` avec middleware `auth:sanctum`
  - [ ] 1.4 Mettre à jour le champ `is_checked` et `updated_at` du ChecklistItem
  - [ ] 1.5 Retourner `ChecklistItemResource` avec le statut 200
  - [ ] 1.6 Ajouter tests Feature : cochage item, vérification updated_at

- [ ] Task 2 : Étendre le ChecklistRepository Flutter pour le cochage (AC: #2)
  - [ ] 2.1 Ajouter la méthode `markItemChecked(String itemId, bool checked)` dans `ChecklistRepository`
  - [ ] 2.2 Update local Drift : `UPDATE checklist_items SET is_checked = ?, updated_at = ?, sync_status = 'pending' WHERE id = ?`
  - [ ] 2.3 Marquer l'item comme `syncStatus: pending` pour synchronisation ultérieure
  - [ ] 2.4 Si connecté, appeler l'API `PATCH /api/checklist-items/{itemId}` immédiatement
  - [ ] 2.5 Si succès API, marquer `syncStatus: synced`
  - [ ] 2.6 Si échec réseau, laisser `syncStatus: pending` pour sync automatique ultérieure

- [ ] Task 3 : Implémenter le ChecklistCubit pour gestion du state (AC: #1, #2, #3)
  - [ ] 3.1 Créer les states : `ChecklistInitial`, `ChecklistLoading`, `ChecklistLoaded(checklist, progressText, isComplete)`, `ChecklistError(message)`
  - [ ] 3.2 Implémenter `loadChecklistForProperty(String propertyId)` : appeler Repository → émettre `ChecklistLoaded`
  - [ ] 3.3 Implémenter `toggleItemChecked(String itemId, bool checked)` : appeler Repository → reload checklist → émettre `ChecklistLoaded` avec progression mise à jour
  - [ ] 3.4 Calculer la progression : compter items cochés / total items
  - [ ] 3.5 Détecter completion : si tous items cochés, passer `isComplete: true` dans le state
  - [ ] 3.6 Émettre `ChecklistError` en cas d'échec Repository

- [ ] Task 4 : Créer l'UI ChecklistPage avec affichage par catégorie (AC: #1, #2, #3)
  - [ ] 4.1 Créer `checklist_page.dart` dans `lib/features/checklist/presentation/pages/`
  - [ ] 4.2 Afficher un `BlocBuilder<ChecklistCubit, ChecklistState>` gérant les states Loading/Loaded/Error
  - [ ] 4.3 Grouper les items par catégorie (questions_agent, documents, points_verification)
  - [ ] 4.4 Afficher chaque catégorie avec un titre (ex: "Questions à poser à l'agent") et la liste des items
  - [ ] 4.5 Pour chaque item : afficher un `CheckboxListTile` avec `value: item.isChecked`
  - [ ] 4.6 Sur `onChanged`, appeler `context.read<ChecklistCubit>().toggleItemChecked(item.id, newValue)`
  - [ ] 4.7 Afficher un header avec la progression globale : "X / Y complétés"

- [ ] Task 5 : Ajouter l'indicateur visuel de completion (AC: #3)
  - [ ] 5.1 Créer un widget `ChecklistCompletionBanner` affichant un message de félicitation si `isComplete: true`
  - [ ] 5.2 Afficher une icône verte (checkmark) et un texte "Préparation complète !"
  - [ ] 5.3 Positionner le banner en haut de la checklist si tous items sont cochés
  - [ ] 5.4 Utiliser les couleurs MDB du design system (`mdb_ui` package) pour cohérence

- [ ] Task 6 : Gérer la synchronisation des items cochés (AC: #2)
  - [ ] 6.1 Intégrer les ChecklistItems dans le `SyncEngine` existant
  - [ ] 6.2 Lors du sync batch (`POST /api/sync`), inclure les items `syncStatus: pending` dans le payload
  - [ ] 6.3 Créer l'endpoint `POST /api/sync` dans `SyncController` pour recevoir les deltas checklist items
  - [ ] 6.4 Appliquer les mises à jour côté serveur (last-write-wins via `updated_at`)
  - [ ] 6.5 Retourner les items synchronisés avec leur nouveau `updated_at` pour mise à jour locale

- [ ] Task 7 : Connecter ChecklistPage à la navigation (AC: #1)
  - [ ] 7.1 Ajouter un bouton "Checklist pré-visite" dans `PropertyDetailPage` si statut >= "RDV"
  - [ ] 7.2 Créer une route GoRouter `/properties/:propertyId/checklist` vers `ChecklistPage`
  - [ ] 7.3 Passer le `propertyId` en paramètre et déclencher `loadChecklistForProperty()` dans `initState`
  - [ ] 7.4 Afficher un placeholder "Aucune checklist disponible" si checklist vide (statut < "RDV")

- [ ] Task 8 : Validation finale (AC: #1, #2, #3)
  - [ ] 8.1 Tester backend : `PATCH /api/checklist-items/{uuid}` avec `is_checked: true` → vérifier update DB
  - [ ] 8.2 Tester Flutter online : cocher un item → vérifier appel API + update local immédiat
  - [ ] 8.3 Tester Flutter offline : cocher un item → vérifier update local + `syncStatus: pending`
  - [ ] 8.4 Tester sync : revenir online → vérifier synchronisation automatique des items cochés
  - [ ] 8.5 Tester completion : cocher tous les items → vérifier affichage banner "Préparation complète !"
  - [ ] 8.6 Tester progression : vérifier affichage "X / Y complétés" en temps réel
  - [ ] 8.7 Commit : `git add . && git commit -m "feat: consultation et cochage checklist pré-visite avec sync

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"`

## Dev Notes

### Architecture & Contraintes

- **Depends on Story 4.1** : Cette story nécessite que les modèles Checklist/ChecklistItem (backend + Drift) soient déjà créés [Source: epics.md#Story 4.1]
- **Optimistic UI update** : Cocher un item met à jour immédiatement l'UI locale (Drift), puis synchronise en arrière-plan [Source: architecture.md#Data Architecture]
- **Sync engine** : Les ChecklistItems cochés sont marqués `syncStatus: pending` et inclus dans le batch sync [Source: architecture.md#Data Architecture]
- **Repository pattern** : Le `ChecklistRepository` abstrait local (Drift) et remote (API), le Cubit ne connaît que le Repository [Source: architecture.md#Frontend Architecture]
- **Offline-first** : L'utilisateur peut cocher des items hors ligne, la sync se déclenche au retour du réseau [Source: architecture.md#Core Architectural Decisions]

### Versions techniques confirmées

- **Drift reactive queries** : Utiliser `watchChecklistForProperty()` pour écouter les changements locaux et mettre à jour l'UI en temps réel [Source: architecture.md#DB locale Flutter]
- **BlocListener** : Pour afficher les snackbars d'erreur sans polluer le BlocBuilder [Source: architecture.md#Communication Patterns]
- **UUID v4** : Tous les IDs (checklist_items) [Source: architecture.md#Format Patterns]
- **Last-write-wins** : Résolution de conflit via `updated_at` si deux appareils cochent le même item [Source: architecture.md#Data Architecture]

### API Endpoint Update

**Endpoint :**
```
PATCH /api/checklist-items/{item}
Headers: Authorization: Bearer {token}
Body: { "is_checked": true }
Response 200: ChecklistItemResource
```

**Controller Laravel :**
```php
// app/Http/Controllers/Api/ChecklistController.php
class ChecklistController extends Controller
{
    public function updateItem(ChecklistItem $item, UpdateChecklistItemRequest $request): JsonResponse
    {
        $item->update([
            'is_checked' => $request->is_checked,
            'updated_at' => now(),
        ]);

        return response()->json(new ChecklistItemResource($item));
    }
}

// routes/api.php
Route::middleware('auth:sanctum')->group(function () {
    Route::patch('/checklist-items/{item}', [ChecklistController::class, 'updateItem']);
});
```

**Request Validation :**
```php
// app/Http/Requests/UpdateChecklistItemRequest.php
class UpdateChecklistItemRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'is_checked' => 'required|boolean',
        ];
    }
}
```

### Flutter ChecklistRepository — markItemChecked

```dart
class ChecklistRepository {
  final AppDatabase _database;
  final ApiClient _apiClient;
  final ConnectivityMonitor _connectivityMonitor;

  ChecklistRepository(this._database, this._apiClient, this._connectivityMonitor);

  Future<void> markItemChecked(String itemId, bool checked) async {
    // Update local immediately (optimistic UI)
    await _database.checklistItemsDao.updateChecked(
      itemId,
      checked,
      DateTime.now(),
      syncStatus: 'pending',
    );

    // Try to sync immediately if online
    if (_connectivityMonitor.isConnected) {
      try {
        await _apiClient.patch('/checklist-items/$itemId', data: {
          'is_checked': checked,
        });

        // Mark as synced
        await _database.checklistItemsDao.updateSyncStatus(itemId, 'synced');
      } catch (e) {
        // Leave as pending, will be synced later by SyncEngine
        print('Failed to sync checklist item: $e');
      }
    }
  }

  Stream<ChecklistModel?> watchChecklistForProperty(String propertyId) {
    return _database.checklistsDao.watchByPropertyId(propertyId).map((checklist) {
      if (checklist == null) return null;

      final items = _database.checklistItemsDao.getByChecklistId(checklist.id);
      return ChecklistModel.fromDrift(checklist, items);
    });
  }
}
```

### ChecklistCubit State Management

```dart
// lib/features/checklist/presentation/cubit/checklist_state.dart
abstract class ChecklistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChecklistInitial extends ChecklistState {}

class ChecklistLoading extends ChecklistState {}

class ChecklistLoaded extends ChecklistState {
  final ChecklistModel checklist;
  final String progressText; // "8 / 15 complétés"
  final bool isComplete;

  ChecklistLoaded({
    required this.checklist,
    required this.progressText,
    required this.isComplete,
  });

  @override
  List<Object?> get props => [checklist, progressText, isComplete];
}

class ChecklistError extends ChecklistState {
  final String message;

  ChecklistError(this.message);

  @override
  List<Object?> get props => [message];
}
```

```dart
// lib/features/checklist/presentation/cubit/checklist_cubit.dart
class ChecklistCubit extends Cubit<ChecklistState> {
  final ChecklistRepository _repository;
  StreamSubscription? _checklistSubscription;

  ChecklistCubit(this._repository) : super(ChecklistInitial());

  void loadChecklistForProperty(String propertyId) {
    emit(ChecklistLoading());

    _checklistSubscription?.cancel();
    _checklistSubscription = _repository.watchChecklistForProperty(propertyId).listen(
      (checklist) {
        if (checklist == null) {
          emit(ChecklistError('Checklist non disponible'));
          return;
        }

        final totalItems = checklist.items.length;
        final checkedItems = checklist.items.where((item) => item.isChecked).length;
        final progressText = '$checkedItems / $totalItems complétés';
        final isComplete = checkedItems == totalItems;

        emit(ChecklistLoaded(
          checklist: checklist,
          progressText: progressText,
          isComplete: isComplete,
        ));
      },
      onError: (error) {
        emit(ChecklistError('Erreur de chargement: $error'));
      },
    );
  }

  Future<void> toggleItemChecked(String itemId, bool checked) async {
    try {
      await _repository.markItemChecked(itemId, checked);
      // State is updated automatically via the watchChecklistForProperty stream
    } catch (e) {
      emit(ChecklistError('Erreur de mise à jour: $e'));
    }
  }

  @override
  Future<void> close() {
    _checklistSubscription?.cancel();
    return super.close();
  }
}
```

### UI ChecklistPage

```dart
// lib/features/checklist/presentation/pages/checklist_page.dart
class ChecklistPage extends StatefulWidget {
  final String propertyId;

  const ChecklistPage({required this.propertyId, super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChecklistCubit>().loadChecklistForProperty(widget.propertyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checklist pré-visite')),
      body: BlocConsumer<ChecklistCubit, ChecklistState>(
        listener: (context, state) {
          if (state is ChecklistError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ChecklistLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChecklistLoaded) {
            return Column(
              children: [
                // Progress header
                _ProgressHeader(
                  progressText: state.progressText,
                  isComplete: state.isComplete,
                ),
                // Completion banner
                if (state.isComplete) const _CompletionBanner(),
                // Items by category
                Expanded(
                  child: _ChecklistItems(checklist: state.checklist),
                ),
              ],
            );
          }

          return const Center(child: Text('Aucune checklist disponible'));
        },
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final String progressText;
  final bool isComplete;

  const _ProgressHeader({required this.progressText, required this.isComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: isComplete ? Colors.green.shade50 : Colors.grey.shade100,
      child: Row(
        children: [
          Icon(
            isComplete ? Icons.check_circle : Icons.list_alt,
            color: isComplete ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            progressText,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _CompletionBanner extends StatelessWidget {
  const _CompletionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green.shade100,
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 32),
          const SizedBox(width: 12),
          Text(
            'Préparation complète !',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.green.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItems extends StatelessWidget {
  final ChecklistModel checklist;

  const _ChecklistItems({required this.checklist});

  @override
  Widget build(BuildContext context) {
    // Group items by category
    final groupedItems = <String, List<ChecklistItemModel>>{};
    for (final item in checklist.items) {
      groupedItems.putIfAbsent(item.category, () => []).add(item);
    }

    // Category labels
    const categoryLabels = {
      'questions_agent': 'Questions à poser à l\'agent',
      'documents': 'Documents à demander',
      'points_verification': 'Points à vérifier sur place',
    };

    return ListView(
      children: groupedItems.entries.map((entry) {
        final category = entry.key;
        final items = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                categoryLabels[category] ?? category,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...items.map((item) => CheckboxListTile(
              title: Text(item.label),
              value: item.isChecked,
              onChanged: (bool? value) {
                if (value != null) {
                  context.read<ChecklistCubit>().toggleItemChecked(item.id, value);
                }
              },
            )),
            const Divider(),
          ],
        );
      }).toList(),
    );
  }
}
```

### Drift DAO — updateChecked

```dart
// lib/core/db/daos/checklist_items_dao.dart
@DriftAccessor(tables: [ChecklistItemsTable])
class ChecklistItemsDao extends DatabaseAccessor<AppDatabase> with _$ChecklistItemsDaoMixin {
  ChecklistItemsDao(AppDatabase db) : super(db);

  Future<void> updateChecked(String id, bool isChecked, DateTime updatedAt, {String syncStatus = 'pending'}) {
    return (update(checklistItemsTable)..where((t) => t.id.equals(id))).write(
      ChecklistItemsTableCompanion(
        isChecked: Value(isChecked),
        updatedAt: Value(updatedAt),
        syncStatus: Value(syncStatus),
      ),
    );
  }

  Future<void> updateSyncStatus(String id, String syncStatus) {
    return (update(checklistItemsTable)..where((t) => t.id.equals(id))).write(
      ChecklistItemsTableCompanion(syncStatus: Value(syncStatus)),
    );
  }

  Future<List<ChecklistItem>> getByChecklistId(String checklistId) {
    return (select(checklistItemsTable)..where((t) => t.checklistId.equals(checklistId))..orderBy([(t) => OrderingTerm.asc(t.order)])).get();
  }

  Stream<List<ChecklistItem>> watchByChecklistId(String checklistId) {
    return (select(checklistItemsTable)..where((t) => t.checklistId.equals(checklistId))..orderBy([(t) => OrderingTerm.asc(t.order)])).watch();
  }
}
```

### SyncEngine Integration

```dart
// lib/core/sync/sync_engine.dart (extrait)
class SyncEngine {
  // ...

  Future<void> syncChecklistItems() async {
    final pendingItems = await _database.checklistItemsDao.getPendingSync();

    if (pendingItems.isEmpty) return;

    final payload = pendingItems.map((item) => {
      'id': item.id,
      'is_checked': item.isChecked,
      'updated_at': item.updatedAt.toIso8601String(),
    }).toList();

    try {
      final response = await _apiClient.post('/sync', data: {
        'checklist_items': payload,
      });

      // Mark as synced
      for (final item in pendingItems) {
        await _database.checklistItemsDao.updateSyncStatus(item.id, 'synced');
      }
    } catch (e) {
      // Retry later
      print('Sync failed: $e');
    }
  }
}
```

### Project Structure Notes

Structure cible après cette story :

**Backend (`backend-api/`) :**
```
app/Http/
├── Controllers/Api/
│   └── ChecklistController.php (updated: updateItem method)
└── Requests/
    └── UpdateChecklistItemRequest.php (new)
routes/api.php (updated: PATCH /checklist-items/{item})
tests/Feature/Checklist/
└── ChecklistUpdateTest.php (new)
```

**Frontend (`mobile-app/`) :**
```
lib/features/checklist/
├── data/
│   └── checklist_repository.dart (updated: markItemChecked, watchChecklistForProperty)
└── presentation/
    ├── cubit/
    │   ├── checklist_cubit.dart (new)
    │   └── checklist_state.dart (new)
    ├── pages/
    │   └── checklist_page.dart (new)
    └── widgets/
        ├── progress_header.dart (optional extraction)
        └── completion_banner.dart (optional extraction)
lib/core/db/daos/
└── checklist_items_dao.dart (new: updateChecked, updateSyncStatus, watchByChecklistId)
lib/core/sync/
└── sync_engine.dart (updated: syncChecklistItems integration)
test/features/checklist/
└── presentation/cubit/
    └── checklist_cubit_test.dart (new)
```

### References

- [Source: architecture.md#Frontend Architecture] — Bloc/Cubit state management, Repository pattern
- [Source: architecture.md#Data Architecture] — Optimistic UI update, sync engine, last-write-wins
- [Source: architecture.md#Communication Patterns] — BlocListener pour erreurs, BlocBuilder pour UI
- [Source: architecture.md#Process Patterns] — Loading states, error handling
- [Source: architecture.md#Format Patterns] — UUID v4, snake_case API, camelCase Dart
- [Source: epics.md#Story 4.2] — Acceptance criteria, progression X/Y, indicateur visuel completion
- [Source: epics.md#Story 4.1] — Dépendance modèles Checklist/ChecklistItem

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
