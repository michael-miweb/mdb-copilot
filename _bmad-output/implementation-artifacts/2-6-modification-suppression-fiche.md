# Story 2.6: Modification et suppression d'une fiche annonce

Status: ready-for-dev

## Story

As a utilisateur,
I want modifier ou supprimer une fiche annonce,
so que mes donnees restent a jour.

## Acceptance Criteria

**Given** l'ecran detail d'une fiche
**When** l'utilisateur modifie un champ et sauvegarde
**Then** les modifications sont enregistrees
**And** le champ `updated_at` est mis a jour

**Given** l'ecran detail d'une fiche
**When** l'utilisateur modifie l'agent associe
**Then** la nouvelle association est enregistree
**And** l'ancien agent n'est pas supprime du carnet d'adresses

**Given** l'ecran detail d'une fiche
**When** l'utilisateur choisit de supprimer la fiche
**Then** une confirmation est demandee
**And** si confirme, la fiche est soft-deleted
**And** la fiche disparait de la liste

## Tasks / Subtasks

### Backend (Laravel)
- [ ] Creer `PUT /api/properties/{id}` endpoint
- [ ] Validation des champs modifiables
- [ ] Mise a jour updated_at automatique
- [ ] Gestion modification contact_id (association agent)
- [ ] Creer `DELETE /api/properties/{id}` endpoint
- [ ] Soft delete (deleted_at)
- [ ] Retourner 404 si property deja supprimee

### Mobile (Flutter)
- [ ] Creer `EditPropertyPage` ou mode edit dans PropertyDetailPage
- [ ] Implementer `EditPropertyCubit` avec etats: loading, saving, success, error
- [ ] Pre-remplir formulaire avec donnees existantes
- [ ] AgentSelectorWidget avec agent actuel pre-selectionne
- [ ] Bouton supprimer avec dialog confirmation
- [ ] Navigation retour liste apres suppression
- [ ] Mise a jour liste apres modification

### UX
- [ ] Mode visualisation vs mode edition distinct
- [ ] Bouton "Modifier" visible sur detail
- [ ] Confirmation suppression avec texte explicite
- [ ] Feedback sauvegarde (snackbar success)
- [ ] Gestion erreur reseau (retry)

### Tests
- [ ] Test unitaire backend: update property
- [ ] Test unitaire backend: update contact_id
- [ ] Test unitaire backend: soft delete
- [ ] Test widget Flutter: EditPropertyPage
- [ ] Test widget Flutter: dialog suppression
- [ ] Test cubit: update/delete flow

## Dev Notes

### Architecture Reference
- Soft delete pour toutes les suppressions (deleted_at)
- updated_at mis a jour automatiquement par Eloquent
- Sync engine gere les suppressions via syncStatus

### API Contract
```json
PUT /api/properties/{id}
Headers: Authorization: Bearer {token}
Request:
{
  "address": "string",
  "surface_m2": 80.0,
  "price_cents": 26000000,
  "property_type": "appartement",
  "contact_id": "uuid|null",
  "urgency_level": "high",
  "notes": "string"
}

Response 200:
{
  "id": "uuid",
  "address": "string",
  ...
  "updated_at": "2026-02-03T15:30:00Z"
}

Response 404:
{
  "message": "Property not found"
}

DELETE /api/properties/{id}
Headers: Authorization: Bearer {token}

Response 200:
{
  "message": "Fiche supprimee"
}

Response 404:
{
  "message": "Property not found"
}
```

### Soft Delete Flow
```php
// Model Property
use SoftDeletes;

// Controller
public function destroy(Property $property)
{
    $this->authorize('delete', $property);
    $property->delete(); // Sets deleted_at
    return response()->json(['message' => 'Fiche supprimee']);
}

// Query (auto-excludes soft deleted)
Property::where('user_id', $user->id)->get();

// Include soft deleted if needed
Property::withTrashed()->where('user_id', $user->id)->get();
```

### Confirmation Dialog
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Supprimer cette fiche ?'),
    content: Text('Cette action est irreversible. La fiche sera definitivement supprimee.'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Annuler'),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          cubit.deleteProperty(propertyId);
        },
        style: TextButton.styleFrom(foregroundColor: Colors.red),
        child: Text('Supprimer'),
      ),
    ],
  ),
);
```

### References
- [Source: epics.md#Story 2.6]
- [Source: prd.md#FR19]
- [Source: architecture.md#Soft delete pattern]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
