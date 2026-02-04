# Story 5.3: Photos contextualisees et notes agent

Status: ready-for-dev

## Story

As a utilisateur,
I want prendre des photos liees a un point du guide et saisir des notes,
so that je documente visuellement les constats et conserve les informations verbales.

## Acceptance Criteria

**Given** une question du guide de visite
**When** l'utilisateur prend une photo via le bouton camera
**Then** la photo est liee a la question/categorie specifique
**And** la photo est compressee (< 500KB) et stockee localement
**And** une miniature apparait a cote de la question

**Given** le guide de visite
**When** l'utilisateur accede a la section "Notes agent"
**Then** il peut saisir du texte libre sur les echanges avec l'agent immobilier
**And** les notes sont horodatees et liees a la visite

**Given** plusieurs photos prises pendant la visite
**When** l'utilisateur consulte la galerie de la visite
**Then** les photos sont organisees par categorie
**And** chaque photo affiche la question associee

## Tasks / Subtasks

### Backend API
- [ ] Create `visit_guide_photos` migration table (id, visit_guide_id, category, question_key, file_path, thumbnail_path, created_at)
- [ ] Create `visit_guide_notes` migration table (id, visit_guide_id, content, noted_at, created_at, updated_at)
- [ ] Create VisitGuidePhoto and VisitGuideNote models
- [ ] Add photo upload endpoint: POST /api/visit-guides/{id}/photos
- [ ] Add photo compression middleware (max 500KB, WebP format)
- [ ] Add notes endpoints: GET/POST/PATCH /api/visit-guides/{id}/notes
- [ ] Generate signed URLs for photo access (NFR-S5)
- [ ] Write tests for photo upload and compression

### Mobile App (React Native)
- [ ] Create CameraButton component with expo-camera integration
- [ ] Create PhotoThumbnail component for inline display
- [ ] Implement image compression before storage (expo-image-manipulator)
- [ ] Create AgentNotesSection component with timestamped entries
- [ ] Create VisitGalleryScreen organized by category
- [ ] Add WatermelonDB schema for photos and notes
- [ ] Implement local photo storage with FileSystem
- [ ] Create useVisitPhotos hook for photo management
- [ ] Write tests for photo capture and compression
- [ ] Write tests for notes functionality

### Web App (React)
- [ ] Create PhotoUploadButton component with file input
- [ ] Create PhotoThumbnail component with lightbox preview
- [ ] Implement client-side image compression (browser-image-compression)
- [ ] Create AgentNotesSection component
- [ ] Create VisitGalleryModal organized by category
- [ ] Add Dexie.js schema for photos (store as Blob) and notes
- [ ] Create useVisitPhotos hook
- [ ] Write tests for photo upload and gallery

### Shared Package
- [ ] Add VisitGuidePhoto and VisitGuideNote types
- [ ] Add image compression utility (shared settings)
- [ ] Add photo organization utility (group by category)

## Dev Notes

### Architecture Reference
- Photo compression: < 500KB before upload (NFR-SC3)
- Signed URLs for photo access (NFR-S5)
- Local storage for offline support (FR34, AR6/AR7)

### Photo Compression Settings
```typescript
const PHOTO_COMPRESSION = {
  maxWidth: 1920,
  maxHeight: 1080,
  quality: 0.7,
  maxSizeKB: 500,
  format: 'webp'
};
```

### Mobile Photo Capture
```typescript
// Using expo-camera + expo-image-manipulator
const capturePhoto = async (questionKey: string) => {
  const result = await ImagePicker.launchCameraAsync({
    quality: 0.7,
    allowsEditing: false,
  });
  // Compress and store locally
};
```

### Notes Data Structure
```typescript
interface VisitGuideNote {
  id: string;
  visitGuideId: string;
  content: string;
  notedAt: Date; // Timestamp when note was taken
  createdAt: Date;
  updatedAt: Date;
}
```

### References
- [Source: epics.md#Story 5.3]
- [Source: prd.md#FR32, FR33]
- [Source: architecture.md#NFR-SC3, NFR-S5]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
