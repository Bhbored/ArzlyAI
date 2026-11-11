# React Admin Client Contract

This is the implementation handoff for the React administrator client. It documents backend behavior for the admin API and authoring hub.

## Authentication

Use API base `/api/v1`. Authentication is a single seeded administrator backed by ASP.NET Core Identity. There is no registration, invitation, account list, refresh cookie, or multi-admin UI.

Store the login/refresh token pair and admin profile in `sessionStorage` under one key such as `arzlyai.admin.auth` (an in-memory copy for the tab lifetime is fine). Do not use local storage, browser cookies, URLs, analytics, or logs for either token.

Protected admin HTTP endpoints and the authoring hub use the standard ASP.NET Core Identity `Admin` role with bearer authentication. Access tokens remain valid until their configured expiry; logout, refresh rotation, and password changes revoke the stored refresh token immediately.

1. `POST /api/v1/admin/auth/login` with `{ "email": "...", "password": "..." }` → `200` and the auth response below.
2. Store the returned token pair (and profile fields).
3. Send `Authorization: Bearer <accessToken>` on protected HTTP calls.
4. On one `401`, call refresh, replace the entire stored pair, retry once, then clear session storage and show login if it still fails. Proactive refresh near access-token expiry (and on app bootstrap) is allowed.
5. `POST /api/v1/admin/auth/logout` with the bearer token → `204`, then clear session storage whether it succeeds or fails.

`POST /api/v1/admin/auth/refresh` receives:

```json
{ "accessToken": "expired-or-current-jwt", "refreshToken": "current-refresh-token" }
```

Login and refresh both return:

```json
{
  "adminId": "guid",
  "email": "admin@example.com",
  "displayName": "Administrator",
  "accessToken": "jwt",
  "accessTokenExpiresAtUtc": "2026-09-05T20:00:00Z",
  "refreshToken": "rotated-token",
  "refreshTokenExpiresAtUtc": "2026-10-05T20:00:00Z"
}
```

`POST /api/v1/admin/auth/change-password` requires `{ "currentPassword": "...", "newPassword": "..." }` and a bearer token. On success it returns `204`; clear storage and require login. `POST /api/v1/admin/auth/logout` requires a bearer token and returns `204`.

Non-success responses use:

```json
{ "success": false, "message": "...", "correlationId": "..." }
```

Publish validation failures (`422`) additionally include `validation` with `{ "errors": [{ "path": "...", "message": "..." }] }`. Outside Development, `message` may be a generic public string.

## Authoring screen

Load `GET /api/v1/admin/authoring/capabilities` for a read-only capability browser. Each item includes `key`, `kind` (`Integration` | `Operation`), `displayName`, `description`, `connectorKey`, schema JSON fields, OAuth scopes, required APIs, documentation links, `riskLevel`, and `supportsBackgroundExecution`.

Load `GET /api/v1/admin/authoring/assistant-models` for the assistant model picker. This protected endpoint returns only server-configured models that support the function tools required to inspect capabilities, save drafts, and validate drafts. It never exposes provider keys. Each item includes `provider`, `model`, `displayName`, `supportsTemperature`, `supportsWebSearch`, and `isDefault`.

Create a chat with `POST /api/v1/admin/authoring/sessions` and `{ "title": "optional" }` (optional `provider` / `model` may select a non-default assistant at creation). New chats start at `revision` `0`. Clone-to-draft chats start at `revision` `1`. The response is a full session object including:

```json
"assistantModel": { "provider": "openai", "model": "gpt-5-mini" }
```

For manual workflow creation, include `useVisualBuilder: true`. This creates an editable session without requiring an available authoring assistant. Chat and model changes still require a configured assistant. The Catalog's Create workflow action uses this option and opens `?tab=builder`.

The Integrations UI at `/integrations` filters the combined capability response to `kind === "Integration"`. Built-in operations are reusable processing components in the builder, not admin-authored workflows. `/capabilities` redirects to `/integrations`. The admin Catalog list excludes legacy rows without `publishedByAdminId`.

