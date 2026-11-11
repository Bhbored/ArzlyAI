# Admin authoring editor and turn recovery handoff

The React admin client and backend now use the same authoring contract. The admin UI calls these records **chats**; API routes remain under `sessions`.

## Backend endpoints

- `GET /api/v1/admin/authoring/session-summaries` loads the chat list without full drafts or message histories.
- `GET /api/v1/admin/authoring/runtime-models` loads catalog models for draft agents. `assistant-models` remains the separate chat-assistant selector.
- `PUT /api/v1/admin/authoring/sessions/{id}/draft` saves a complete structured draft with `{ expectedRevision, draft }`. A `409` means reload and compare; do not discard local edits.
- `POST /api/v1/admin/authoring/sessions/{id}/preview` accepts `{ expectedRevision, sampleInputs }` and resolves sample-input and literal mappings without executing providers or integrations.
- `POST /api/v1/admin/authoring/sessions/{id}/messages` accepts `{ content, expectedRevision, clientRequestId }`. Reuse the UUID only when retrying the same message. A failed turn leaves the admin message visible and can resume without a duplicate.

The full session now includes `draftRevision`, `validatedDraftRevision`, `turn` (`Running`, `Completed`, or `Failed`), and `publishReadiness` (`canPublish`, `blockers`). A running turn blocks other edits server-side. A validated draft becomes stale after changes; publication still requires the explicit publish action. `AssistantTextUpdated` hub events are transient partial replies; the persisted session message is authoritative. A disconnected client should poll the session while `turn.status` is `Running`.

Provider API-key failures are upstream errors, not admin authentication `401`s. Admin tokens should only be refreshed for actual admin API `401` responses.

## UI behavior already implemented

The chat workspace has a structured draft editor with explicit Save, graph canvas, mapping editor, validation issues, and dry-run preview. A revision conflict preserves local edits and shows both JSON drafts for comparison. Unsaved edits block chat submission and publication. The dashboard opens a new chat directly; chat and preset lists have search and status filters. Logout clears cached protected data. The list calls the items chats, while preserving the versioned API routes.

Abandon, restore, and permanent disposal retain their existing routes; see [the full admin contract](../admin/react-admin-contract.md) for those and other API details.

## Deployment and verification

Apply the EF migration `20260925202610_AuthoringEditorAndTurnRecovery` before using the new chat flow. It adds turn and draft revision columns and a unique `(SessionId, ClientRequestId)` message index. Do not remove the older auth migrations.

Verification completed after the builder follow-up: 153 backend tests, 5 UI unit tests, React lint, 5 browser tests, and the production build pass. The builder is split into its own bundle and the previous large-chunk warning is resolved. Browser tests use API fixtures; a live PostgreSQL/provider end-to-end run still needs a deployment smoke test, particularly a first message, second message, retry after a dropped connection, and save/publish revision conflict. See [the builder follow-up](admin-workflow-builder-and-integrations.md) for the new tab layout and contract additions.
