# Story 1.5: Invitation d'utilisateurs avec role

Status: ready-for-dev

## Story

As a proprietaire (owner),
I want inviter des utilisateurs avec un role (guest-read, guest-extended),
so that je peux collaborer avec des partenaires tout en controlant leur acces.

## Acceptance Criteria

**Given** un utilisateur owner sur l'ecran Invitations
**When** il invite un email avec le role `guest-read` ou `guest-extended`
**Then** un email d'invitation est envoye avec un lien unique
**And** l'invitation apparait dans la liste des invitations en attente

**Given** un invite qui clique sur le lien d'invitation
**When** il cree un compte (ou se connecte si deja inscrit)
**Then** le compte est lie au owner avec le role assigne
**And** le token Sanctum de l'invite porte les abilities correspondantes

**Given** un utilisateur owner
**When** il consulte la liste des invitations
**Then** il voit les invitations en attente et acceptees
**And** il peut revoquer une invitation ou un acces existant

## Tasks / Subtasks

### Backend (Laravel)
- [ ] Creer table `invitations` (id, owner_id, email, role, token, status, expires_at)
- [ ] Creer `POST /api/invitations` endpoint (owner cree invitation)
- [ ] Generer token unique pour lien invitation
- [ ] Envoyer email invitation avec lien
- [ ] Creer `GET /api/invitations` endpoint (liste invitations owner)
- [ ] Creer `DELETE /api/invitations/{id}` endpoint (revoquer)
- [ ] Creer `POST /api/invitations/accept` endpoint (invite accepte)
- [ ] Lier invite au owner avec role dans table pivot
- [ ] Generer token Sanctum avec abilities selon role

### Mobile (Flutter)
- [ ] Creer `InvitationsPage` dans `lib/features/invitations/presentation/pages/`
- [ ] Implementer `InvitationsCubit`
- [ ] Formulaire creation invitation (email + role select)
- [ ] Liste invitations avec statut (pending, accepted, revoked)
- [ ] Action revoquer avec confirmation
- [ ] Creer `AcceptInvitationPage` (deep link depuis email)
- [ ] Flow: si connecte -> accepter, si non -> register puis accepter

### Email Template
- [ ] Template email invitation
- [ ] Inclure nom owner, role propose, lien acceptation
- [ ] Design coherent MDB Copilot

### Tests
- [ ] Test unitaire backend: creation invitation
- [ ] Test unitaire backend: acceptation invitation (new user)
- [ ] Test unitaire backend: acceptation invitation (existing user)
- [ ] Test unitaire backend: revocation invitation
- [ ] Test unitaire backend: token abilities selon role
- [ ] Test widget Flutter: liste invitations
- [ ] Test widget Flutter: formulaire invitation

## Dev Notes

### Architecture Reference
- Roles Sanctum: owner, guest-read, guest-extended
- Table pivot `user_accesses` pour lier invite -> owner avec role
- Abilities token definissent les permissions API

### Database Schema
```sql
invitations:
  id: uuid (PK)
  owner_id: uuid (FK users)
  email: string
  role: enum('guest-read', 'guest-extended')
  token: string (unique)
  status: enum('pending', 'accepted', 'revoked')
  expires_at: timestamp
  created_at: timestamp
  updated_at: timestamp

user_accesses:
  id: uuid (PK)
  owner_id: uuid (FK users)
  guest_id: uuid (FK users)
  role: enum('guest-read', 'guest-extended')
  created_at: timestamp
```

### API Contract
```json
POST /api/invitations
Headers: Authorization: Bearer {token} (owner ability required)
Request:
{
  "email": "string",
  "role": "guest-read" | "guest-extended"
}

Response 201:
{
  "id": "uuid",
  "email": "string",
  "role": "string",
  "status": "pending",
  "expires_at": "datetime"
}

GET /api/invitations
Headers: Authorization: Bearer {token}

Response 200:
{
  "data": [
    {
      "id": "uuid",
      "email": "string",
      "role": "string",
      "status": "pending|accepted|revoked",
      "created_at": "datetime"
    }
  ]
}

DELETE /api/invitations/{id}
Headers: Authorization: Bearer {token}

Response 200:
{
  "message": "Invitation revoquee"
}

POST /api/invitations/accept
Request:
{
  "token": "string"
}

Response 200:
{
  "message": "Invitation acceptee",
  "user": { ... },
  "token": "string" (with role abilities)
}
```

### References
- [Source: epics.md#Story 1.5]
- [Source: architecture.md#Sanctum RBAC]
- [Source: prd.md#FR5, FR6]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
