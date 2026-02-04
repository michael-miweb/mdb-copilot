# Story 1.2: Connexion et deconnexion

Status: ready-for-dev

## Story

As a utilisateur inscrit,
I want me connecter et me deconnecter de mon compte,
so that j'accede a mes donnees de maniere securisee.

## Acceptance Criteria

**Given** un utilisateur inscrit
**When** il soumet ses identifiants (email, mot de passe) sur l'ecran de connexion
**Then** un token Sanctum est retourne et stocke
**And** les requetes API incluent le token Bearer
**And** l'utilisateur est redirige vers le Dashboard

**Given** des identifiants incorrects
**When** l'utilisateur tente de se connecter
**Then** une erreur "Email ou mot de passe incorrect" s'affiche
**And** aucune indication ne revele si l'email existe ou non

**Given** un utilisateur connecte
**When** il choisit de se deconnecter
**Then** le token Sanctum est revoque cote serveur
**And** le stockage local du token est efface
**And** l'utilisateur est redirige vers l'ecran de connexion

## Tasks / Subtasks

### Backend (Laravel)
- [ ] Creer `POST /api/auth/login` endpoint
- [ ] Validation credentials et retour token Sanctum
- [ ] Message erreur generique (ne pas reveler si email existe)
- [ ] Creer `POST /api/auth/logout` endpoint
- [ ] Revoquer token courant cote serveur

### Mobile (Flutter)
- [ ] Creer `LoginPage` dans `lib/features/auth/presentation/pages/`
- [ ] Implementer `LoginCubit` avec etats: initial, loading, success, error
- [ ] Creer formulaire avec champs: email, mot de passe
- [ ] Stocker token dans SecureStorage apres login success
- [ ] Configurer intercepteur HTTP pour ajouter Bearer token
- [ ] Implementer logout: clear token local + appel API
- [ ] Redirection vers LoginPage apres logout

### Navigation
- [ ] Configurer GoRouter avec guards auth
- [ ] Redirect vers login si token absent/expire
- [ ] Redirect vers dashboard si deja connecte

### Tests
- [ ] Test unitaire backend: login success
- [ ] Test unitaire backend: login echec (mauvais password)
- [ ] Test unitaire backend: logout revoke token
- [ ] Test widget Flutter: formulaire login
- [ ] Test cubit: login/logout flow
- [ ] Test integration: auth guard GoRouter

## Dev Notes

### Architecture Reference
- Token Sanctum stocke dans SecureStorage (mobile)
- Intercepteur Dio pour injection Bearer token automatique
- GoRouter pour navigation declarative avec guards

### API Contract
```json
POST /api/auth/login
Request:
{
  "email": "string",
  "password": "string"
}

Response 200:
{
  "user": { "id": "uuid", "first_name": "...", "last_name": "...", "email": "..." },
  "token": "string"
}

Response 401:
{
  "message": "Email ou mot de passe incorrect"
}

POST /api/auth/logout
Headers: Authorization: Bearer {token}

Response 200:
{
  "message": "Deconnexion reussie"
}
```

### References
- [Source: epics.md#Story 1.2]
- [Source: architecture.md#Sanctum RBAC]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
