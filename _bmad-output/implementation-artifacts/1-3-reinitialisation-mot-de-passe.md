# Story 1.3: Reinitialisation du mot de passe

Status: ready-for-dev

## Story

As a utilisateur,
I want reinitialiser mon mot de passe via email,
so that je recupere l'acces a mon compte si j'oublie mon mot de passe.

## Acceptance Criteria

**Given** un utilisateur sur l'ecran "Mot de passe oublie"
**When** il saisit son email et soumet le formulaire
**Then** un email avec un lien de reinitialisation est envoye
**And** un message "Si cet email existe, vous recevrez un lien" s'affiche (securite)

**Given** un lien de reinitialisation valide
**When** l'utilisateur clique et saisit un nouveau mot de passe
**Then** le mot de passe est mis a jour
**And** tous les tokens existants sont revoques
**And** l'utilisateur est redirige vers la connexion avec un message de succes

**Given** un lien de reinitialisation expire (> 1h)
**When** l'utilisateur clique dessus
**Then** une erreur "Lien expire" s'affiche avec option de redemander

## Tasks / Subtasks

### Backend (Laravel)
- [ ] Creer `POST /api/auth/forgot-password` endpoint
- [ ] Generer token reset avec expiration 1h
- [ ] Envoyer email avec lien reset (Mailpit en dev)
- [ ] Message generique ne revelant pas si email existe
- [ ] Creer `POST /api/auth/reset-password` endpoint
- [ ] Valider token + expiration
- [ ] Mettre a jour mot de passe (bcrypt)
- [ ] Revoquer tous les tokens Sanctum de l'utilisateur
- [ ] Retourner erreur si token expire

### Mobile (Flutter)
- [ ] Creer `ForgotPasswordPage` dans `lib/features/auth/presentation/pages/`
- [ ] Formulaire avec champ email
- [ ] Afficher message succes generique
- [ ] Creer `ResetPasswordPage` (deep link depuis email)
- [ ] Formulaire avec nouveau mot de passe + confirmation
- [ ] Gestion erreur token expire
- [ ] Redirection vers login apres succes

### Email Template
- [ ] Creer template email reinitialisation
- [ ] Inclure lien avec token + expiration
- [ ] Design coherent avec charte MDB Copilot

### Tests
- [ ] Test unitaire backend: generation token reset
- [ ] Test unitaire backend: expiration token (> 1h)
- [ ] Test unitaire backend: revocation tokens apres reset
- [ ] Test widget Flutter: formulaire forgot password
- [ ] Test widget Flutter: formulaire reset password
- [ ] Test integration: flow complet email -> reset

## Dev Notes

### Architecture Reference
- Utiliser Laravel Password Reset natif
- Tokens stockes dans table `password_reset_tokens`
- Mailpit pour tests email en developpement (port 48025)

### API Contract
```json
POST /api/auth/forgot-password
Request:
{
  "email": "string"
}

Response 200:
{
  "message": "Si cet email existe, vous recevrez un lien de reinitialisation"
}

POST /api/auth/reset-password
Request:
{
  "token": "string",
  "email": "string",
  "password": "string",
  "password_confirmation": "string"
}

Response 200:
{
  "message": "Mot de passe reinitialise avec succes"
}

Response 422:
{
  "message": "Lien expire ou invalide"
}
```

### References
- [Source: epics.md#Story 1.3]
- [Source: CLAUDE.md#Ports Sail - Mailpit Dashboard 48025]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