The workspace has separate Chat, Workflow builder, and Review tabs. Each draft node may include `editorPosition: { x, y }`; the authoring backend preserves these coordinates in draft JSON. They are optional, do not affect execution order, and require no database migration. Published execution graphs do not depend on these canvas coordinates.

Session `status` values are `Active`, `ReadyToPublish`, `Published`, and `Abandoned`.

The API retains the `sessions` route for compatibility; the UI calls them chats. Use `GET /api/v1/admin/authoring/session-summaries` for the chat list instead of loading every draft and message. Each summary includes `id`, `title`, `status`, `revision`, `assistantModel`, and `updatedAtUtc`.

The full session includes `draftRevision`, `validatedDraftRevision`, `turn: { id, status, startedAtUtc, error }`, and `publishReadiness: { canPublish, blockers[] }`. A `Running` turn blocks edits server-side. `Completed` and `Failed` persist across reloads. The server recovers stale running turns after six minutes. Validation is current only when `validatedDraftRevision === draftRevision`. Use `publishReadiness` as the source of truth for publishing.

`GET /api/v1/admin/authoring/runtime-models` supplies catalog models for agents inside the preset draft. This is distinct from `assistant-models`, which selects the admin chat assistant. Neither endpoint exposes provider credentials.

To select a different available model before sending a message, call:

```http
PUT /api/v1/admin/authoring/sessions/{sessionId}/assistant-model
Authorization: Bearer ...
Content-Type: application/json

{ "provider": "anthropic", "model": "claude-sonnet-4-5", "expectedRevision": 0 }
```

The response is the updated session and increments `revision`; refresh local session state before submitting chat. Treat `400` as unavailable, disabled, unconfigured, or unsupported-for-tool-calling. Treat `409` as a stale revision or non-mutable session; reload the session. Do not offer manual provider/model text entry. Restore sessions with `GET /api/v1/admin/authoring/sessions` and `GET /api/v1/admin/authoring/sessions/{id}`.

Connect SignalR to `/api/v1/hubs/admin-authoring`. Its `accessTokenFactory` reads the current access token; if expiry is near, refresh first. Then invoke `JoinSession(sessionId)`. Call `LeaveSession(sessionId)` on disconnect. Automatic reconnect with re-join is recommended. Handle these event names and payloads:

| Event | Payload | Client action |
| --- | --- | --- |
| `TurnStarted` | `{ sessionId }` | Mark the session turn active |
| `AssistantTextUpdated` | `{ sessionId, streamId, sequence, text }` | Show transient partial assistant text; replace it with the persisted message on completion |
| `ToolStarted` | `{ name }` | Show a status indicator |
| `ToolCompleted` | `{ name }` | Clear that tool indicator |
| `DraftUpdated` | `{ sessionId }` | Refetch `GET .../sessions/{id}` (payload has no draft/revision) |
| `ValidationChanged` | `{ errors: [{ path, message }] }` (and derived `isValid`) | Update validation UI and/or refetch the session |
| `TurnCompleted` | `{ session, assistantMessage }` | Replace local session with `session`; clear turn-active |
| `TurnFailed` | `{ message }` | Show the failure; refetch the session; clear turn-active |

There is no `ContentDelta` event. Partial text is transient; the saved message in the complete session is authoritative.

Send chat through `POST /api/v1/admin/authoring/sessions/{id}/messages`:

```json
{
  "content": "Add human review before sending the email.",
  "expectedRevision": 3,
  "clientRequestId": "a-unique-uuid-for-this-user-message"
}
```

The response is:

```json
{
  "session": { /* full AuthoringSessionResponse */ },
  "assistantMessage": "..."
}
```

An accepted admin message increments the session revision before the assistant runs. Draft saves during the same turn may increment it again, so treat `revision` as an opaque server value: always replace local state with the revision returned in the complete session response and never calculate the next value.

Keep the same `clientRequestId` when retrying the same message after a network failure; use a new ID for new content. A failed provider call leaves the admin message and failed turn visible, so retry can resume without duplicating it. Provider authentication failures are upstream errors, not admin-token `401`s; do not refresh the admin token for them.

