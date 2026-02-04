# Story 12.5: Consultation associe via compte invite

Status: ready-for-dev

## Story

As a associe potentiel,
I want consulter le pipeline et les fiches via un compte invite,
so that j'evalue l'activite MDB avant de m'engager.

## Acceptance Criteria

**Given** un utilisateur invite avec role `guest-extended`
**When** il se connecte a l'application
**Then** il voit le pipeline Kanban avec les projets en cours
**And** il peut consulter les fiches annonces selon ses permissions
**And** il ne voit pas les donnees de negociation sensibles definies par l'owner

**Given** un utilisateur invite avec role `guest-read`
**When** il se connecte
**Then** il a un acces en lecture seule au pipeline et aux fiches
**And** il ne peut modifier aucune donnee
**And** les boutons d'action sont masques

## Tasks / Subtasks

### Backend Tasks
- [ ] Enhance role-based access control for guest users
  - [ ] `guest-read`: read-only access to properties and pipeline
  - [ ] `guest-extended`: read + limited edit capabilities
- [ ] Create `SensitiveFieldsPolicy` for hiding negotiation data
  - [ ] Define which fields are hidden from guests
  - [ ] Apply policy in PropertyResource
- [ ] Update `PropertyPolicy` for guest permissions
- [ ] Update API responses to filter based on role
- [ ] Add `visible_to_guests` flag for properties (optional owner control)
- [ ] Write feature tests for guest access scenarios

### Frontend Tasks (Mobile - React Native)
- [ ] Create `useUserRole` hook
  - [ ] Return current user's role and permissions
- [ ] Create `PermissionGate` component
  - [ ] Conditionally render children based on permissions
- [ ] Update all action buttons with permission checks
  - [ ] Hide create/edit/delete for `guest-read`
  - [ ] Conditionally show for `guest-extended`
- [ ] Update property detail to hide sensitive fields for guests
- [ ] Add visual indicator of guest mode
- [ ] Create `GuestModeBanner` component
- [ ] Write component tests for permission scenarios

### Frontend Tasks (Web - React)
- [ ] Create `useUserRole` hook
- [ ] Create `PermissionGate` MUI component
- [ ] Update all action buttons with permission checks
- [ ] Update property detail for guest view
- [ ] Create `GuestModeBanner` MUI component
- [ ] Write component tests

### Shared Package Tasks
- [ ] Add permission types: `Role`, `Permission`, `PermissionSet`
- [ ] Add permission checking utilities
- [ ] Define sensitive fields list

## Dev Notes

### Architecture Reference
- Sanctum token abilities for role-based access (existing from Epic 1)
- Server-side filtering of sensitive data
- Client-side UI adaptation based on role
- Roles defined: `owner`, `guest-read`, `guest-extended`

### Role Permissions Matrix
```typescript
const ROLE_PERMISSIONS: Record<Role, PermissionSet> = {
  owner: {
    canCreate: true,
    canEdit: true,
    canDelete: true,
    canShare: true,
    canInvite: true,
    canSeeFinancials: true,
    canSeeNegotiationNotes: true,
  },
  'guest-extended': {
    canCreate: false,
    canEdit: true, // Limited fields only
    canDelete: false,
    canShare: false,
    canInvite: false,
    canSeeFinancials: false,
    canSeeNegotiationNotes: false,
  },
  'guest-read': {
    canCreate: false,
    canEdit: false,
    canDelete: false,
    canShare: false,
    canInvite: false,
    canSeeFinancials: false,
    canSeeNegotiationNotes: false,
  },
};
```

### Sensitive Fields (Hidden from Guests)
```typescript
const SENSITIVE_FIELDS = [
  'negotiation_notes',
  'offer_amount',
  'target_margin',
  'agent_commission_notes',
  'financing_details',
  'personal_notes',
];
```

### Permission Gate Component
```typescript
interface PermissionGateProps {
  permission: keyof PermissionSet;
  children: React.ReactNode;
  fallback?: React.ReactNode;
}

const PermissionGate = ({
  permission,
  children,
  fallback = null
}: PermissionGateProps) => {
  const { hasPermission } = useUserRole();

  if (!hasPermission(permission)) {
    return <>{fallback}</>;
  }

  return <>{children}</>;
};

// Usage
<PermissionGate permission="canEdit">
  <IconButton onClick={onEdit}>
    <EditIcon />
  </IconButton>
</PermissionGate>
```

### Guest Mode Banner
```typescript
const GuestModeBanner = () => {
  const { role, ownerName } = useUserRole();

  if (role === 'owner') return null;

  return (
    <Alert severity="info" sx={{ mb: 2 }}>
      Vous consultez les projets de {ownerName} en mode{' '}
      {role === 'guest-read' ? 'lecture seule' : 'invite'}
    </Alert>
  );
};
```

### API Response Filtering (Laravel)
```php
// PropertyResource.php
public function toArray($request): array
{
    $user = $request->user();
    $isGuest = $user->isGuest();

    $data = [
        'id' => $this->id,
        'address' => $this->address,
        'price' => $this->price,
        'surface' => $this->surface,
        'property_type' => $this->property_type,
        // ... basic fields
    ];

    // Add sensitive fields only for owner
    if (!$isGuest) {
        $data['negotiation_notes'] = $this->negotiation_notes;
        $data['offer_amount'] = $this->offer_amount;
        $data['target_margin'] = $this->target_margin;
        // ... other sensitive fields
    }

    return $data;
}
```

### UI Adaptations for Guests
- Hide FAB for creating new properties
- Hide edit/delete buttons on cards
- Show read-only indicators on forms
- Disable drag-and-drop in Kanban for guest-read
- Show subtle "Guest Mode" indicator in header

### useUserRole Hook
```typescript
interface UseUserRoleReturn {
  role: Role;
  ownerName?: string;
  permissions: PermissionSet;
  hasPermission: (permission: keyof PermissionSet) => boolean;
  isGuest: boolean;
}

const useUserRole = (): UseUserRoleReturn => {
  const { user } = useAuth();

  const role = user?.role ?? 'guest-read';
  const permissions = ROLE_PERMISSIONS[role];

  return {
    role,
    ownerName: user?.ownerName,
    permissions,
    hasPermission: (permission) => permissions[permission] ?? false,
    isGuest: role !== 'owner',
  };
};
```

### References
- [Source: epics.md#Story 12.5]
- [Source: prd.md#FR56 - Consultation associe via compte invite]
- [Source: epics.md#Story 1.5 - Invitation with roles]
- [Source: epics.md#Story 1.6 - Role-based access]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
