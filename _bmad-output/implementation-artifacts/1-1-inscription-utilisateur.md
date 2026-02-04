# Story 1.1: Inscription utilisateur

Status: ready-for-dev

## Story

As a utilisateur,
I want creer un compte avec prenom, nom, email et mot de passe,
so that j'accede a mon espace personnel MDB Copilot.

## Acceptance Criteria

**Given** un utilisateur non inscrit
**When** il soumet le formulaire d'inscription (prenom, nom, email, mot de passe, confirmation mot de passe)
**Then** un compte est cree avec mot de passe hashe (bcrypt)
**And** un token Sanctum est genere avec ability `owner`
**And** l'utilisateur est redirige vers l'ecran d'accueil
**And** le token est stocke de maniere securisee (SecureStore mobile, httpOnly cookie ou localStorage web)

**Given** un email deja utilise
**When** l'utilisateur tente de s'inscrire
**Then** une erreur "Cet email est deja utilise" s'affiche

**Given** un mot de passe trop faible
**When** l'utilisateur soumet le formulaire
**Then** une erreur de validation s'affiche avec les criteres requis

## Tasks / Subtasks

### Backend (Laravel)
- [ ] Creer `POST /api/auth/register` endpoint dans `AuthController`
- [ ] Implementer validation: email unique, mot de passe min 8 caracteres avec complexite
- [ ] Generer token Sanctum avec ability `owner` apres creation compte
- [ ] Retourner user + token en JSON

### Mobile (Flutter)
- [ ] Creer `RegisterPage` dans `lib/features/auth/presentation/pages/`
- [ ] Implementer `RegisterCubit` avec etats: initial, loading, success, error
- [ ] Creer formulaire avec champs: prenom, nom, email, mot de passe, confirmation
- [ ] Validation client-side avant soumission
- [ ] Stocker token dans SecureStorage via `AuthRepository`
- [ ] Redirection vers Home apres succes

### Tests
- [ ] Test unitaire backend: validation email unique
- [ ] Test unitaire backend: validation mot de passe
- [ ] Test unitaire backend: generation token avec ability owner
- [ ] Test widget Flutter: formulaire inscription
- [ ] Test cubit: etats register flow

## Dev Notes

### Architecture Reference
- Pattern Repository pour abstraction stockage token (local/remote)
- Bloc/Cubit pour gestion etats inscription
- Sanctum RBAC avec abilities: owner, guest-read, guest-extended

### API Contract
```json
POST /api/auth/register
Request:
{
  "first_name": "string",
  "last_name": "string",
  "email": "string",
  "password": "string",
  "password_confirmation": "string"
}

Response 201:
{
  "user": { "id": "uuid", "first_name": "...", "last_name": "...", "email": "..." },
  "token": "string"
}

Response 422:
{
  "message": "Validation failed",
  "errors": { "email": ["Cet email est deja utilise"] }
}
```

### References
- [Source: epics.md#Story 1.1]
- [Source: architecture.md#Sanctum RBAC]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
