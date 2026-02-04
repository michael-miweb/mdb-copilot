# Story 6.2: Alertes sur les points critiques (red flags)

Status: ready-for-dev

## Story

As a utilisateur,
I want voir les alertes sur les points critiques detectes,
so that j'identifie immediatement les risques majeurs.

## Acceptance Criteria

**Given** une synthese post-visite generee
**When** l'utilisateur consulte la synthese
**Then** les alertes rouges sont affichees en priorite (problemes structurels, amiante probable, electricite vetuste, etc.)
**And** chaque alerte est categorisee par severite (critique, attention, info)
**And** le nombre d'alertes par severite est resume en haut de la synthese

**Given** une alerte critique
**When** l'utilisateur la consulte
**Then** la question source et la reponse sont affichees
**And** un lien vers la fiche memo pertinente est propose (liaison Epic 8)

## Tasks / Subtasks

### Backend API
- [ ] Add alert rules configuration file (config/visit-alerts.php)
- [ ] Create AlertService for centralized alert logic
- [ ] Add alert_rules to sync payload for offline availability
- [ ] Write tests for alert detection rules

### Mobile App (React Native)
- [ ] Create AlertSummaryBanner component (critical/warning/info counts)
- [ ] Create AlertCard component with severity styling
- [ ] Create AlertDetailSheet bottom sheet component
- [ ] Create MemoLinkChip component for contextual memo suggestions
- [ ] Implement alert sorting (critical first, then warning, then info)
- [ ] Add navigation from alert to source question
- [ ] Add navigation from alert to memo (bottom sheet)
- [ ] Write unit tests for AlertCard
- [ ] Write integration tests for alert display

### Web App (React)
- [ ] Create AlertSummaryBanner component
- [ ] Create AlertCard component with severity badges
- [ ] Create AlertDetailModal component
- [ ] Create MemoLinkChip component
- [ ] Implement alert sorting
- [ ] Add click handler to navigate to source question
- [ ] Add memo link in modal
- [ ] Write tests for alert components

### Shared Package
- [ ] Add Alert type with full structure
- [ ] Add AlertSeverity enum (critical, warning, info)
- [ ] Add AlertRule type
- [ ] Create detectAlerts utility function
- [ ] Create sortAlertsBySeverity utility
- [ ] Add alert-to-memo mapping

## Dev Notes

### Architecture Reference
- Follow AR46: PostVisitSummary with alerts display
- Follow AR53: MemoSuggestionChip for contextual memo links
- Severity color coding: critical (red), warning (orange), info (blue)

### Alert Structure
```typescript
interface Alert {
  id: string;
  severity: 'critical' | 'warning' | 'info';
  category: string;
  questionKey: string;
  title: string;
  description: string;
  sourceAnswer: string;
  memoSlug?: string; // Link to relevant memo
}

interface AlertSummary {
  critical: number;
  warning: number;
  info: number;
  total: number;
}
```

### Alert Rules Configuration
```typescript
const ALERT_RULES: AlertRule[] = [
  {
    id: 'structural_cracks',
    category: 'structure_gros_oeuvre',
    questionKey: 'fissures_structurelles',
    condition: (answer) => answer === 'oui',
    severity: 'critical',
    title: 'Fissures structurelles detectees',
    description: 'Des fissures importantes peuvent indiquer des problemes de fondation.',
    memoSlug: 'fissures-structurelles'
  },
  {
    id: 'electrical_obsolete',
    category: 'electricite',
    questionKey: 'installation_vetuste',
    condition: (answer) => answer === 'oui',
    severity: 'warning',
    title: 'Installation electrique vetuste',
    description: 'Une mise aux normes sera necessaire.',
    memoSlug: 'renovation-electrique'
  }
];
```

### Severity Styling
```typescript
const SEVERITY_COLORS = {
  critical: { bg: '#FEE2E2', border: '#EF4444', text: '#991B1B' },
  warning: { bg: '#FEF3C7', border: '#F59E0B', text: '#92400E' },
  info: { bg: '#DBEAFE', border: '#3B82F6', text: '#1E40AF' }
};
```

### References
- [Source: epics.md#Story 6.2]
- [Source: prd.md#FR36]
- [Source: architecture.md#AR46, AR53]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
