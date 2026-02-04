# Story 12.4: Notification et consultation des estimations artisan

Status: ready-for-dev

## Story

As a utilisateur owner,
I want etre notifie quand un artisan soumet une estimation,
so that je reagis rapidement aux reponses.

## Acceptance Criteria

**Given** un artisan qui soumet une estimation
**When** l'estimation est enregistree
**Then** le proprietaire recoit une notification (in-app, et email si configure)
**And** la notification indique le nom de la fiche et le montant estime

**Given** des estimations recues
**When** le proprietaire consulte la fiche
**Then** une section "Estimations artisans" liste toutes les soumissions
**And** chaque estimation affiche : fourchette, commentaires, date, statut

## Tasks / Subtasks

### Backend Tasks
- [ ] Create `EstimateNotificationJob` queue job
  - [ ] Send in-app notification
  - [ ] Send email notification if enabled
- [ ] Create `notifications` table migration (if not exists)
  - [ ] Use Laravel's built-in notification system
- [ ] Create `NewEstimateNotification` notification class
- [ ] Add notification preferences to user settings
- [ ] Create `GET /api/properties/{id}/estimates` endpoint for owner
- [ ] Add estimate count to property resource
- [ ] Write feature tests for notification flow

### Frontend Tasks (Mobile - React Native)
- [ ] Set up push notification handling
  - [ ] Expo Notifications or react-native-push-notification
  - [ ] Handle notification tap to navigate to property
- [ ] Create `NotificationBadge` component for nav bar
- [ ] Create `EstimatesSection` component for property detail
  - [ ] List all estimates with key info
  - [ ] Expandable for full details
- [ ] Create `EstimateCard` component
  - [ ] Artisan name
  - [ ] Estimate range with visual bar
  - [ ] Duration
  - [ ] Comments preview
  - [ ] Date submitted
- [ ] Create `NotificationsListScreen`
  - [ ] List of all notifications
  - [ ] Mark as read functionality
- [ ] Update property detail screen with estimates section
- [ ] Write component tests

### Frontend Tasks (Web - React)
- [ ] Create `EstimatesSection` MUI component
- [ ] Create `EstimateCard` MUI component
- [ ] Create `NotificationsDropdown` component for header
- [ ] Create `NotificationsPage` for full list
- [ ] Add notification badge to header
- [ ] Implement browser notifications (optional)
- [ ] Write component tests

### Shared Package Tasks
- [ ] Add types: `Notification`, `EstimateNotification`, `NotificationPreferences`
- [ ] Add notification formatting utilities
- [ ] Add time-ago utilities for notification dates

## Dev Notes

### Architecture Reference
- Laravel Notifications for multi-channel delivery
- Expo Notifications for mobile push (or FCM directly)
- In-app notifications always enabled
- Email notifications opt-in

### Notification Channels (Laravel)
```php
// NewEstimateNotification.php
public function via($notifiable): array
{
    $channels = ['database']; // Always in-app

    if ($notifiable->email_notifications_enabled) {
        $channels[] = 'mail';
    }

    // Push notification via Expo or FCM
    if ($notifiable->push_token) {
        $channels[] = ExpoPushChannel::class;
    }

    return $channels;
}

public function toArray($notifiable): array
{
    return [
        'type' => 'new_estimate',
        'property_id' => $this->estimate->property_id,
        'property_address' => $this->estimate->property->address,
        'artisan_name' => $this->estimate->artisan_name,
        'estimate_range' => [
            'low' => $this->estimate->estimate_low,
            'high' => $this->estimate->estimate_high,
        ],
    ];
}
```

### Estimates Section UI
```typescript
interface EstimatesSectionProps {
  estimates: ArtisanEstimate[];
}

const EstimatesSection = ({ estimates }: EstimatesSectionProps) => (
  <Paper sx={{ p: 2 }}>
    <Typography variant="h6">
      Estimations artisans ({estimates.length})
    </Typography>
    {estimates.length === 0 ? (
      <Typography color="text.secondary">
        Aucune estimation recue
      </Typography>
    ) : (
      <List>
        {estimates.map(estimate => (
          <EstimateCard key={estimate.id} estimate={estimate} />
        ))}
      </List>
    )}
  </Paper>
);
```

### Estimate Card Display
```typescript
const EstimateCard = ({ estimate }: { estimate: ArtisanEstimate }) => (
  <Card sx={{ mb: 1 }}>
    <CardContent>
      <Box sx={{ display: 'flex', justifyContent: 'space-between' }}>
        <Typography variant="subtitle1">{estimate.artisanName}</Typography>
        <Typography variant="caption" color="text.secondary">
          {formatTimeAgo(estimate.createdAt)}
        </Typography>
      </Box>
      <EstimateRangeBar
        low={estimate.estimateLow}
        high={estimate.estimateHigh}
      />
      <Typography variant="body2">
        Delai: {formatDuration(estimate.estimatedDuration)}
      </Typography>
      {estimate.comments && (
        <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
          {estimate.comments}
        </Typography>
      )}
    </CardContent>
  </Card>
);
```

### Notification Badge
```typescript
const NotificationBadge = () => {
  const { unreadCount } = useNotifications();

  if (unreadCount === 0) return null;

  return (
    <Badge
      badgeContent={unreadCount > 99 ? '99+' : unreadCount}
      color="error"
    >
      <NotificationsIcon />
    </Badge>
  );
};
```

### Email Template
```
Subject: Nouvelle estimation pour [Property Address]

Bonjour [Owner Name],

[Artisan Name] a soumis une estimation pour votre bien situe a [Address].

Fourchette estimee : [Low] - [High] EUR
Delai estime : [Duration]

Consultez les details dans l'application :
[Link to property]

---
MDB Copilot
```

### References
- [Source: epics.md#Story 12.4]
- [Source: prd.md#FR55 - Notification devis artisan]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
