# Story 8.2: Fiches memo consultables offline

Status: ready-for-dev

## Story

As a utilisateur sur le terrain,
I want consulter les fiches memo sans connexion,
so that j'ai acces a l'aide meme en zone blanche.

## Acceptance Criteria

**Given** les guides et fiches memo
**When** l'utilisateur se connecte pour la premiere fois
**Then** tout le contenu educatif est telecharge et stocke localement

**Given** l'appareil hors connexion
**When** l'utilisateur accede aux Memos MDB
**Then** tout le contenu est consultable sans erreur
**And** aucun message "connexion requise" n'apparait

## Tasks / Subtasks

### Backend API
- [ ] Add memos to sync payload: POST /api/sync
- [ ] Add memo content hash for change detection
- [ ] Add endpoint GET /api/memos/all (bulk download for initial sync)
- [ ] Write tests for memo sync

### Mobile App (React Native)
- [ ] Add WatermelonDB schema for memos table
- [ ] Implement initial memo download on first login
- [ ] Create MemoSyncService for background sync
- [ ] Add memo content to sync payload handler
- [ ] Show loading state during initial download
- [ ] Ensure Markdown renders from local data
- [ ] Add version/hash check for incremental updates
- [ ] Write tests for offline memo access
- [ ] Write tests for memo sync

### Web App (React)
- [ ] Add Dexie.js schema for memos table
- [ ] Implement initial memo download on first login
- [ ] Create memoSyncService for sync
- [ ] Add memo content to sync handler
- [ ] Show loading state during initial download
- [ ] Ensure Markdown renders from IndexedDB data
- [ ] Add version check for updates
- [ ] Write tests for offline functionality

### Shared Package
- [ ] Add MemoSyncPayload type
- [ ] Add memo hash calculation utility

## Dev Notes

### Architecture Reference
- Full memo content downloaded on first login
- Stored locally in WatermelonDB (mobile) / Dexie.js (web)
- Incremental sync based on content hash

### Initial Download Flow
```
1. User logs in for first time
2. App checks if memos exist locally
3. If not, call GET /api/memos/all
4. Store all memo content locally
5. Mark memos_downloaded = true
6. Subsequent logins: check for updates via hash
```

### Memo Sync Strategy
```typescript
interface MemoSyncState {
  lastSyncAt: Date | null;
  contentHash: string;
  memosDownloaded: boolean;
}

const syncMemos = async () => {
  const localState = await getMemoSyncState();

  if (!localState.memosDownloaded) {
    // Initial full download
    const allMemos = await api.get('/memos/all');
    await storeMemos(allMemos);
    await setMemoSyncState({
      lastSyncAt: new Date(),
      contentHash: calculateHash(allMemos),
      memosDownloaded: true
    });
  } else {
    // Check for updates
    const serverHash = await api.get('/memos/hash');
    if (serverHash !== localState.contentHash) {
      // Incremental update
      const updatedMemos = await api.get('/memos', {
        since: localState.lastSyncAt
      });
      await updateMemos(updatedMemos);
    }
  }
};
```

### WatermelonDB Schema
```typescript
// mobile-app/src/database/schema.ts
tableSchema({
  name: 'memos',
  columns: [
    { name: 'slug', type: 'string', isIndexed: true },
    { name: 'theme', type: 'string', isIndexed: true },
    { name: 'type', type: 'string' },
    { name: 'title', type: 'string' },
    { name: 'content_md', type: 'string' },
    { name: 'order', type: 'number' },
    { name: 'server_updated_at', type: 'number' }
  ]
})
```

### Dexie.js Schema
```typescript
// web-app/src/db/schema.ts
db.version(1).stores({
  memos: '&slug, theme, type, order, serverUpdatedAt'
});
```

### References
- [Source: epics.md#Story 8.2]
- [Source: prd.md#FR42]
- [Source: architecture.md#AR6, AR7]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
