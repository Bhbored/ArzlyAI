# Flutter Client Plan: Daily LinkedIn AI Post

## Purpose and MVP Boundary

This is the implementation contract for the Flutter agent building the first client. Deliver one reliable vertical slice for `daily-linkedin-ai-post`; do not build the drag-and-drop editor, custom workflows, authentication, or an admin dashboard yet.

The user must be able to browse the preset, configure the writer, generate a draft, observe execution, edit or approve the draft, and publish it to LinkedIn. Flutter SQLite is the source of truth for local workflow instances and history. Backend PostgreSQL contains only the public preset catalog.

## Architecture and Structure

Follow Flutter's UI/data separation. Keep widgets free of networking, persistence, and encryption logic.

```text
lib/
  app/                         # routing, theme, dependency composition
  core/
    api/                       # HTTP client, errors, correlation handling
    crypto/                    # credential-envelope construction
    realtime/                  # SignalR connection and subscriptions
    storage/                   # SQLite and secure-storage adapters
  features/
    presets/
      data/                    # API models, service, repository
      presentation/            # catalog/details views and view models
    workflow_runs/
      data/                    # run models, local tables, repository
      domain/                  # state merge and transition rules
      presentation/            # configure/run/review/result views
    settings/                  # API and LinkedIn credentials
```

Views render immutable state. View models issue commands. Repositories coordinate local and remote sources. Services wrap HTTP, SignalR, SQLite, secure storage, and cryptography.

## Backend Contract

Use JSON camel-case names. Treat unknown response fields and enum values as forward-compatible. Send `X-Correlation-ID` with a new UUID-like value on each HTTP request and retain the returned value when reporting errors.

| Operation | Method and path | Result |
| --- | --- | --- |
| Liveness | `GET /health/live` | Backend process availability |
| Readiness | `GET /health/ready` | Backend and PostgreSQL availability |
| Catalog | `GET /api/v1/presets` | `PresetSummaryResponse[]` |
| Preset graph | `GET /api/v1/presets/daily-linkedin-ai-post` | `PresetDetailsResponse` |
| Encryption key | `GET /api/v1/security/encryption-key` | `EncryptionKeyDescriptor` |
| Start run | `POST /api/v1/workflows/runs` | `WorkflowRunResponse` |
| Recover run | `GET /api/v1/workflows/runs/{runId}` | `WorkflowRunResponse` or `404` |
| Review | `POST /api/v1/workflows/runs/{runId}/approval` | Updated `WorkflowRunResponse` |
| Schedule | `PUT /api/v1/workflows/{workflowId}/schedule` | `204` |
| Un-schedule | `DELETE /api/v1/workflows/{workflowId}/schedule` | `204` |
| Realtime | `/api/v1/hubs/workflows` | SignalR hub |

Generate Dart models from `backend/src/ArzlyAI.Application/DTOs`. Do not create a second interpretation of the graph. Render nodes ordered by `position`; derive edges from `sourceNodeId` and `targetNodeId`.

### Start request

```json
{
  "presetKey": "daily-linkedin-ai-post",
  "inputs": { "topic": "Practical uses of AI agents" },
  "agentOverrides": [
    { "agentKey": "content-writer", "model": "gpt-5-mini", "temperature": 0.7 }
  ],
  "credentials": {
    "keyId": "...", "requestId": "...", "expiresAtUnixSeconds": 0,
    "wrappedKey": "...", "nonce": "...", "ciphertext": "...", "tag": "..."
  }
}
```

Encrypted plaintext:

```json
{ "openai.apiKey": "user-provided-key" }
```

### Approval request

The backend currently serializes `ApprovalDecision` numerically: `Accept = 0`, `Edit = 1`, `Reject = 2`. Centralize this mapping in one serializer and add a contract test.

```json
{
  "decision": 1,
  "editedContent": "The final user-edited post",
  "credentials": {
    "keyId": "...", "requestId": "...", "expiresAtUnixSeconds": 0,
    "wrappedKey": "...", "nonce": "...", "ciphertext": "...", "tag": "..."
  }
}
```

For accept or edit, encrypt fresh LinkedIn credentials:

```json
{
  "linkedin.accessToken": "...",
  "linkedin.authorUrn": "urn:li:person:..."
}
```

Reject may send `credentials: null`. Never reuse an envelope: request IDs are replay-protected.

## Credential Handling

API keys cannot be hashed and later decrypted. Store them through `flutter_secure_storage`, whose platform storage protects the reversible secret at rest. Never put secrets, credential envelopes, or author URNs in logs, analytics, crash metadata, URLs, or SQLite. Generated and edited content belongs in the user's local SQLite history, but must not be logged or sent to analytics.

For every protected backend call:

1. Fetch `/security/encryption-key`; keep the descriptor only in process memory.
2. Generate a cryptographically random 32-byte AES key and 12-byte nonce.
3. Create a unique `requestId` and an expiry no more than `maximumLifetimeSeconds` ahead (currently 120 seconds).
4. UTF-8 encode compact credentials JSON.
5. Set AES-GCM associated data exactly to `keyId|requestId|expiresAtUnixSeconds`.
6. Encrypt with AES-256-GCM and retain its 16-byte authentication tag.
7. Wrap the AES key using the PEM SubjectPublicKeyInfo RSA key with OAEP-SHA-256.
8. Base64-encode `wrappedKey`, `nonce`, `ciphertext`, and `tag` independently.
9. Release temporary byte buffers as soon as the request finishes.

If encryption fails because the backend restarted or the key expired, discard the envelope, fetch a new descriptor, and retry once with a new request ID. Never retry an already-submitted envelope.

## Local Data Model

