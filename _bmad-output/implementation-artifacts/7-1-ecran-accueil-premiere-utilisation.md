# Story 7.1: Ecran d'accueil premiere utilisation

Status: ready-for-dev

## Story

As a nouvel utilisateur,
I want voir un ecran d'accueil avec des options de demarrage,
so that je sais par ou commencer.

## Acceptance Criteria

**Given** un utilisateur qui ouvre l'app pour la premiere fois apres inscription
**When** l'ecran d'accueil s'affiche
**Then** un message personnalise "Bienvenue [Prenom] !" apparait
**And** trois options de demarrage sont presentees clairement :
  - "Coller un lien d'annonce" (action rapide)
  - "Saisir une annonce manuellement"
  - "Explorer l'app d'abord"

**Given** l'ecran d'accueil
**When** l'utilisateur choisit "Coller un lien"
**Then** il est redirige vers le formulaire de creation avec le champ lien focus

**Given** l'ecran d'accueil
**When** l'utilisateur choisit "Saisir manuellement"
**Then** il est redirige vers le formulaire de creation manuelle

## Tasks / Subtasks

### Backend API
- [ ] Add onboarding_completed flag to users table migration
- [ ] Add endpoint GET /api/user/onboarding-status
- [ ] Add endpoint PATCH /api/user/onboarding-status
- [ ] Write tests for onboarding status endpoints

### Mobile App (React Native)
- [ ] Create OnboardingWelcomeScreen with personalized greeting
- [ ] Create StartOptionCard component for each option
- [ ] Create useOnboardingStatus hook checking first-time user
- [ ] Implement navigation to create property with link field focused
- [ ] Implement navigation to create property manual form
- [ ] Implement navigation to guided tour (Story 7.2)
- [ ] Store onboarding status in local storage + sync
- [ ] Add WatermelonDB field for onboarding state
- [ ] Write unit tests for OnboardingWelcomeScreen
- [ ] Write navigation tests

### Web App (React)
- [ ] Create OnboardingWelcomePage with personalized greeting
- [ ] Create StartOptionCard component
- [ ] Create useOnboardingStatus hook
- [ ] Implement navigation to create property routes
- [ ] Implement navigation to guided tour
- [ ] Store onboarding status in Dexie.js + sync
- [ ] Add route /welcome
- [ ] Write tests for OnboardingWelcomePage

### Shared Package
- [ ] Add OnboardingStatus type
- [ ] Add StartOption type

## Dev Notes

### Architecture Reference
- Follow AR52: OnboardingWelcome (ecran accueil premiere utilisation)
- First-time detection: check onboarding_completed flag on user

### Welcome Screen Layout
```
+----------------------------------+
|                                  |
|    [App Logo]                    |
|                                  |
|    Bienvenue, {firstName}!       |
|    Pret a trouver votre          |
|    prochaine opportunite MDB?    |
|                                  |
| +------------------------------+ |
| |  [Link Icon]                 | |
| |  Coller un lien d'annonce    | |
| |  Import rapide depuis        | |
| |  LeBonCoin, SeLoger...       | |
| +------------------------------+ |
|                                  |
| +------------------------------+ |
| |  [Edit Icon]                 | |
| |  Saisir manuellement         | |
| |  Creer une fiche complete    | |
| +------------------------------+ |
|                                  |
| +------------------------------+ |
| |  [Explore Icon]              | |
| |  Explorer l'app              | |
| |  Decouvrir les fonctions     | |
| +------------------------------+ |
|                                  |
+----------------------------------+
```

### Start Options Configuration
```typescript
interface StartOption {
  id: 'paste_link' | 'manual_entry' | 'explore';
  title: string;
  description: string;
  icon: string;
  navigateTo: string;
  params?: Record<string, any>;
}

const START_OPTIONS: StartOption[] = [
  {
    id: 'paste_link',
    title: 'Coller un lien d\'annonce',
    description: 'Import rapide depuis LeBonCoin, SeLoger...',
    icon: 'link',
    navigateTo: '/properties/create',
    params: { focusLinkField: true }
  },
  {
    id: 'manual_entry',
    title: 'Saisir manuellement',
    description: 'Creer une fiche complete',
    icon: 'edit',
    navigateTo: '/properties/create',
    params: { mode: 'manual' }
  },
  {
    id: 'explore',
    title: 'Explorer l\'app',
    description: 'Decouvrir les fonctions',
    icon: 'compass',
    navigateTo: '/onboarding/tour'
  }
];
```

### First-Time Detection
```typescript
const useOnboardingStatus = () => {
  const { user } = useAuth();
  const [status, setStatus] = useState<OnboardingStatus | null>(null);

  useEffect(() => {
    // Check local storage first, then sync with server
    const localStatus = localStorage.getItem('onboarding_status');
    if (!localStatus || !JSON.parse(localStatus).completed) {
      // Show welcome screen
      setStatus({ completed: false, step: 'welcome' });
    } else {
      setStatus({ completed: true });
    }
  }, [user]);

  return status;
};
```

### References
- [Source: epics.md#Story 7.1]
- [Source: prd.md#FR7]
- [Source: architecture.md#AR52]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
