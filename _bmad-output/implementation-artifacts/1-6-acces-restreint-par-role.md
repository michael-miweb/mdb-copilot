# Story 1.6: Acces restreint par role

Status: ready-for-dev

## Story

As a utilisateur invite,
I want acceder uniquement aux donnees autorisees par mon role,
so that je consulte ce que le proprietaire m'a autorise.

## Acceptance Criteria

**Given** un utilisateur `guest-read`
**When** il accede a l'application
**Then** il peut consulter les fiches et le pipeline (lecture seule)
**And** il ne peut pas modifier, creer ou supprimer de donnees
**And** les boutons d'action (creer, modifier, supprimer) sont masques ou desactives

**Given** un utilisateur `guest-extended`
**When** il accede a l'application
**Then** il peut consulter et modifier les fiches selon les permissions etendues
**And** il ne peut pas inviter d'autres utilisateurs
**And** il ne peut pas modifier les parametres du compte owner

**Given** un utilisateur invite tentant une action non autorisee via API
**When** la requete est envoyee
**Then** une erreur 403 Forbidden est retournee
**And** l'action n'est pas executee

## Tasks / Subtasks

### Backend (Laravel)
- [ ] Creer middleware `CheckAbility` pour verifier abilities token
- [ ] Configurer abilities Sanctum:
  - `owner`: full access
  - `guest-read`: read-only endpoints
  - `guest-extended`: read + write (sauf invitations, settings)
- [ ] Proteger endpoints creation/modification avec ability check
- [ ] Retourner 403 si ability manquante
- [ ] Ajouter scope `forOwner()` sur queries pour filtrer donnees par owner_id

### Mobile (Flutter)
- [ ] Creer `AuthState` avec role courant
- [ ] Implementer `PermissionService` pour verifier permissions
- [ ] Masquer/desactiver boutons selon role:
  - `guest-read`: masquer FAB creation, boutons edit/delete
  - `guest-extended`: masquer bouton invitations
- [ ] Afficher feedback si action non autorisee tentee

### API Endpoints Protection
- [ ] GET endpoints: accessible tous roles authentifies
- [ ] POST/PUT/DELETE properties: owner + guest-extended
- [ ] POST/PUT/DELETE contacts: owner + guest-extended
- [ ] Invitations endpoints: owner only
- [ ] Profile/settings endpoints: owner only (sauf GET propre profil)

### Tests
- [ ] Test unitaire backend: guest-read ne peut pas POST
- [ ] Test unitaire backend: guest-read ne peut pas PUT
- [ ] Test unitaire backend: guest-read ne peut pas DELETE
- [ ] Test unitaire backend: guest-extended peut POST/PUT/DELETE
- [ ] Test unitaire backend: guest-extended ne peut pas inviter
- [ ] Test widget Flutter: boutons masques pour guest-read
- [ ] Test widget Flutter: boutons actifs pour guest-extended
- [ ] Test integration: flow complet avec different roles

## Dev Notes

### Architecture Reference
- Sanctum token abilities pour autorisation API
- Middleware Laravel pour check abilities
- UI conditionnelle basee sur role stocke dans AuthState

### Abilities Matrix
| Endpoint | owner | guest-extended | guest-read |
|----------|-------|----------------|------------|
| GET /properties | Y | Y | Y |
| POST /properties | Y | Y | N |
| PUT /properties/{id} | Y | Y | N |
| DELETE /properties/{id} | Y | Y | N |
| GET /contacts | Y | Y | Y |
| POST /contacts | Y | Y | N |
| GET /invitations | Y | N | N |
| POST /invitations | Y | N | N |
| PUT /user/profile | Y | N | N |

### Implementation Example
```php
// Middleware CheckAbility
public function handle($request, Closure $next, ...$abilities)
{
    if (!$request->user()->tokenCan(...$abilities)) {
        return response()->json(['message' => 'Acces non autorise'], 403);
    }
    return $next($request);
}

// Route protection
Route::post('/properties', [PropertyController::class, 'store'])
    ->middleware('abilities:owner,guest-extended');
```

```dart
// Flutter PermissionService
class PermissionService {
  final AuthCubit _authCubit;

  bool canCreate() {
    final role = _authCubit.state.role;
    return role == 'owner' || role == 'guest-extended';
  }

  bool canInvite() {
    return _authCubit.state.role == 'owner';
  }
}

// Widget conditional
if (permissionService.canCreate())
  FloatingActionButton(onPressed: _createProperty)
```

### References
- [Source: epics.md#Story 1.6]
- [Source: architecture.md#Sanctum RBAC]
- [Source: prd.md#FR6]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
