# Story 7.2: Tour guide des fonctionnalites

Status: ready-for-dev

## Story

As a nouvel utilisateur,
I want suivre un tour guide des fonctionnalites principales,
so that je comprends rapidement comment utiliser l'app.

## Acceptance Criteria

**Given** l'utilisateur qui choisit "Explorer l'app"
**When** le tour guide demarre
**Then** un overlay presente 5 ecrans successifs :
  1. Pipeline Kanban ("Suivez vos opportunites")
  2. Fiche annonce ("Centralisez les infos")
  3. Guide de visite ("Ne ratez rien sur le terrain")
  4. Fiches memo ("Apprenez en pratiquant")
  5. Score d'opportunite ("Decidez en confiance")

**Given** le tour guide en cours
**When** l'utilisateur navigue
**Then** des boutons Precedent/Suivant permettent de naviguer
**And** un indicateur de progression (dots) montre l'etape actuelle
**And** un bouton "Passer" permet de quitter a tout moment

**Given** la fin du tour guide
**When** l'utilisateur termine ou passe
**Then** il est redirige vers l'ecran d'accueil avec les options de creation
**And** un flag "onboarding_completed" est enregistre

**Given** un utilisateur ayant complete l'onboarding
**When** il revient dans l'app
**Then** l'ecran d'accueil n'apparait plus automatiquement
**And** le tour guide reste accessible depuis les parametres

## Tasks / Subtasks

### Backend API
- [ ] Ensure onboarding_completed flag persists on user model
- [ ] Add tour_completed_at timestamp to user
- [ ] Write migration if needed

### Mobile App (React Native)
- [ ] Create OnboardingTourScreen with swipeable slides
- [ ] Create TourSlide component for each feature highlight
- [ ] Create TourProgressDots component
- [ ] Create TourNavigationButtons (Previous/Next/Skip)
- [ ] Implement swipe gestures between slides
- [ ] Create tour content configuration (5 screens)
- [ ] Add illustrations/animations for each slide
- [ ] Implement tour completion handler
- [ ] Add tour access from Settings screen
- [ ] Write unit tests for tour navigation
- [ ] Write integration tests for tour flow

### Web App (React)
- [ ] Create OnboardingTourPage with carousel
- [ ] Create TourSlide component
- [ ] Create TourProgressDots component
- [ ] Create TourNavigationButtons
- [ ] Implement keyboard navigation (left/right arrows)
- [ ] Create tour content configuration
- [ ] Add illustrations for each slide
- [ ] Implement tour completion handler
- [ ] Add tour access from Settings
- [ ] Write tests for tour components

### Shared Package
- [ ] Add TourSlide type
- [ ] Add TourConfig type
- [ ] Add tour content constants

## Dev Notes

### Architecture Reference
- Follow AR51: OnboardingTour (tour guide 5 ecrans)
- Swipeable on mobile, carousel with arrows on web
- Skip button always visible

### Tour Slides Configuration
```typescript
interface TourSlide {
  id: string;
  title: string;
  description: string;
  illustration: string; // Asset path or component
  highlightFeature: string;
}

const TOUR_SLIDES: TourSlide[] = [
  {
    id: 'pipeline',
    title: 'Suivez vos opportunites',
    description: 'Visualisez tous vos projets dans un pipeline Kanban intuitif. Deplacez vos fiches au fil de votre avancement.',
    illustration: 'tour_pipeline',
    highlightFeature: 'pipeline'
  },
  {
    id: 'property',
    title: 'Centralisez les infos',
    description: 'Creez des fiches annonces en un clic. Importez depuis LeBonCoin ou saisissez manuellement.',
    illustration: 'tour_property',
    highlightFeature: 'properties'
  },
  {
    id: 'visit_guide',
    title: 'Ne ratez rien sur le terrain',
    description: 'Utilisez le guide de visite interactif pour inspecter methodiquement chaque bien, meme sans connexion.',
    illustration: 'tour_visit',
    highlightFeature: 'visit_guide'
  },
  {
    id: 'memos',
    title: 'Apprenez en pratiquant',
    description: 'Consultez les fiches memo MDB pour maitriser la fiscalite, le juridique et les bonnes pratiques.',
    illustration: 'tour_memos',
    highlightFeature: 'memos'
  },
  {
    id: 'score',
    title: 'Decidez en confiance',
    description: 'Le score d\'opportunite vous aide a prioriser les meilleures affaires grace aux donnees DVF.',
    illustration: 'tour_score',
    highlightFeature: 'score'
  }
];
```

### Tour Navigation State
```typescript
interface TourState {
  currentSlide: number;
  totalSlides: number;
  isComplete: boolean;
}

const useTourNavigation = () => {
  const [state, setState] = useState<TourState>({
    currentSlide: 0,
    totalSlides: TOUR_SLIDES.length,
    isComplete: false
  });

  const next = () => {
    if (state.currentSlide < state.totalSlides - 1) {
      setState(s => ({ ...s, currentSlide: s.currentSlide + 1 }));
    } else {
      complete();
    }
  };

  const previous = () => {
    if (state.currentSlide > 0) {
      setState(s => ({ ...s, currentSlide: s.currentSlide - 1 }));
    }
  };

  const skip = () => complete();

  const complete = async () => {
    await markOnboardingComplete();
    setState(s => ({ ...s, isComplete: true }));
  };

  return { ...state, next, previous, skip };
};
```

### Slide Layout
```
+----------------------------------+
|                                  |
|         [Skip button]            |
|                                  |
|    +------------------------+    |
|    |                        |    |
|    |    [Illustration]      |    |
|    |                        |    |
|    +------------------------+    |
|                                  |
|         {Title}                  |
|                                  |
|    {Description text that       |
|     explains the feature}       |
|                                  |
|         o o * o o               |
|    (progress dots)              |
|                                  |
|  [Previous]          [Next]     |
|                                  |
+----------------------------------+
```

### References
- [Source: epics.md#Story 7.2]
- [Source: prd.md#FR8]
- [Source: architecture.md#AR51]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
