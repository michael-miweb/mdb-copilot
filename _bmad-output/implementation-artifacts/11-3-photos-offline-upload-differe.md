# Story 11.3: Photos offline et upload differe

Status: ready-for-dev

## Story

As a utilisateur,
I want que mes photos soient stockees localement et uploadees quand le reseau revient,
so that je peux documenter mes visites sans contrainte reseau.

## Acceptance Criteria

**Given** une photo prise en mode offline
**When** la photo est capturee
**Then** elle est compressee (< 500KB) et stockee localement
**And** elle est visible immediatement dans l'app
**And** elle est ajoutee a la queue d'upload

**Given** des photos en queue d'upload
**When** le reseau revient
**Then** les photos sont uploadees en arriere-plan par ordre chronologique
**And** l'upload n'impacte pas la navigation de l'utilisateur
**And** chaque photo uploadee est marquee comme synchronisee

**Given** un upload de photo qui echoue
**When** l'erreur survient
**Then** la photo reste en queue pour retry ulterieur
**And** elle reste consultable localement
**And** un indicateur montre les photos en attente d'upload

## Tasks / Subtasks

### Backend Tasks
- [ ] Create `POST /api/photos` endpoint for photo upload
  - [ ] Accept multipart form data
  - [ ] Generate signed URL for storage
  - [ ] Return photo metadata with server ID
- [ ] Implement photo storage (local disk or S3-compatible)
- [ ] Add photo compression validation (reject > 1MB)
- [ ] Create `GET /api/photos/{id}` with signed URL (NFR-S5)
- [ ] Write feature tests for photo upload

### Frontend Tasks (Mobile - React Native)
- [ ] Create `PhotoCaptureService`
  - [ ] Camera integration (expo-camera or react-native-camera)
  - [ ] Image compression (target < 500KB) (NFR-SC3)
  - [ ] Local file storage (expo-file-system)
- [ ] Create `PhotoUploadQueue` service
  - [ ] FIFO queue management
  - [ ] Background upload processing
  - [ ] Retry logic with backoff
  - [ ] Progress tracking per photo
- [ ] Create `photos` table in WatermelonDB
  - [ ] Local URI
  - [ ] Server URL (after upload)
  - [ ] Upload status
  - [ ] Associated entity (property, visit guide question)
- [ ] Create `usePhotoQueue` hook
  - [ ] Queue status
  - [ ] Pending count
  - [ ] Upload progress
- [ ] Create `PhotoThumbnail` component
  - [ ] Show upload status indicator
  - [ ] Display from local URI
- [ ] Update `OfflineSyncIndicator` with photo queue status
- [ ] Write tests for photo capture and queue

### Frontend Tasks (Web - React)
- [ ] Create `PhotoUploadService`
  - [ ] File input handling
  - [ ] Client-side compression (browser-image-compression)
  - [ ] IndexedDB blob storage via Dexie
- [ ] Create `PhotoUploadQueue` service
  - [ ] Queue management with Dexie
  - [ ] Background upload
  - [ ] Retry logic
- [ ] Create `photos` store in Dexie
- [ ] Create `usePhotoQueue` hook
- [ ] Create `PhotoThumbnail` MUI component
- [ ] Write tests for photo upload

### Shared Package Tasks
- [ ] Add photo types: `Photo`, `PhotoUploadStatus`, `PhotoQueue`
- [ ] Add image compression utilities (if shareable)
- [ ] Add file size validation utilities

## Dev Notes

### Architecture Reference
- Photos compressed < 500KB before upload (NFR-SC3)
- Authenticated photo access via signed URLs (NFR-S5)
- Background upload with low priority
- Local storage for immediate display
- Mobile: WatermelonDB for metadata (AR6)
- Web: Dexie.js for metadata + IndexedDB for blobs (AR7)

### Photo Compression (React Native)
```typescript
// Using react-native-image-resizer or expo-image-manipulator
import * as ImageManipulator from 'expo-image-manipulator';

const compressPhoto = async (uri: string): Promise<string> => {
  const result = await ImageManipulator.manipulateAsync(
    uri,
    [{ resize: { width: 1200 } }],
    { compress: 0.7, format: ImageManipulator.SaveFormat.JPEG }
  );

  // Check size and compress further if needed
  const info = await FileSystem.getInfoAsync(result.uri);
  if (info.size > 500 * 1024) {
    return compressPhoto(result.uri); // Recursive with lower quality
  }

  return result.uri;
};
```

### Photo Compression (Web)
```typescript
import imageCompression from 'browser-image-compression';

const compressPhoto = async (file: File): Promise<File> => {
  const options = {
    maxSizeMB: 0.5, // 500KB
    maxWidthOrHeight: 1200,
    useWebWorker: true,
  };

  return await imageCompression(file, options);
};
```

### Upload Queue Schema
```typescript
interface PhotoQueueItem {
  id: string;
  localUri: string;
  entityType: 'property' | 'visit_guide' | 'checklist';
  entityId: string;
  questionId?: string; // For visit guide photos
  status: 'pending' | 'uploading' | 'success' | 'error';
  attempts: number;
  createdAt: number;
  lastAttemptAt?: number;
}
```

### Background Upload Strategy
```typescript
const processUploadQueue = async () => {
  const queue = await getPhotoQueue();

  for (const item of queue) {
    if (item.status === 'uploading') continue;

    try {
      await markAsUploading(item.id);
      const serverUrl = await uploadPhoto(item.localUri);
      await markAsSuccess(item.id, serverUrl);
    } catch (error) {
      await markAsError(item.id);
      // Continue to next photo, don't block queue
    }
  }
};

// Run on network reconnection and periodically
// Mobile: NetInfo listener
// Web: navigator.onLine listener
```

### Photo Display Priority
1. Local URI (immediate)
2. Cached server URL
3. Remote fetch (if not cached)

### References
- [Source: epics.md#Story 11.3]
- [Source: architecture.md#NFR-SC3 - Photo compression < 500KB]
- [Source: architecture.md#NFR-S5 - Authenticated photo access]
- [Source: architecture.md#AR6 - WatermelonDB]
- [Source: architecture.md#AR7 - Dexie.js]
- [Source: prd.md#FR47 - Photos offline]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
