# Story 10.4: Alertes delais de revente fiscaux

Status: ready-for-dev

## Story

As a utilisateur,
I want etre alerte sur les delais de revente fiscaux,
so that je ne manque pas une echeance importante.

## Acceptance Criteria

**Given** une fiche annonce avec une date d'achat renseignee
**When** le systeme verifie les delais de revente
**Then** une alerte est affichee si un delai fiscal approche (ex: delai 2 ans regime MDB)
**And** l'alerte precise le delai restant et les consequences fiscales

**Given** une alerte de delai fiscal
**When** l'utilisateur la consulte
**Then** un lien vers la fiche memo correspondante est propose
**And** les options (revente avant/apres delai) sont expliquees

## Tasks / Subtasks

### Backend Tasks
- [ ] Add `purchase_date` field to properties table (if not exists)
- [ ] Create `FiscalAlertService` in `backend-api/app/Services/`
  - [ ] Calculate days remaining for fiscal deadlines
  - [ ] Determine applicable deadlines based on operation type
  - [ ] Generate alert objects with severity levels
- [ ] Add fiscal alerts to property resource response
- [ ] Create scheduled job to check deadlines and send notifications
- [ ] Add notification preferences for fiscal alerts
- [ ] Write unit tests for deadline calculations
- [ ] Write feature tests for alert endpoints

### Frontend Tasks (Mobile - React Native)
- [ ] Create `FiscalAlertBanner` component
  - [ ] Display alert with remaining days
  - [ ] Color-coded severity (warning < 30 days, critical < 7 days)
  - [ ] Expandable for details
- [ ] Create `FiscalAlertDetailModal` component
  - [ ] Full explanation of deadline
  - [ ] Consequences of missing deadline
  - [ ] Link to relevant memo guide
- [ ] Integrate alerts into property detail screen
- [ ] Add alerts section to dashboard/home
- [ ] Implement push notification handling for alerts
- [ ] Write component tests

### Frontend Tasks (Web - React)
- [ ] Create `FiscalAlertBanner` MUI component
- [ ] Create `FiscalAlertDetailDialog` MUI component
- [ ] Add alerts to property detail page
- [ ] Add alerts summary to dashboard
- [ ] Write component tests

### Shared Package Tasks
- [ ] Add types: `FiscalAlert`, `AlertSeverity`, `FiscalDeadline`
- [ ] Add fiscal deadline constants
- [ ] Add date calculation utilities for deadlines

## Dev Notes

### Architecture Reference
- Alerts calculated server-side for consistency
- Push notifications for critical deadlines
- MemoSuggestionChip (AR53) links to relevant guides
- Alerts stored with property for offline access

### Fiscal Deadlines (MDB France)
```typescript
const FISCAL_DEADLINES = {
  mdbRegime: {
    name: 'Delai regime MDB',
    duration: 2 * 365, // 2 years in days
    description: 'Revente dans les 2 ans pour beneficier du regime MDB',
    consequences: 'Perte avantage fiscal si depassement',
  },
  plusValueExemption: {
    name: 'Exoneration plus-value',
    duration: 5 * 365, // 5 years
    description: 'Detention minimum pour certaines exonerations',
    consequences: 'Imposition pleine de la plus-value',
  },
};
```

### Alert Severity Levels
```typescript
const getAlertSeverity = (daysRemaining: number): AlertSeverity => {
  if (daysRemaining <= 7) return 'critical';
  if (daysRemaining <= 30) return 'warning';
  if (daysRemaining <= 90) return 'info';
  return 'none';
};
```

### Alert Display
- Critical (< 7 days): Red banner, push notification
- Warning (< 30 days): Orange banner, in-app notification
- Info (< 90 days): Yellow indicator on property card
- Normal: Hidden or subtle indicator

### Notification Schedule
- 90 days before: First reminder
- 30 days before: Warning reminder
- 7 days before: Critical reminder
- Day of: Final reminder

### References
- [Source: epics.md#Story 10.4]
- [Source: prd.md#FR63 - Alertes delais de revente fiscaux]
- [Source: architecture.md#AR53 - MemoSuggestionChip]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
