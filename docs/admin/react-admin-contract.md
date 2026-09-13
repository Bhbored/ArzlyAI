# React Admin Client Contract

This is the implementation handoff for the React administrator client. It documents backend behavior only; no React changes were made as part of the backend migration.

## Authentication

Use API base `/api/v1`. Authentication is a single seeded administrator backed by ASP.NET Core Identity. There is no registration, invitation, account list, refresh cookie, or multi-admin UI.

Store the complete login/refresh response in `sessionStorage` under one key such as `arzlyai.admin.auth`. Do not use local storage, browser cookies, URLs, analytics, or logs for either token.

Protected admin HTTP endpoints and the authoring hub use the standard ASP.NET Core Identity `Admin` role with bearer authentication. Access tokens remain valid until their configured expiry; logout, refresh rotation, and password changes revoke the stored refresh token immediately.

1. `POST /admin/auth/login` with `{ "email": "...", "password": "..." }`.
2. Store the returned token pair.
3. Send `Authorization: Bearer <accessToken>` on protected HTTP calls.
4. On one `401`, call refresh, replace the entire stored pair, retry once, then clear session storage and show login if it still fails.
5. `POST /admin/auth/logout` with the bearer token, then clear session storage whether it succeeds or fails.

`POST /admin/auth/refresh` receives:

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

`POST /admin/auth/change-password` requires `{ "currentPassword": "...", "newPassword": "..." }` and a bearer token. On success, clear storage and require login. `POST /admin/auth/logout` requires a bearer token and returns `204`.

## Authoring screen

Load `GET /admin/authoring/capabilities` for a read-only capability browser. Load `GET /admin/authoring/assistant-models` for the assistant model picker. This protected endpoint returns only server-configured models that support the function tools required to inspect capabilities, save drafts, and validate drafts. It never exposes provider keys.

Create a session with `POST /admin/authoring/sessions` and `{ "title": "optional" }`. The response includes:

```json
"assistantModel": { "provider": "openai", "model": "gpt-5-mini" }
```

To select a different available model before sending a message, call:

```http
PUT /api/v1/admin/authoring/sessions/{sessionId}/assistant-model
Authorization: Bearer ...
Content-Type: application/json

{ "provider": "anthropic", "model": "claude-sonnet-4-5", "expectedRevision": 0 }
```

The response is the updated session and increments `revision`; refresh local session state before submitting chat. Treat a 400 response as unavailable, disabled, unconfigured, or unsupported-for-tool-calling. Do not offer manual provider/model text entry. Restore sessions with `GET /admin/authoring/sessions` and `GET /admin/authoring/sessions/{id}`.

Connect SignalR to `/api/v1/hubs/admin-authoring`. Its `accessTokenFactory` reads the current access token from session storage; if expiry is near, refresh first. Then invoke `JoinSession(sessionId)`. Handle these event names:

- `TurnStarted`, `ContentDelta`, `ToolStarted`, `ToolCompleted`
- `DraftUpdated`, `ValidationChanged`, `TurnCompleted`, `TurnFailed`

Send chat through `POST /admin/authoring/sessions/{id}/messages`:

```json
{
  "content": "Add human review before sending the email.",
  "expectedRevision": 3
}
```

Render chat and the structured draft side by side. Show title, subtitle, descriptions, required inputs, agents/models/Harness settings, node graph, connector requirements, background policy, and admin notes. Tool events are status indicators, not editable chat messages. Treat revision conflicts as stale state: reload the session rather than overwriting a newer draft.

## Validate and publish

`POST /admin/authoring/sessions/{id}/validate` returns the complete session with errors shaped as `{ path, message }`. Group them by draft section and link each error to the relevant editor card.

Publishing is an explicit confirmation button, never an automatic consequence of a chat response:

```http
POST /api/v1/admin/authoring/sessions/{id}/publish
Authorization: Bearer ...
Content-Type: application/json

{ "expectedRevision": 4 }
```

A validation failure returns HTTP 422. On success, the response contains `presetId`. Refresh both the authoring session and version list. If the agent recommends a capability not present in the capability response, show the missing capability and prevent publication.

## Version management

- `GET /admin/presets`: all published and archived versions.
- `GET /admin/presets/{key}/versions/{version}`: full version including admin notes.
- `POST /admin/presets/{key}/versions/{version}/draft`: clone an immutable version into a new session.
- `POST /admin/presets/{key}/versions/{version}/archive`: remove that version from public visibility without deleting history.
- `DELETE /admin/authoring/sessions/{id}`: abandon a draft session.

The public mobile catalog may remain empty. That is a valid initial state, not a loading failure. It changes only after explicit publication.

## Suggested UI state

Keep server state in a query cache and transient chat-stream state in memory. Separate `auth`, `session`, `draftRevision`, `validation`, `activeToolCalls`, and `connectionState`; do not use one global loading flag. Disable message submission only during that session's active turn. Disable Publish until validation succeeds for the currently displayed revision. Admin notes must never be requested from or exposed through public preset routes.
