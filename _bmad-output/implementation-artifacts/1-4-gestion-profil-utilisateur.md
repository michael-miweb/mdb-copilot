# Story 1.4: Gestion du profil utilisateur

Status: ready-for-dev

## Story

As a utilisateur connecte,
I want modifier mon prenom, nom, email et mot de passe,
so that mes informations personnelles restent a jour.

## Acceptance Criteria

**Given** un utilisateur connecte
**When** il accede a l'ecran Profil
**Then** ses informations actuelles (prenom, nom, email) sont affichees

**Given** l'ecran Profil
**When** l'utilisateur modifie son prenom ou nom et sauvegarde
**Then** les modifications sont enregistrees cote serveur
**And** l'UI reflete les changements immediatement

**Given** l'ecran Profil
**When** l'utilisateur modifie son email
**Then** une verification de l'email peut etre requise (optionnel MVP)
**And** l'email est mis a jour apres validation

**Given** l'ecran Profil
**When** l'utilisateur modifie son mot de passe (ancien + nouveau + confirmation)
**Then** le mot de passe est mis a jour si l'ancien est correct
**And** une erreur s'affiche si l'ancien mot de passe est incorrect
**And** une erreur s'affiche si nouveau et confirmation ne correspondent pas

## Tasks / Subtasks

### Backend (Laravel)
- [ ] Creer `GET /api/user/profile` endpoint (retourne user connecte)
- [ ] Creer `PUT /api/user/profile` endpoint (update prenom, nom, email)
- [ ] Validation email unique (sauf si meme user)
- [ ] Creer `PUT /api/user/password` endpoint
- [ ] Valider ancien mot de passe avant update
- [ ] Valider nouveau mot de passe = confirmation

### Mobile (Flutter)
- [ ] Creer `ProfilePage` dans `lib/features/profile/presentation/pages/`
- [ ] Implementer `ProfileCubit` avec etats: loading, loaded, updating, error
- [ ] Afficher informations actuelles (prenom, nom, email)
- [ ] Formulaire edition infos personnelles
- [ ] Section separee pour changement mot de passe
- [ ] Feedback visuel sur sauvegarde (success/error)

### UX
- [ ] Sauvegarde auto-save ou bouton explicite (decider)
- [ ] Confirmation avant changement email
- [ ] Masquer/afficher mot de passe (toggle visibility)

### Tests
- [ ] Test unitaire backend: update profil success
- [ ] Test unitaire backend: email unique validation
- [ ] Test unitaire backend: changement password avec ancien correct
- [ ] Test unitaire backend: changement password avec ancien incorrect
- [ ] Test widget Flutter: affichage profil
- [ ] Test cubit: update profil flow

## Dev Notes

### Architecture Reference
- Endpoint profile protege par middleware `auth:sanctum`
- Mise a jour `updated_at` automatique sur User model
- Pattern Repository pour UserRepository

### API Contract
```json
GET /api/user/profile
Headers: Authorization: Bearer {token}

Response 200:
{
  "id": "uuid",
  "first_name": "string",
  "last_name": "string",
  "email": "string",
  "created_at": "datetime",
  "updated_at": "datetime"
}

PUT /api/user/profile
Headers: Authorization: Bearer {token}
Request:
{
  "first_name": "string",
  "last_name": "string",
  "email": "string"
}

Response 200:
{
  "id": "uuid",
  "first_name": "string",
  "last_name": "string",
  "email": "string",
  "updated_at": "datetime"
}

PUT /api/user/password
Headers: Authorization: Bearer {token}
Request:
{
  "current_password": "string",
  "password": "string",
  "password_confirmation": "string"
}

Response 200:
{
  "message": "Mot de passe mis a jour"
}

Response 422:
{
  "message": "Ancien mot de passe incorrect"
}
```

### References
- [Source: epics.md#Story 1.4]
- [Source: architecture.md#Repository pattern]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
