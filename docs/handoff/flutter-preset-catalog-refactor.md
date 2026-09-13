# Flutter handoff: admin-authored preset catalog

## Why this work is required

The backend no longer seeds product presets from C# code.  The catalog is now
empty after the migration and receives entries only when an administrator
authors, validates, and explicitly publishes an immutable version.  The public
endpoints return only currently published versions.

The Flutter app still routes by the removed legacy keys
(`daily-linkedin-ai-post`, `smart-purchase-decision`,
`brain-dump-to-action`, and the receipt keys).  A newly published key therefore
can appear in the catalog but cannot be configured or reliably displayed.  The
legacy cache can also briefly show deleted presets after an upgrade.

Do this work in Flutter.  Do not reintroduce backend seeds or special-case a
preset key in the backend.

## Backend contract and ownership

Public mobile APIs are unchanged and do **not** require administrator bearer
authentication:

| API | Purpose |
| --- | --- |
| `GET /api/v1/presets` | Currently published summaries; may validly be `[]`. |
| `GET /api/v1/presets/{key}` | Currently published immutable details; `404` when absent or archived. |
| `POST /api/v1/workflows/runs` | Starts a run from `presetKey`, inputs, overrides, and one encrypted credential envelope. |
| `GET /api/v1/workflows/runs/{runId}` | Reads the in-memory run while it remains available. |
| `POST /api/v1/workflows/runs/{runId}/approval` | Submits the existing approval request. |
| `/api/v1/hubs/workflows` | Existing unauthenticated workflow SignalR hub. |

Keep user workflow instances, schedules, history, and credentials on the
device.  The backend does not schedule a user's workflow or send local
notifications.  Do not use the admin login/refresh endpoints from Flutter.

## Required implementation

### 1. Make the generic path the default

Route every published preset through the existing
`DynamicPresetConfigureScreen`; it is currently present but disconnected.
Replace the key-based branching in
`lib/ui/features/presets/preset_run_router.dart` and the details-screen calls
that depend on it.  A preset should be driven by its `inputSchemaJson`, agents,
workflow graph, integrations, and result contract rather than its key.

For a generic result, show in this order:

1. `renderedResult` when its media type is supported;
2. the parsed `arzly.report` result when its contract is supported;
3. a safe plain-text/JSON fallback using `finalResponse` or `resultDocument`.

For approval, provide a generic editable review screen only when the live run
has an approval snapshot.  Do not fall through to the LinkedIn review/result
screens for an unknown key.  For a preset with no approval node, take a
completed run directly to the generic result.

It is acceptable to retain specialized presentation as an optional registry
for a documented result contract, but an unknown published key must always use
the generic path.  The old key-specific screens, receipt migrations, and
key-specific privacy rules must not decide whether a newly authored preset is
supported.

### 2. Finish the schema-driven configure screen

`DynamicPresetConfigureScreen` is a useful foundation, but it is incomplete.
Make its renderer and validation honour the schema rather than the old preset
assumptions:

- honour `defaultValue`, `required`, `maxLength`, `minimum`, `maximum`, and
  `visibleWhen`;
- render `select`, `selectCards`, `date`, and `email` using their supplied
  options/format; retain a safe text-field fallback for unknown future types;
- validate only visible active fields and enforce the field's declared numeric
  bounds (not a universal non-negative rule);
- do not assume the primary input is named `topic`, that the default country is
  Lebanon, or that every currency list is the fixed five-item list;
- create agent overrides only where the detail contract permits an override.

The request remains `StartWorkflowRequest`: `presetKey`,
`Map<String, String> inputs`, agent overrides, and the encrypted credential
envelope.  Values must still be string-encoded because that is the API
contract.  Never place raw credentials in Drift, logs, or the navigation state.

### 3. Consume the complete public preset response

Extend the Freezed DTOs, generated JSON code, domain models, and mappers to
retain the following currently ignored public fields.  They are optional for
compatibility with older cached payloads.

| Response | Add |
| --- | --- |
| `PresetSummaryResponse` | `subtitle`, `backgroundExecution` |
| `PresetDetailsResponse` | `subtitle`, `detailedDescription`, `backgroundExecution` |
| `IntegrationRequirementResponse` | `connectorKey`, `requiredOAuthScopesJson`, `requiredApisJson`, `supportsBackgroundExecution` |
| new DTO/domain value | `BackgroundExecutionPolicyResponse(mode, rationale, allowedTriggerTypesJson)` |

Use `subtitle`/`detailedDescription` in the catalog and detail UI when present.
Use the integration `connectorKey` rather than only the hard-coded
`integrationConnectorMap`; known native connectors can still use their native
setup path, while unknown connectors must show a generic credential/setup
requirement without throwing.

Read `backgroundExecution.mode` and `allowedTriggerTypesJson` before exposing
on-device scheduling.  Show scheduling only when the policy permits the chosen
trigger.  `NotApplicable` and manual-only presets must never be schedulable.
The backend policy is descriptive; Flutter continues to own the actual local
scheduler and notifications.

### 4. Reconcile the local catalog safely

On a successful `refreshSummaries()`:

- replace the cached catalog atomically;
- evict cached **preset details** for keys/versions no longer returned by the
  public catalog, and clear a selected key that was removed;
- retain local run history, schedules, and secure credentials.  A catalog
  removal must not erase user data;
- treat `GET /presets/{key}` returning `404` as a stale catalog condition:
  evict that cached preset, refresh the catalog, and show a clear
  “This preset is no longer published” state instead of an indefinite error.

The initial empty state is expected until an administrator publishes a preset.
Make it actionable: explain that no presets are currently published and offer
a refresh control.  Do not seed or fabricate catalogue cards on the client.

### 5. Scope legacy behavior deliberately

The deleted keys are listed in
`docs/architecture/preset-catalog-migration.md`.  Do not make new behavior
depend on any of them.  Preserve old local data only as history/migration data
where it is needed for privacy; do not route a new generic preset through the
old LinkedIn, receipt, brain-dump, or smart-purchase screens.

## Verification required

Add or update unit/widget tests for all of the following:

- an empty `GET /presets` response renders the intentional empty state;
- a previously cached, now-unpublished key is evicted without deleting local
  workflow history or credentials;
- a fixture for a newly authored, arbitrary key opens, configures, starts, and
  renders using the generic path;
- all supported input field types, defaults, visibility rules, and numeric
  limits are exercised;
- an unknown integration/connector produces a recoverable setup requirement,
  not an `ArgumentError`;
- manual-only and `NotApplicable` background policies do not expose a schedule;
- approval, no-approval completion, and rendered-result/plain-text fallbacks
  each select the correct generic screen.

Then run:

```powershell
cd mobile/arzlyai_mobile
dart format lib test
flutter analyze
flutter test
```

Backend reference points: `PresetsController`, `WorkflowsController`,
`Application/DTOs/Presets`, `Application/DTOs/Workflows`, and
`Application/Mappers/Presets/PresetMapper`.