HTTP `409` on authoring writes means a stale revision, a concurrent write, a running turn, or a non-editable session. Reload `GET /api/v1/admin/authoring/sessions/{id}` and preserve unsaved local edits for comparison. The server locks an active turn; the client should also disable concurrent edits while it runs. Message processing uses a server-side five-minute timeout (`408` on timeout).

Render chat and the structured draft side by side. Show title, subtitle, descriptions, required inputs, agents/models/Harness settings (including planning, todo tracking, context compaction, tool approval, max iterations, and web search), node graph, connector requirements derived from integration nodes plus the capability catalog (`connectorKey`, scopes, APIs, risk), background policy, and admin notes. Tool events are status indicators, not editable chat messages. Disable additional edits while a turn is active for that session.

## Validate and publish

`PUT /api/v1/admin/authoring/sessions/{id}/draft` accepts `{ "expectedRevision": 3, "draft": { /* complete structured draft */ } }` and returns the full session. Explicit save updates `draftRevision`, runs validation, and invalidates the previous validated revision. If `409` occurs, keep local edits and let the admin compare them with the latest saved draft; never silently overwrite them.

`POST /api/v1/admin/authoring/sessions/{id}/preview` accepts `{ "expectedRevision": 4, "sampleInputs": {} }` and returns `{ draftRevision, validation, nodes[] }` with ordered nodes and mapping statuses (`Resolved`, `Optional`, `Missing`, `TypeMismatch`, `RequiresExecution`). This is a dry run of the saved draft: it does not call models, integrations, or publish.

`POST /api/v1/admin/authoring/sessions/{id}/validate` returns the complete session with errors shaped as `{ path, message }`. Group them by draft section and link each error to the relevant inspector card.

Publishing is an explicit confirmation button, never an automatic consequence of a chat response:

```http
POST /api/v1/admin/authoring/sessions/{id}/publish
Authorization: Bearer ...
Content-Type: application/json

{ "expectedRevision": 4 }
```

A validation failure returns HTTP `422` with the error envelope above (including `validation.errors`). On success, the response is `200` with `{ "presetId": "guid" }`. Refresh both the authoring session and version list. Missing capabilities are also rejected by the server on publish; still show them in the UI and prevent publication when a draft references a capability absent from `GET .../capabilities`.

## Version management

- `GET /api/v1/admin/presets`: all published and archived versions.
- `GET /api/v1/admin/presets/{key}/versions/{version}`: `{ preset, status, publishedByAdminId, supersedesPresetId, adminNotes[] }` where `adminNotes[].linksJson` is a raw JSON string.
- `POST /api/v1/admin/presets/{key}/versions/{version}/draft`: clone an immutable version into a new session (`revision` starts at `1`) → `200` session.
- `POST /api/v1/admin/presets/{key}/versions/{version}/archive`: remove that version from public visibility without deleting history → `204`.
- `POST /api/v1/admin/authoring/sessions/{id}/abandon`: abandon a chat while keeping its history → updated session.
- `POST /api/v1/admin/authoring/sessions/{id}/restore`: undo abandon → updated session.
- `DELETE /api/v1/admin/authoring/sessions/{id}/permanent`: permanently dispose of an abandoned chat → `204`. Confirm this irreversible action in the UI.
- `DELETE /api/v1/admin/authoring/sessions/{id}`: legacy abandon route → `204`; prefer the explicit route above.
- `POST /api/v1/admin/authoring/sessions`: create → `201` with the session body.

The public mobile catalog may remain empty. That is a valid initial state, not a loading failure. It changes only after explicit publication.

Authoring HTTP endpoints and the hub connection are rate-limited (default 60 requests / 60 s per IP). Hub method invocations use a separate higher limit.

## Suggested UI state

Keep server state in a query cache and transient chat-stream state in memory. Separate `auth`, `session`, `draftRevision`, `validation`, `activeToolCalls`, and `connectionState`; do not use one global loading flag. Disable message submission only during that session's active turn. Disable Publish until validation succeeds for the currently displayed revision. Admin notes must never be requested from or exposed through public preset routes.
