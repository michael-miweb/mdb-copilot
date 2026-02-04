# Story 10.2: Guide fiscalite MDB - Regles TVA

Status: ready-for-dev

## Story

As a utilisateur debutant MDB,
I want consulter les regles TVA applicables,
so that je comprends quand appliquer la TVA sur marge ou sur total.

## Acceptance Criteria

**Given** l'ecran Guide Fiscalite
**When** l'utilisateur consulte la section TVA
**Then** les regles TVA sur marge et TVA sur total sont expliquees clairement
**And** les conditions d'application de chaque regime sont detaillees
**And** des exemples chiffres illustrent chaque cas

**Given** la section TVA
**When** l'utilisateur consulte un exemple
**Then** un calcul detaille montre le raisonnement etape par etape

## Tasks / Subtasks

### Content Tasks
- [ ] Write comprehensive TVA guide content in French
  - [ ] TVA sur marge: definition, conditions, calculation
  - [ ] TVA sur total: definition, conditions, calculation
  - [ ] When each regime applies
  - [ ] Common pitfalls and mistakes
- [ ] Create 3-4 worked examples with step-by-step calculations
  - [ ] Example 1: Classic MDB operation (TVA sur marge)
  - [ ] Example 2: New construction scenario (TVA sur total)
  - [ ] Example 3: Mixed scenario
- [ ] Review content for accuracy with fiscal regulations
- [ ] Store content as markdown in `packages/shared/src/content/guides/`

### Backend Tasks
- [ ] Create seed data for fiscal guide content
- [ ] Add `GET /api/guides/tva` endpoint for guide content
- [ ] Ensure guide content is cached appropriately

### Frontend Tasks (Mobile - React Native)
- [ ] Create `FiscalGuideScreen` screen
- [ ] Create `TvaGuideSection` component
  - [ ] Collapsible sections for each regime
  - [ ] Formatted text with headings and bullets
  - [ ] Highlight boxes for key points
- [ ] Create `CalculationExample` component
  - [ ] Step-by-step breakdown display
  - [ ] Input values clearly shown
  - [ ] Intermediate calculations visible
  - [ ] Final result highlighted
- [ ] Add navigation from TVA simulator to guide
- [ ] Implement smooth scrolling to sections
- [ ] Write component tests

### Frontend Tasks (Web - React)
- [ ] Create `FiscalGuidePage` page
- [ ] Create `TvaGuideSection` MUI component
- [ ] Create `CalculationExample` MUI component
- [ ] Add table of contents sidebar for desktop
- [ ] Implement anchor links for direct section access
- [ ] Write component tests

### Shared Package Tasks
- [ ] Define guide content types: `GuideSection`, `CalculationExample`
- [ ] Store static guide content as TypeScript constants
- [ ] Add utility for rendering markdown content

## Dev Notes

### Architecture Reference
- Guide content stored statically for offline access
- Content bundled with app, not fetched from API
- Links from TVA simulator to relevant guide sections
- MemoSuggestionChip (AR53) for contextual links

### Content Structure
```typescript
interface TvaGuideContent {
  sections: {
    id: 'tva_marge' | 'tva_total' | 'comparison';
    title: string;
    content: string; // Markdown
    keyPoints: string[];
    examples: CalculationExample[];
  }[];
}

interface CalculationExample {
  title: string;
  scenario: string;
  inputs: { label: string; value: number }[];
  steps: { description: string; calculation: string; result: number }[];
  conclusion: string;
}
```

### Key Content Points
- TVA sur marge: 20% applies only to (resale - purchase)
- TVA sur total: 20% applies to full resale price
- Conditions for TVA sur marge eligibility
- Impact on profitability comparison

### References
- [Source: epics.md#Story 10.2]
- [Source: prd.md#FR60 - Regles TVA marge vs total]
- [Source: architecture.md#AR53 - MemoSuggestionChip]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