Create migrations from the first client release.

| Table | Minimum fields |
| --- | --- |
| `preset_cache` | key, version, response JSON, fetched-at UTC |
| `workflow_instances` | local ID, preset key/version, name, topic, model overrides, created/updated UTC |
| `workflow_runs` | run ID, local workflow ID, status, approval snapshot, final response, created/updated UTC, expiry UTC |
| `workflow_node_runs` | run ID, node ID/key, type, status, output, error, updated UTC |
| `schedules` | local workflow ID, local time, IANA time-zone ID, enabled, backend schedule status |

Do not copy secrets into these tables. Store only secure-storage lookup aliases. Cache preset responses by `(key, version)` and preserve the exact version used by each workflow instance.

## Realtime State

Use the SignalR hub method `SubscribeToRun(runId)` and listen for `NodeChanged`:

```text
runId, nodeId, nodeKey, status, isRunning, message, occurredAtUtc
```

The start call currently performs generation before returning, so initial events may be missed. Always merge the authoritative `WorkflowRunResponse` into local state, then apply newer SignalR events by `occurredAtUtc`. On reconnection, subscribe again and call `GET /runs/{runId}`. A `404` means the in-memory backend run expired; preserve local history and mark it expired.

| Status | Presentation |
| --- | --- |
| `Idle` | Neutral node |
| `Running` / `isRunning: true` | Animated progress indicator |
| `WaitingForApproval` | Review action and notification badge |
| `Completed` | Success state |
| `Failed` | Error state with correlation ID and safe guidance |
| `Skipped` | Muted node |

## Screens and User Flow

1. **Onboarding/settings:** configure backend URL, OpenAI key, LinkedIn access token, and author URN. Store secrets securely and support deletion.
2. **Preset catalog:** load cached summaries immediately, refresh from the API, and show offline/error states.
3. **Preset details:** show both agents and the four-node graph. System prompts are view-only. Respect model editability, allowed models, temperature bounds, and temperature editability from the response.
4. **Configure run:** require a non-empty topic; allow overrides only where the server permits them.
5. **Execution:** show node progress and persist every returned snapshot transactionally.
6. **Review:** display original and current content separately. Accept publishes unchanged text; edit requires non-empty text; reject cancels without LinkedIn credentials.
7. **Result:** show completion/failure and the returned LinkedIn post identifier. Never treat animation alone as proof of publication.

Prevent double submission while a command is active. Preserve draft edits across lifecycle changes. Require explicit confirmation immediately before publishing.

## Error and Offline Rules

- Parse errors as `{ success, message, correlationId }`; display a safe message and correlation ID.
- Honor `429` and `Retry-After`; disable the action until retry is allowed.
- Do not automatically retry start, approval, or publish because results may be non-idempotent.
- Time out calls and expose retry for safe GET requests.
- Offline mode permits catalog browsing and draft editing, but not generation or publication.
- Validate TLS outside development. Never accept invalid production certificates.

## Known Backend Dependencies

Do not claim these features as complete until the backend contract changes:

- `LoggingNotificationService` only logs; closed-app push is not implemented.
- Workflow runs are backend-memory entries that expire after 30 minutes.
- SignalR cannot deliver while the app is terminated; push plus state recovery is required.
- Scheduling currently lacks the local workflow snapshot and fresh credentials needed for execution. Hide it behind a development feature flag.
- Start finishes generation before returning a run ID, so the client misses some initial events.
- LinkedIn OAuth acquisition/refresh is not implemented; the MVP accepts an access token and author URN.

Raise backend contract changes instead of adding client-only workarounds.

## Delivery Order

1. API models, HTTP service, errors, and mock fixtures.
2. SQLite schema/repositories and secure-storage adapter.
3. Catalog and preset-details screens.
4. Credential-envelope implementation with deterministic crypto-vector tests.
5. Start configuration and response persistence.
6. SignalR events, merging, reconnect, and run recovery.
7. Review/edit/reject and LinkedIn publication.
8. Lifecycle, offline, accessibility, and end-to-end testing.
9. Enable scheduling and push only after backend dependencies are complete.

## Required Tests and Acceptance

- DTO fixtures cover every preset/run response and numeric approval decisions.
- Repository tests prove SQLite survives restart and contains no credentials.
- Crypto tests verify RSA-OAEP-SHA-256, AES-256-GCM, AAD, base64 fields, expiry, and unique request IDs against a backend-compatible vector.
- View-model tests cover validation, duplicate taps, node statuses, approval decisions, `429`, expiry, reconnect, and `404` recovery.
- Widget tests cover locked prompts, model controls, temperature bounds, progress, review snapshots, and accessible errors.
- An integration test completes catalog -> details -> generate -> edit -> approve -> LinkedIn handler response.

The MVP is accepted only when no secret appears in SQLite or logs, a restarted app restores local history, missed realtime events reconcile from the run response, and publication requires explicit approval.

## References

- Flutter architecture: <https://docs.flutter.dev/app-architecture/guide>
- Flutter networking: <https://docs.flutter.dev/data-and-backend/networking>
- Flutter WebSocket guidance: <https://docs.flutter.dev/cookbook/networking/web-sockets>
- Secure storage package: <https://pub.dev/packages/flutter_secure_storage>
- Backend preset: `backend/src/ArzlyAI.Infrastructure/Persistence/Seeds/LinkedInPresetSeed.cs`
- Backend DTOs: `backend/src/ArzlyAI.Application/DTOs/Presets` and `backend/src/ArzlyAI.Application/DTOs/Workflows`
- Credential implementation: `backend/src/ArzlyAI.Infrastructure/Security/EphemeralCredentialEnvelopeProtector.cs`
