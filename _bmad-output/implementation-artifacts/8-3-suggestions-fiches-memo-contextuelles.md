# Story 8.3: Suggestions de fiches memo contextuelles

Status: ready-for-dev

## Story

As a utilisateur,
I want recevoir des suggestions de fiches memo pertinentes selon mon action,
so that j'apprends au bon moment dans mon workflow.

## Acceptance Criteria

**Given** l'utilisateur sur une fiche annonce avec score d'opportunite calcule
**When** le score est affiche
**Then** un chip "Comprendre le score" propose d'ouvrir la fiche memo correspondante

**Given** une synthese post-visite avec des alertes red flags
**When** la synthese est affichee
**Then** des chips contextuels apparaissent pour chaque type d'alerte (ex: "En savoir plus sur les fissures")

**Given** l'utilisateur sur le simulateur TVA
**When** le simulateur s'affiche
**Then** un lien vers la fiche "TVA sur marge vs TVA sur total" est propose

**Given** un chip de suggestion memo
**When** l'utilisateur le tape
**Then** la fiche memo s'ouvre en bottom sheet
**And** l'utilisateur peut la fermer pour revenir a son contexte

## Tasks / Subtasks

### Backend API
- [ ] Create memo_suggestions configuration (context -> memo mappings)
- [ ] Add suggestion rules to visit alert configuration
- [ ] No new endpoints needed (suggestions computed client-side)

### Mobile App (React Native)
- [ ] Create MemoSuggestionChip component
- [ ] Create MemoBottomSheet component for inline memo display
- [ ] Create useMemoSuggestions hook (context-aware)
- [ ] Add suggestions to PropertyDetailScreen (score context)
- [ ] Add suggestions to PostVisitSummaryScreen (alert context)
- [ ] Add suggestions to TaxSimulatorScreen (TVA context)
- [ ] Implement bottom sheet memo rendering with Markdown
- [ ] Write unit tests for MemoSuggestionChip
- [ ] Write integration tests for suggestion display

### Web App (React)
- [ ] Create MemoSuggestionChip component
- [ ] Create MemoSideSheet component (slides from right)
- [ ] Create useMemoSuggestions hook
- [ ] Add suggestions to PropertyDetailPage
- [ ] Add suggestions to PostVisitSummaryPage
- [ ] Add suggestions to TaxSimulatorPage
- [ ] Implement side sheet memo rendering
- [ ] Write tests for suggestion components

### Shared Package
- [ ] Add MemoSuggestion type
- [ ] Add MemoContext enum (score, alert, tva_simulator, etc.)
- [ ] Add getMemoSuggestionsForContext utility
- [ ] Add CONTEXT_MEMO_MAPPINGS configuration

## Dev Notes

### Architecture Reference
- Follow AR53: MemoSuggestionChip (chip contextuel fiche memo)
- Bottom sheet (mobile) / side sheet (web) for inline memo display
- Suggestions computed client-side based on context

### Suggestion Mappings
```typescript
interface MemoSuggestion {
  context: MemoContext;
  memoSlug: string;
  label: string;
  priority: number; // For ordering multiple suggestions
}

type MemoContext =
  | 'score_display'
  | 'alert_structural'
  | 'alert_electrical'
  | 'alert_plumbing'
  | 'alert_roof'
  | 'tva_simulator'
  | 'margin_estimate'
  | 'pipeline_rdv'
  | 'pipeline_offre';

const CONTEXT_MEMO_MAPPINGS: MemoSuggestion[] = [
  // Score context
  {
    context: 'score_display',
    memoSlug: 'comprendre-score-opportunite',
    label: 'Comprendre le score',
    priority: 1
  },

  // Alert contexts
  {
    context: 'alert_structural',
    memoSlug: 'fissures-structurelles',
    label: 'En savoir plus sur les fissures',
    priority: 1
  },
  {
    context: 'alert_electrical',
    memoSlug: 'renovation-electrique',
    label: 'Guide renovation electrique',
    priority: 1
  },

  // TVA context
  {
    context: 'tva_simulator',
    memoSlug: 'tva-sur-marge',
    label: 'TVA sur marge vs TVA sur total',
    priority: 1
  },

  // Pipeline contexts
  {
    context: 'pipeline_rdv',
    memoSlug: 'reussir-visite',
    label: 'Preparer sa visite',
    priority: 1
  },
  {
    context: 'pipeline_offre',
    memoSlug: 'negociation-prix',
    label: 'Techniques de negociation',
    priority: 1
  }
];
```

### Suggestion Hook
```typescript
const useMemoSuggestions = (context: MemoContext, extraContext?: any) => {
  const suggestions = useMemo(() => {
    // Get base suggestions for context
    let results = CONTEXT_MEMO_MAPPINGS
      .filter(m => m.context === context)
      .sort((a, b) => a.priority - b.priority);

    // Add alert-specific suggestions if extraContext has alerts
    if (extraContext?.alerts) {
      extraContext.alerts.forEach((alert: Alert) => {
        if (alert.memoSlug) {
          results.push({
            context: `alert_${alert.category}` as MemoContext,
            memoSlug: alert.memoSlug,
            label: `En savoir plus: ${alert.title}`,
            priority: 2
          });
        }
      });
    }

    return uniqueBy(results, 'memoSlug');
  }, [context, extraContext]);

  return suggestions;
};
```

### Chip Component
```typescript
interface MemoSuggestionChipProps {
  suggestion: MemoSuggestion;
  onPress: () => void;
}

// Styling: pill shape, accent color, small icon
// On press: open memo in bottom sheet / side sheet
```

### Bottom Sheet Memo Display
```typescript
// Mobile: @gorhom/bottom-sheet or similar
// Web: MUI Drawer with anchor="right"

const MemoBottomSheet = ({ memoSlug, onClose }) => {
  const memo = useMemoBySlug(memoSlug);

  return (
    <BottomSheet onClose={onClose}>
      <BottomSheet.Header>
        <Text>{memo.title}</Text>
        <CloseButton onPress={onClose} />
      </BottomSheet.Header>
      <BottomSheet.Content>
        <MarkdownRenderer content={memo.contentMd} />
      </BottomSheet.Content>
    </BottomSheet>
  );
};
```

### References
- [Source: epics.md#Story 8.3]
- [Source: prd.md#FR43]
- [Source: architecture.md#AR53]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
