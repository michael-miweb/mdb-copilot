# Story 2.2: Creation fiche annonce - Saisie manuelle avec agent

Status: ready-for-dev

## Story

As a utilisateur,
I want creer une fiche annonce par saisie manuelle avec possibilite d'associer un agent,
so that je centralise les informations d'une opportunite immobiliere.

## Acceptance Criteria

**Given** un utilisateur connecte
**When** il remplit le formulaire de creation (adresse, surface, prix, type de bien)
**Then** une fiche annonce est creee avec un UUID v4
**And** la fiche est sauvegardee (DB locale + sync serveur)
**And** la fiche apparait dans la liste des fiches

**Given** le formulaire de creation, section agent
**When** l'utilisateur ouvre le selecteur d'agent
**Then** une liste affiche uniquement les contacts de type "agent immobilier" du carnet
**And** un bouton "Creer un nouveau contact" permet d'ajouter un agent inline
**And** le champ agent est optionnel

**Given** le formulaire de fiche
**When** l'utilisateur selectionne un agent existant
**Then** la fiche est liee au contact via `contact_id`
**And** les informations de l'agent (nom, entreprise, telephone) s'affichent sous le selecteur

**Given** le formulaire de fiche
**When** l'utilisateur cree un agent inline
**Then** le nouveau contact est cree avec type "agent immobilier" (reutilise la logique de Story 2.1)
**And** il est automatiquement selectionne pour la fiche

**Given** le formulaire de creation
**When** l'utilisateur selectionne un niveau d'urgence de vente (faible, moyen, eleve)
**Then** l'urgence est enregistree dans la fiche
**And** le champ urgence est optionnel avec valeur par defaut "non renseigne"

**Given** le formulaire de creation
**When** l'utilisateur ajoute des notes libres
**Then** les notes sont enregistrees en texte libre dans la fiche

## Tasks / Subtasks

### Backend (Laravel)
- [ ] Creer migration table `properties` (id uuid, user_id, address, surface_m2, price_cents, property_type, contact_id nullable, urgency_level, notes, pipeline_status, source_url nullable)
- [ ] Creer model `Property` avec relation belongsTo Contact
- [ ] Creer `PropertyController` avec endpoints CRUD
- [ ] POST /api/properties (create)
- [ ] Validation: adresse obligatoire, prix en centimes (int)
- [ ] Statut pipeline par defaut: "prospection"

### Mobile (Flutter)
- [ ] Creer `CreatePropertyPage` dans `lib/features/properties/presentation/pages/`
- [ ] Implementer `PropertyFormCubit` avec etats: initial, loading, success, error
- [ ] Formulaire avec champs: adresse, surface, prix, type de bien
- [ ] Widget `AgentSelectorWidget`:
  - Dropdown avec contacts type=agent_immobilier
  - Bouton "Creer un nouveau"
  - Affichage infos agent selectionne
- [ ] Dropdown urgence: faible, moyen, eleve, non renseigne
- [ ] Champ notes textarea
- [ ] Creer `PropertyRepository` (interface local/remote)
- [ ] Implementer Drift schema pour table properties locale

### UX
- [ ] Conversion prix saisie (euros) -> stockage (centimes)
- [ ] Validation surface numerique positive
- [ ] Feedback sauvegarde success

### Tests
- [ ] Test unitaire backend: creation property
- [ ] Test unitaire backend: liaison contact_id
- [ ] Test unitaire backend: prix en centimes
- [ ] Test widget Flutter: formulaire property
- [ ] Test widget Flutter: agent selector
- [ ] Test cubit: flow creation property

## Dev Notes

### Architecture Reference
- Montants en centimes (int) pour tous les prix
- UUID v4 pour IDs
- contact_id nullable (agent optionnel)
- Statut pipeline default "prospection"

### Database Schema
```sql
properties:
  id: uuid (PK)
  user_id: uuid (FK users)
  address: string (required)
  surface_m2: decimal(10,2) (nullable)
  price_cents: bigint (nullable) -- prix en centimes
  property_type: enum('appartement', 'maison', 'immeuble', 'terrain', 'local_commercial', 'autre')
  contact_id: uuid (FK contacts, nullable) -- agent immobilier
  urgency_level: enum('low', 'medium', 'high', 'unknown') default 'unknown'
  notes: text (nullable)
  pipeline_status: enum('prospection', 'rdv', 'visite', 'analyse', 'offre', 'achete', 'travaux', 'vente', 'vendu', 'no_go') default 'prospection'
  source_url: string (nullable) -- lien annonce original
  created_at: timestamp
  updated_at: timestamp
  deleted_at: timestamp (nullable)
```

### API Contract
```json
POST /api/properties
Headers: Authorization: Bearer {token}
Request:
{
  "address": "string",
  "surface_m2": 75.5,
  "price_cents": 25000000, // 250,000 EUR
  "property_type": "appartement",
  "contact_id": "uuid|null",
  "urgency_level": "medium",
  "notes": "string"
}

Response 201:
{
  "id": "uuid",
  "address": "string",
  "surface_m2": 75.5,
  "price_cents": 25000000,
  "property_type": "appartement",
  "contact": {
    "id": "uuid",
    "first_name": "...",
    "last_name": "...",
    "company": "...",
    "phone": "..."
  },
  "urgency_level": "medium",
  "notes": "string",
  "pipeline_status": "prospection",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### References
- [Source: epics.md#Story 2.2]
- [Source: prd.md#FR12, FR16, FR17, FR18]
- [Source: CLAUDE.md#Montants en centimes]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
