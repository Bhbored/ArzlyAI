# Preset Documentation

Presets are no longer inserted by startup seed files. The public catalog starts empty and receives presets only through validated, explicitly published admin authoring sessions.

The documents in this folder describe legacy product designs that can be recreated through the authoring API. They are reference material, not evidence that a preset currently exists in PostgreSQL:

- `daily-linkedin-ai-post`: `linkedin-preset.md`
- `smart-purchase-decision`: `smart-purchase-decision.md`
- `brain-dump-to-action`: `brain-dump-to-action.md`

The former `receipt-intelligence` preset and its seven seeded variants were also removed by the catalog migration. A new configurable receipt preset may be authored as a single immutable version when needed.

For the current creation flow, see [Preset authoring backend](../admin/preset-authoring-backend.md).
