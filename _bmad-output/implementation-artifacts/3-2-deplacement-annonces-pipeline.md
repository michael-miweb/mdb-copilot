# Story 3.2 : Déplacement des annonces dans le pipeline

Status: ready-for-dev

## Story

As a utilisateur,
I want déplacer une annonce d'une étape à l'autre par drag & drop ou action,
So that je mets à jour la progression de mes projets.

## Acceptance Criteria

1. **Given** une fiche dans la colonne "Prospection"
   **When** l'utilisateur la déplace vers "RDV" (drag & drop ou menu action)
   **Then** le statut de la fiche est mis à jour
   **And** la fiche apparaît dans la nouvelle colonne
   **And** la modification est synchronisée au serveur

2. **Given** un déplacement de fiche
   **When** le statut passe à "RDV"
   **Then** l'événement est enregistré pour déclencher la checklist pré-visite (Epic 4)

## Tasks / Subtasks

- [ ] Task 1 : Dépendance Story 3.1 (AC: #1)
  - [ ] 1.1 Vérifier que Story 3.1 est complète et déployée
  - [ ] 1.2 Vérifier que `PipelineCubit` et `PipelineRepository` existent
  - [ ] 1.3 Vérifier que le widget `MdbKanbanColumn` affiche correctement

- [ ] Task 2 : Implémenter le drag & drop dans le Kanban (AC: #1)
  - [ ] 2.1 Créer `draggable_property_card.dart` dans `features/pipeline/presentation/widgets/`
  - [ ] 2.2 Wrapper `MdbPropertyCard` dans un `LongPressDraggable` avec feedback visuel
  - [ ] 2.3 Configurer `data` du Draggable avec l'objet Property
  - [ ] 2.4 Wrapper `MdbKanbanColumn` dans un `DragTarget<Property>`
  - [ ] 2.5 Implémenter `onAccept` du DragTarget pour appeler `PipelineCubit.moveProperty(property, newStatus)`

- [ ] Task 3 : Ajouter menu action alternatif (AC: #1)
  - [ ] 3.1 Ajouter un bouton menu (3 points) sur chaque `MdbPropertyCard`
  - [ ] 3.2 Afficher un bottom sheet avec liste des 9 statuts possibles
  - [ ] 3.3 Permettre la sélection du nouveau statut
  - [ ] 3.4 Appeler `PipelineCubit.moveProperty(property, selectedStatus)` lors de la sélection
  - [ ] 3.5 Fermer le bottom sheet après sélection

- [ ] Task 4 : Étendre le Cubit pour gérer le déplacement (AC: #1, #2)
  - [ ] 4.1 Ajouter la méthode `moveProperty(Property property, PropertyStatus newStatus)` dans `PipelineCubit`
  - [ ] 4.2 Appeler `PipelineRepository.updatePropertyStatus(property.id, newStatus)`
  - [ ] 4.3 Si le nouveau statut est `PropertyStatus.rdv`, émettre un événement `PropertyMovedToRdv(property.id)`
  - [ ] 4.4 Recharger le pipeline après déplacement réussi
  - [ ] 4.5 Gérer les erreurs et émettre `PipelineError` si échec
  - [ ] 4.6 Créer les tests unitaires pour `moveProperty()`

- [ ] Task 5 : Implémenter le repository pour le update status (AC: #1)
  - [ ] 5.1 Ajouter `updatePropertyStatus(String id, PropertyStatus status)` dans `PipelineRepository`
  - [ ] 5.2 Implémenter dans `PropertyLocalSource` : update Drift avec `syncStatus: pending`
  - [ ] 5.3 Implémenter dans `PropertyRemoteSource` : `PATCH /api/properties/{id}/status`
  - [ ] 5.4 Gérer le fallback offline : update local uniquement si pas de réseau
  - [ ] 5.5 Créer les tests pour le repository

- [ ] Task 6 : Créer l'API endpoint pour update status (AC: #1)
  - [ ] 6.1 Ajouter la méthode `updateStatus(Request $request, Property $property)` dans `PropertyController`
  - [ ] 6.2 Créer `UpdatePropertyStatusRequest` pour valider le champ `status`
  - [ ] 6.3 Mettre à jour `property->status` et `property->updated_at`
  - [ ] 6.4 Retourner `PropertyResource` avec status 200
  - [ ] 6.5 Ajouter la route `PATCH /api/properties/{property}/status` avec middleware `auth:sanctum`
  - [ ] 6.6 Créer les tests Feature pour l'endpoint

- [ ] Task 7 : Implémenter l'événement PropertyMovedToRdv (AC: #2)
  - [ ] 7.1 Créer `PropertyMovedToRdvEvent` dans `core/events/`
  - [ ] 7.2 Émettre l'événement depuis `PipelineCubit.moveProperty()` si nouveau status == `rdv`
  - [ ] 7.3 Créer un `EventBus` simple ou utiliser un Stream global pour diffuser l'événement
  - [ ] 7.4 Documenter que cet événement sera écouté par le ChecklistCubit (Epic 4)
  - [ ] 7.5 Créer les tests pour l'événement

- [ ] Task 8 : UX et feedback visuel (AC: #1)
  - [ ] 8.1 Afficher un indicateur de chargement sur la carte pendant le déplacement
  - [ ] 8.2 Afficher un feedback visuel (animation, shimmer) pendant le drag
  - [ ] 8.3 Afficher un SnackBar de confirmation après déplacement réussi
  - [ ] 8.4 Afficher un SnackBar d'erreur si le déplacement échoue
  - [ ] 8.5 Rollback UI optimiste si l'API échoue

- [ ] Task 9 : Validation finale (AC: #1, #2)
  - [ ] 9.1 Tester le drag & drop d'une carte entre colonnes
  - [ ] 9.2 Tester le menu action pour changer de statut
  - [ ] 9.3 Vérifier que la carte apparaît dans la nouvelle colonne après déplacement
  - [ ] 9.4 Vérifier que le statut est persisté localement et synchronisé au serveur
  - [ ] 9.5 Tester le déplacement en mode offline (update local uniquement, sync au retour réseau)
  - [ ] 9.6 Vérifier que l'événement `PropertyMovedToRdv` est émis quand une fiche passe à "RDV"
  - [ ] 9.7 Tester avec plusieurs fiches déplacées successivement
  - [ ] 9.8 Commit : `git add . && git commit -m "feat: déplacement annonces pipeline drag & drop + menu action, event RDV"`

## Dev Notes

### Architecture & Contraintes

- **Dépendance Story 3.1** : Cette story s'appuie sur le pipeline Kanban et les widgets créés en 3.1 [Source: epics.md#Story 3.2]
- **Drag & drop** : Utiliser les widgets Flutter natifs `Draggable` et `DragTarget` pour le drag & drop [Source: Flutter widgets]
- **Menu action alternatif** : Pour accessibilité et mobile, offrir une alternative au drag & drop via bottom sheet [Source: epics.md#FR14]
- **Événement RDV** : Déclencher un événement quand une fiche passe à "RDV" pour générer automatiquement la checklist pré-visite [Source: epics.md#FR18]
- **Update optimiste** : Mettre à jour l'UI immédiatement puis synchroniser en arrière-plan [Source: architecture.md#Process Patterns]
- **Offline-first** : Le déplacement fonctionne offline, marqué `syncStatus: pending` jusqu'à sync [Source: architecture.md#Data Architecture]

### Versions techniques confirmées

- **Flutter** : 3.38.x — support natif Draggable/DragTarget
- **Drift** : update local avec `syncStatus: pending`
- **Laravel** : endpoint PATCH pour update status
- **Sanctum** : authentification requise pour update

### Drag & Drop — Implementation

Draggable wrapper :
```dart
LongPressDraggable<Property>(
  data: property,
  feedback: Material(
    child: Opacity(
      opacity: 0.8,
      child: MdbPropertyCard(property: property),
    ),
  ),
  childWhenDragging: Opacity(
    opacity: 0.3,
    child: MdbPropertyCard(property: property),
  ),
  child: MdbPropertyCard(property: property),
)
```

DragTarget wrapper :
```dart
DragTarget<Property>(
  onAccept: (property) {
    context.read<PipelineCubit>().moveProperty(
      property,
      columnStatus, // Le status de cette colonne
    );
  },
  builder: (context, candidateData, rejectedData) {
    return MdbKanbanColumn(
      title: columnTitle,
      cards: cards,
      isHighlighted: candidateData.isNotEmpty,
    );
  },
)
```

### API Request — Update status

PATCH `/api/properties/{id}/status`

Request body :
```json
{
  "status": "rdv"
}
```

Response :
```json
{
  "data": {
    "id": "uuid-1",
    "adresse": "12 Rue de la Paix, Paris",
    "status": "rdv",
    "updated_at": "2026-01-27T15:30:00Z"
  }
}
```

Validation rules (UpdatePropertyStatusRequest) :
```php
return [
    'status' => ['required', 'string', Rule::in([
        'prospection', 'rdv', 'visite', 'analyse', 'offre',
        'achete', 'travaux', 'vente', 'vendu'
    ])],
];
```

### Événement PropertyMovedToRdv

```dart
class PropertyMovedToRdvEvent {
  PropertyMovedToRdvEvent(this.propertyId);

  final String propertyId;
}

// Dans PipelineCubit
Future<void> moveProperty(Property property, PropertyStatus newStatus) async {
  try {
    await _repository.updatePropertyStatus(property.id, newStatus);

    if (newStatus == PropertyStatus.rdv) {
      eventBus.fire(PropertyMovedToRdvEvent(property.id));
    }

    await loadPipeline(); // Recharger le pipeline
  } catch (e) {
    emit(PipelineError(e.toString()));
  }
}
```

Ce event sera écouté par `ChecklistCubit` (Epic 4) pour générer automatiquement la checklist pré-visite.

### UX — Update optimiste avec rollback

1. User drag la carte vers nouvelle colonne
2. UI met à jour immédiatement (optimistic update)
3. Appel API en arrière-plan
4. Si API échoue : rollback UI + afficher erreur
5. Si API réussit : sync confirmée

```dart
Future<void> moveProperty(Property property, PropertyStatus newStatus) async {
  final oldStatus = property.status;

  // Optimistic update
  emit(PipelineLoaded(
    _getUpdatedPipeline(property, newStatus),
  ));

  try {
    await _repository.updatePropertyStatus(property.id, newStatus);

    if (newStatus == PropertyStatus.rdv) {
      eventBus.fire(PropertyMovedToRdvEvent(property.id));
    }
  } catch (e) {
    // Rollback
    emit(PipelineLoaded(
      _getUpdatedPipeline(property, oldStatus),
    ));
    emit(PipelineError('Échec du déplacement : ${e.toString()}'));
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
│   │       │   └── pipeline_repository.dart (modifié : + updatePropertyStatus)
│   │       └── presentation/
│   │           ├── cubit/
│   │           │   ├── pipeline_cubit.dart (modifié : + moveProperty)
│   │           │   └── pipeline_state.dart
│   │           ├── pages/
│   │           │   └── pipeline_page.dart (modifié : + drag & drop)
│   │           └── widgets/
│   │               └── draggable_property_card.dart (nouveau)
│   └── core/
│       └── events/
│           └── property_moved_to_rdv_event.dart (nouveau)
└── test/
    └── features/
        └── pipeline/
            ├── cubit/
            │   └── pipeline_cubit_test.dart (modifié)
            └── widgets/
                └── draggable_property_card_test.dart (nouveau)

backend-api/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       └── PropertyController.php (modifié : + updateStatus)
│   │   └── Requests/
│   │       └── UpdatePropertyStatusRequest.php (nouveau)
│   └── Models/
│       └── Property.php
├── routes/
│   └── api.php (modifié : + PATCH route)
└── tests/
    └── Feature/
        └── Property/
            └── UpdatePropertyStatusTest.php (nouveau)
```

### References

- [Source: epics.md#Story 3.2] — User story et acceptance criteria complets
- [Source: epics.md#FR14] — Déplacement annonces drag & drop ou menu action
- [Source: epics.md#FR18] — Génération auto checklist au passage "RDV"
- [Source: architecture.md#Process Patterns] — Update optimiste, error handling
- [Source: architecture.md#Data Architecture] — Offline-first, syncStatus pending
- [Source: architecture.md#Communication Patterns] — Events pour communication inter-features
- [Source: architecture.md#API & Communication Patterns] — REST JSON, PATCH endpoint

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
