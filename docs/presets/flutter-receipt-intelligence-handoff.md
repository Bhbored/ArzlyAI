# Flutter Handoff: One Configurable Receipt Preset

## Goal

The backend now publishes one catalog item, `receipt-intelligence`, instead of seven receipt presets. The user selects the analysis goal while configuring the run. Do not recreate one catalog card per mode in Flutter.

The backend seed also marks these legacy PostgreSQL catalog rows unpublished:

- `receipt-monthly-spending`
- `receipt-weekly-budget`
- `receipt-quarterly-tax`
- `receipt-yearly-review`
- `receipt-category-dive`
- `receipt-anomaly-detector`
- `receipt-savings-tracker`

## Backend Contract

`GET /api/v1/presets` returns one receipt summary with key `receipt-intelligence`. `GET /api/v1/presets/receipt-intelligence` returns input schema version 2. Its primary field is `analysisMode`, type `selectCards`, with these values:

| Value | UI label | Extra required input |
| --- | --- | --- |
| `monthly-spending` | Monthly snapshot | None |
| `weekly-budget` | Weekly budget | `budget > 0` |
| `quarterly-tax` | Quarterly tax view | `taxRate` from `0` through `1` |
| `yearly-review` | Year in review | None |
| `category-dive` | Category deep dive | Non-empty `category` |
| `anomaly-detector` | Unusual spending | None |
| `savings-tracker` | Savings tracker | `budget > 0` |

Each option includes `description`, `iconKey`, and optional `requiresFields`. Conditional fields include `visibleWhen`; fields may also include `defaultValue`. Preserve these values in the domain model instead of hard-coding a second option catalog.

Example start inputs:

```json
{
  "analysisMode": "weekly-budget",
  "spreadsheetId": "sheet-id",
  "sourceRange": "'Receipts'!A:Z",
  "columnMappingJson": "{\"date\":\"Date\",\"amount\":\"Amount\",\"category\":\"Category\",\"merchant\":\"Merchant\"}",
  "asOfDate": "2026-08-31",
  "currencyCode": "USD",
  "budget": "250",
  "deliveryMode": "preview"
}
```

The workflow remains generic:

```text
Google Sheets read -> receipt.analyze -> report writer
    -> optional Sheets report -> optional Gmail -> final report
```

`receipt.analyze` validates the mode. Never derive mode from the preset key.

## Required Flutter Changes

1. Add a single receipt preset constant for `receipt-intelligence`. Keep legacy keys only for reading/migrating existing SQLite rows; do not display them or create new runs with them.
2. In `preset_run_router.dart`, route the canonical key to `ReceiptConfigureRunScreen`, `ReceiptExecutionScreen`, and `ReceiptResultScreen`. Do not let receipt runs fall through to LinkedIn screens.
3. Replace `ReceiptWorkflowMetadata` entries keyed by seven presets with mode metadata sourced from the backend `analysisMode.options`. Selected mode belongs in `RunConfigState.inputs['analysisMode']`.
4. Extend `PresetInputFieldType` and `InputSchemaMapper` to understand `selectCards`, `select`, `date`, and `email`. Add schema models for `options`, `defaultValue`, `visibleWhen`, `requiresFields`, and root `presentation`. Unknown future properties must remain forward-compatible.
5. Refactor `prepareReceiptRunConfig` to validate by selected mode, add `analysisMode` to request inputs, and remove inactive values (`budget`, `taxRate`, `category`) before submission.
6. Update `receipt_preset_privacy.dart`, scheduling checks, notification navigation, and run reconciliation to recognize the canonical key. Existing local schedules using a legacy key should either be migrated to `receipt-intelligence` with the equivalent `analysisMode`, or be shown as needing reconfiguration. Never silently run them with the default mode.
7. Refresh the preset catalog from the API after upgrade. The `_catalog` cache is replaced on refresh, so stale legacy cards disappear. Legacy detail cache rows may be deleted safely after local workflow migration.

## Configuration Experience

Use progressive disclosure in this order:

1. Analysis goal
2. Google Sheets source and column mapping
3. Mode-specific field
4. Report date and currency
5. Delivery
6. AI model and Run action

Render analysis goals as a single-column list of compact selectable cards on phones. Use the backend `iconKey` with the existing Lucide icon family; do not use emoji. Each card needs a title, short description, a visible radio/check state, and selected semantics so selection is not communicated by color alone. Keep touch targets at least 48 dp and support Dynamic Type.

Reveal mode-specific inputs directly below the selector. A 150-200 ms cross-fade is enough; honor reduced-motion settings. Default to the backend's `monthly-spending` value, but never overwrite an in-progress selection during rebuilds.

Delivery defaults to `preview`. Show `reportTabTitle` only for `sheets`/`both`, and `recipientEmail` only for `email`/`both`. Remove the current `includeCharts`, `includeTrends`, and `includeCategoryBreakdown` controls because the backend does not consume them.

## Exact Mobile Files

- `lib/core/enums/preset_input_field_type.dart`
- `lib/domain/entities/preset/input_schema.dart`
- `lib/domain/mappers/preset/input_schema_mapper.dart`
- `lib/core/workflow/receipt_preset_privacy.dart`
- `lib/ui/features/presets/preset_run_router.dart`
- `lib/ui/features/presets/implementations/receipt_workflows/receipt_workflow_metadata.dart`
- `lib/ui/features/presets/implementations/receipt_workflows/configure_run_screen.dart`
- `lib/ui/features/presets/implementations/receipt_workflows/execution_screen.dart`
- `lib/ui/features/presets/implementations/receipt_workflows/result_screen.dart`
- `lib/data/repositories/workflow/schedule_repository.dart`
- `lib/data/services/scheduling/scheduled_workflow_executor.dart`

## Tests and Acceptance Criteria

Add mapper tests for schema v2, widget tests for all seven mode selections and conditional fields, request-preparation tests for validation/field cleanup, router tests for all three receipt screens, and a cache/migration test for legacy keys.

The change is complete when the catalog shows one Receipt Intelligence card; all seven modes start the same backend preset with the correct `analysisMode`; only relevant controls appear; old keys never appear as new presets; and preview, Sheets, email, and both delivery paths retain their existing credential behavior.
