# Story 2.3 : Modification et suppression d'une fiche annonce

Status: ready-for-dev

## Story

As a utilisateur,
I want modifier ou supprimer une fiche annonce,
So that mes données restent à jour et je peux nettoyer mon portfolio.

## Acceptance Criteria

1. **Given** l'écran détail d'une fiche
   **When** l'utilisateur modifie un champ et sauvegarde
   **Then** les modifications sont enregistrées localement et synchronisées
   **And** le champ `updated_at` est mis à jour

2. **Given** l'écran détail d'une fiche
   **When** l'utilisateur choisit de supprimer la fiche
   **Then** une confirmation est demandée
   **And** si confirmé, la fiche est soft-deleted (marquée `deleted_at`)
   **And** la fiche disparaît de la liste

## Tasks / Subtasks

- [ ] Task 1 : Compléter PropertyRepository avec update et delete (AC: #1, #2)
  - [ ] 1.1 Dans `lib/features/properties/data/property_local_source.dart` :
    - S'assurer que `update(PropertyModel property)` est implémenté avec :
      - `updated_at` mis à jour automatiquement
      - `syncStatus` marqué `'pending'`
    - S'assurer que `delete(String id)` fait un soft delete :
      - Update `deleted_at` à `DateTime.now()`
      - `syncStatus` marqué `'pending'`
  - [ ] 1.2 Dans `lib/features/properties/data/property_remote_source.dart` :
    - S'assurer que `update(String id, PropertyModel property)` appelle `PUT /api/properties/{id}`
    - S'assurer que `delete(String id)` appelle `DELETE /api/properties/{id}`
  - [ ] 1.3 Dans `lib/features/properties/data/property_repository.dart` :
    - Méthode `Future<void> updateProperty(PropertyModel property)` : update local, tente sync remote
    - Méthode `Future<void> deleteProperty(String id)` : soft delete local, tente sync remote

- [ ] Task 2 : Compléter PropertyController backend (AC: #1, #2)
  - [ ] 2.1 Créer `app/Http/Requests/UpdatePropertyRequest.php` avec mêmes règles que Store (tous optionnels sauf ID)
  - [ ] 2.2 Dans `app/Http/Controllers/Api/PropertyController.php` :
    - Méthode `update(UpdatePropertyRequest $request, Property $property)` :
      - Vérifier ownership : `$property->user_id === $request->user()->id`
      - Update via `$property->update($request->validated())`
      - Retourne `PropertyResource::make($property)`
    - Méthode `destroy(Property $property)` :
      - Vérifier ownership
      - Soft delete : `$property->delete()` (utilise trait SoftDeletes)
      - Retourne 204 No Content
  - [ ] 2.3 Ajouter middleware dans routes : vérifier ownership via Policy ou inline

- [ ] Task 3 : Ajouter states et méthodes au PropertyCubit (AC: #1, #2)
  - [ ] 3.1 Dans `lib/features/properties/presentation/cubit/property_state.dart` :
    - Ajouter `PropertyUpdated(PropertyModel property)`
    - Ajouter `PropertyDeleted(String id)`
  - [ ] 3.2 Dans `lib/features/properties/presentation/cubit/property_cubit.dart` :
    - Méthode `updateProperty(PropertyModel property)` → emit `PropertyUpdated` ou `PropertyError`
    - Méthode `deleteProperty(String id)` → emit `PropertyDeleted` ou `PropertyError`

- [ ] Task 4 : Créer l'écran de modification (AC: #1)
  - [ ] 4.1 Créer `lib/features/properties/presentation/pages/edit_property_page.dart` avec :
    - Paramètre route : `String propertyId`
    - Récupération de la fiche depuis PropertyCubit state
    - Form pré-rempli avec toutes les valeurs existantes (réutiliser widgets de CreatePropertyPage)
    - Bouton "Sauvegarder" qui appelle `propertyCubit.updateProperty(updatedProperty)`
    - Validation identique à création
  - [ ] 4.2 Réutiliser `property_form_fields.dart` de Story 2.1 pour cohérence UI
  - [ ] 4.3 Ajouter la route dans `lib/app/routes.dart` : `/properties/:id/edit`
  - [ ] 4.4 Dans `PropertyDetailPage`, ajouter bouton "Modifier" → navigation vers `/properties/{id}/edit`

- [ ] Task 5 : Implémenter suppression avec confirmation (AC: #2)
  - [ ] 5.1 Dans `PropertyDetailPage`, ajouter bouton "Supprimer" (rouge, destructive)
  - [ ] 5.2 Au tap, afficher dialog de confirmation adaptative :
    - iOS : `CupertinoAlertDialog`
    - Android : `AlertDialog`
    - Message : "Êtes-vous sûr de vouloir supprimer cette fiche ? Cette action ne peut pas être annulée."
    - Actions : "Annuler" (dismiss), "Supprimer" (destructive)
  - [ ] 5.3 Si confirmé, appeler `propertyCubit.deleteProperty(propertyId)`
  - [ ] 5.4 Écouter state `PropertyDeleted` → navigation retour vers liste (pop)
  - [ ] 5.5 Créer widget réutilisable `lib/core/widgets/confirmation_dialog.dart` pour dialogs adaptatifs

- [ ] Task 6 : Gérer la synchronisation des modifications (AC: #1, #2)
  - [ ] 6.1 Vérifier que `syncStatus: pending` est bien marqué dans property_local_source lors update/delete
  - [ ] 6.2 S'assurer que le SyncEngine (core/sync/) prendra en charge la sync (sera implémenté dans Epic 11)
  - [ ] 6.3 Ajouter indicateur visuel discret dans PropertyDetailPage si `syncStatus === 'pending'` (icône cloud offline)

- [ ] Task 7 : Tests unitaires et widget (AC: #1, #2)
  - [ ] 7.1 Créer `test/features/properties/data/property_repository_test.dart` :
    - Test `updateProperty()` marque `syncStatus: pending` et met à jour `updated_at`
    - Test `deleteProperty()` marque `deleted_at` et `syncStatus: pending`
  - [ ] 7.2 Créer `test/features/properties/presentation/cubit/property_cubit_test.dart` :
    - Test `updateProperty()` emit `PropertyUpdated`
    - Test `deleteProperty()` emit `PropertyDeleted`
  - [ ] 7.3 Créer `test/features/properties/presentation/pages/edit_property_page_test.dart` :
    - Test form pré-rempli avec valeurs fiche
    - Test sauvegarde appelle cubit.updateProperty
  - [ ] 7.4 Créer `tests/Feature/Property/PropertyControllerTest.php` backend :
    - Test PUT /api/properties/{id} retourne 200 avec données mises à jour
    - Test DELETE /api/properties/{id} retourne 204
    - Test ownership : user A ne peut pas modifier/supprimer fiche de user B (403)
  - [ ] 7.5 Vérifier lint : `very_good analyze` (Flutter) et `./vendor/bin/sail pint` (Laravel)

- [ ] Task 8 : Validation finale (AC: #1, #2)
  - [ ] 8.1 Test manuel : modifier fiche → vérifier sauvegarde locale + `updated_at` changé
  - [ ] 8.2 Test manuel : modifier en offline → vérifier `syncStatus: pending` + sync automatique au retour réseau
  - [ ] 8.3 Test manuel : supprimer fiche → vérifier dialog confirmation
  - [ ] 8.4 Test manuel : confirmer suppression → vérifier fiche disparaît de la liste
  - [ ] 8.5 Test manuel : vérifier en DB Drift que `deleted_at` est non null (soft delete)
  - [ ] 8.6 Test backend : PUT/DELETE via Postman ou Insomnia avec token Sanctum
  - [ ] 8.7 Commit : `git add . && git commit -m "feat: modification et suppression fiche annonce (Story 2.3)"`

## Dev Notes

### Architecture & Contraintes

- **Dépendance Stories 2.1, 2.2** : Cette story nécessite que le CRUD complet Property soit implémenté [Source: epics.md#Story 2.3]
- **Soft delete obligatoire** : Jamais de suppression physique, toujours marquer `deleted_at` [Source: architecture.md#Data Architecture]
- **Sync status pending** : Toute modification locale marque `syncStatus: 'pending'` pour synchronisation ultérieure [Source: architecture.md#Process Patterns]
- **Ownership backend** : Le controller doit vérifier que `property.user_id === auth.user.id` avant toute action [Source: architecture.md#Authentication & Security]
- **Confirmation suppression** : UX obligatoire pour action destructive [Source: epics.md#Story 2.3, AC #2]

### Soft delete Drift

```dart
// lib/features/properties/data/property_local_source.dart
Future<void> delete(String id) async {
  final companion = PropertiesTableCompanion(
    id: Value(id),
    deletedAt: Value(DateTime.now()),
    updatedAt: Value(DateTime.now()),
    syncStatus: Value('pending'),
  );

  await (update(propertiesTable)..where((t) => t.id.equals(id)))
      .write(companion);
}
```

### Update avec updated_at automatique

```dart
// lib/features/properties/data/property_local_source.dart
Future<void> update(PropertyModel property) async {
  final companion = property.toCompanion(
    updatedAt: DateTime.now(),
    syncStatus: 'pending',
  );

  await (update(propertiesTable)..where((t) => t.id.equals(property.id)))
      .write(companion);
}
```

### Backend soft delete (Laravel)

```php
// app/Models/Property.php
use Illuminate\Database\Eloquent\SoftDeletes;

class Property extends Model
{
    use HasUuids, SoftDeletes;
    // ...
}

// app/Http/Controllers/Api/PropertyController.php
public function destroy(Property $property, Request $request)
{
    if ($property->user_id !== $request->user()->id) {
        abort(403, 'Unauthorized');
    }

    $property->delete(); // soft delete via trait

    return response()->noContent();
}
```

### Dialog confirmation adaptatif

```dart
// lib/core/widgets/confirmation_dialog.dart
Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Confirmer',
  String cancelText = 'Annuler',
}) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(confirmText),
        ),
      ],
    ),
  );
}
```

### Bouton supprimer dans PropertyDetailPage

```dart
// lib/features/properties/presentation/pages/property_detail_page.dart
IconButton(
  icon: Icon(Icons.delete, color: Colors.red),
  onPressed: () async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Supprimer la fiche',
      message: 'Êtes-vous sûr de vouloir supprimer cette fiche ? Cette action ne peut pas être annulée.',
      confirmText: 'Supprimer',
    );

    if (confirmed == true) {
      context.read<PropertyCubit>().deleteProperty(widget.propertyId);
    }
  },
)

// Écouter state deletion
BlocListener<PropertyCubit, PropertyState>(
  listener: (context, state) {
    if (state is PropertyDeleted) {
      Navigator.pop(context); // retour à la liste
    }
  },
  child: ...,
)
```

### Routes API avec ownership check

```php
// routes/api.php
Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('properties', PropertyController::class);
    // Laravel vérifie automatiquement via route model binding
});

// Alternative : Policy
// php artisan make:policy PropertyPolicy --model=Property
class PropertyPolicy
{
    public function update(User $user, Property $property): bool
    {
        return $user->id === $property->user_id;
    }

    public function delete(User $user, Property $property): bool
    {
        return $user->id === $property->user_id;
    }
}

// Controller
public function update(UpdatePropertyRequest $request, Property $property)
{
    $this->authorize('update', $property);
    // ...
}
```

### Project Structure Notes

Cette story complète la feature `properties` avec modification et suppression :

```
mobile-app/
├── lib/
│   ├── core/widgets/
│   │   └── confirmation_dialog.dart
│   └── features/properties/
│       ├── data/
│       │   ├── property_local_source.dart (complété avec update/delete)
│       │   ├── property_remote_source.dart (complété avec update/delete)
│       │   └── property_repository.dart (complété avec update/delete)
│       └── presentation/
│           ├── cubit/
│           │   ├── property_cubit.dart (complété)
│           │   └── property_state.dart (ajout PropertyUpdated, PropertyDeleted)
│           ├── pages/
│           │   ├── edit_property_page.dart
│           │   └── property_detail_page.dart (boutons modifier/supprimer)
│           └── widgets/
│               └── property_form_fields.dart (réutilisé)
├── test/features/properties/
│   ├── data/property_repository_test.dart
│   ├── presentation/
│   │   ├── cubit/property_cubit_test.dart
│   │   └── pages/edit_property_page_test.dart
backend-api/
├── app/
│   ├── Http/
│   │   ├── Controllers/Api/PropertyController.php (update, destroy)
│   │   └── Requests/UpdatePropertyRequest.php
│   └── Policies/PropertyPolicy.php (optionnel)
└── tests/Feature/Property/
    └── PropertyControllerTest.php (test update, delete, ownership)
```

[Source: architecture.md#Project Structure & Boundaries]

### References

- [Source: architecture.md#Data Architecture] — Soft deletes obligatoires
- [Source: architecture.md#Process Patterns] — Sync offline, syncStatus pending
- [Source: architecture.md#Authentication & Security] — Ownership vérification
- [Source: architecture.md#Frontend Architecture] — Bloc states, confirmation dialogs
- [Source: architecture.md#Implementation Patterns & Consistency Rules] — Repository pattern, updated_at automatique
- [Source: epics.md#Story 2.3] — Acceptance criteria BDD, dépendances Stories 2.1, 2.2

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
