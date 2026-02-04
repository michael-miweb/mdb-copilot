# Story 2.1: CRUD Carnet d'adresses

Status: ready-for-dev

## Story

As a utilisateur,
I want gerer un carnet d'adresses de contacts professionnels,
so that je centralise mes interlocuteurs et les reutilise dans mes fiches annonces.

## Acceptance Criteria

**Given** un utilisateur connecte
**When** il accede au Carnet d'adresses
**Then** la liste de tous ses contacts est affichee, triee par nom
**And** un filtre par type de contact est disponible (agent immobilier, artisan, notaire, courtier, autre)

**Given** le Carnet d'adresses
**When** l'utilisateur cree un nouveau contact (prenom, nom, entreprise, telephone, email, type, notes)
**Then** le contact est cree avec un UUID v4
**And** le champ "type de contact" est obligatoire, les autres champs sauf nom sont optionnels
**And** le contact est sauvegarde (DB locale + sync serveur)

**Given** un contact existant
**When** l'utilisateur modifie ses informations
**Then** les modifications sont enregistrees
**And** le champ `updated_at` est mis a jour

**Given** un contact existant
**When** l'utilisateur choisit de le supprimer
**Then** une confirmation est demandee
**And** si le contact est associe a des fiches annonces, un avertissement le signale
**And** si confirme, le contact est soft-deleted

## Tasks / Subtasks

### Backend (Laravel)
- [ ] Creer migration table `contacts` (id uuid, user_id, first_name, last_name, company, phone, email, type enum, notes, deleted_at)
- [ ] Creer model `Contact` avec soft deletes
- [ ] Creer `ContactController` avec CRUD endpoints
- [ ] GET /api/contacts (list avec filtre type)
- [ ] POST /api/contacts (create)
- [ ] PUT /api/contacts/{id} (update)
- [ ] DELETE /api/contacts/{id} (soft delete)
- [ ] Validation: type obligatoire, last_name obligatoire
- [ ] Scope par user_id (owner_id pour invites)

### Mobile (Flutter)
- [ ] Creer `ContactsListPage` dans `lib/features/contacts/presentation/pages/`
- [ ] Creer `ContactDetailPage` pour affichage/edition
- [ ] Implementer `ContactsCubit` avec etats: loading, loaded, creating, updating, error
- [ ] Creer `ContactRepository` (interface local/remote)
- [ ] Implementer Drift schema pour table contacts locale
- [ ] Liste triee par nom avec filtre type (chips)
- [ ] Formulaire creation/edition contact
- [ ] Dialog confirmation suppression avec warning si associe

### Sync
- [ ] Implementer sync delta pour contacts
- [ ] Marquage syncStatus sur entite locale

### Tests
- [ ] Test unitaire backend: CRUD contacts
- [ ] Test unitaire backend: filtre par type
- [ ] Test unitaire backend: soft delete
- [ ] Test widget Flutter: liste contacts
- [ ] Test widget Flutter: formulaire contact
- [ ] Test cubit: flow CRUD contacts
- [ ] Test repository: sync local/remote

## Dev Notes

### Architecture Reference
- UUID v4 pour tous les IDs
- Soft delete pour suppression (deleted_at)
- Repository pattern pour abstraction local (Drift) / remote (API)
- Sync engine delta incremental via updated_at

### Database Schema
```sql
contacts:
  id: uuid (PK)
  user_id: uuid (FK users) -- owner of the contact
  first_name: string (nullable)
  last_name: string (required)
  company: string (nullable)
  phone: string (nullable)
  email: string (nullable)
  type: enum('agent_immobilier', 'artisan', 'notaire', 'courtier', 'autre')
  notes: text (nullable)
  created_at: timestamp
  updated_at: timestamp
  deleted_at: timestamp (nullable)
```

### API Contract
```json
GET /api/contacts?type=agent_immobilier
Headers: Authorization: Bearer {token}

Response 200:
{
  "data": [
    {
      "id": "uuid",
      "first_name": "string",
      "last_name": "string",
      "company": "string",
      "phone": "string",
      "email": "string",
      "type": "agent_immobilier",
      "notes": "string",
      "created_at": "datetime",
      "updated_at": "datetime"
    }
  ]
}

POST /api/contacts
Request:
{
  "first_name": "string",
  "last_name": "string",
  "company": "string",
  "phone": "string",
  "email": "string",
  "type": "agent_immobilier",
  "notes": "string"
}

Response 201:
{
  "id": "uuid",
  ...
}

PUT /api/contacts/{id}
Request: { same as POST }

Response 200:
{ updated contact }

DELETE /api/contacts/{id}

Response 200:
{
  "message": "Contact supprime"
}
```

### References
- [Source: epics.md#Story 2.1]
- [Source: prd.md#FR9, FR10, FR11]
- [Source: architecture.md#Repository pattern]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
