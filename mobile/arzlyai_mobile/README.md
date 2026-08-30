# ArzlyAI Mobile

Flutter Android/iOS client for the local-first ArzlyAI workflow platform.

```powershell
fvm flutter pub get
fvm flutter analyze
fvm flutter test
fvm flutter run
```

Use FVM (`.fvmrc` → Flutter 3.41.7). Do not run bare `flutter` commands.

## Documentation

| Topic | Location |
| --- | --- |
| Add a preset run journey | [`doc/add_preset_flow.md`](doc/add_preset_flow.md) |
| SQLite schema and scheduling | [`doc/sqlite_schema.md`](doc/sqlite_schema.md) |
| Receipt presets (backend contract) | [`../../docs/presets/receipt-automation.md`](../../docs/presets/receipt-automation.md) |
| Google connector (Nango) | [`../../docs/connectors/nango-google.md`](../../docs/connectors/nango-google.md) |
| LinkedIn client plan | [`../../docs/presets/flutter-linkedin-client-plan.md`](../../docs/presets/flutter-linkedin-client-plan.md) |

## Local data boundaries

- **SQLite (`arzlyai.sqlite`)**: preset cache, workflow instances, schedules, non-sensitive run metadata, connector sync fields.
- **Secure storage**: provider API keys and OAuth access tokens (`google.accessToken`, `linkedin.accessToken`, etc.).
- **Receipt privacy**: receipt row values and generated finance reports are **not** persisted to SQLite for `receipt-*` presets. They exist only in memory during an active run.

After pulling schema changes, check `schemaVersion` in `lib/infrastructor/db/database.dart`. During development there is no `onUpgrade` — uninstall the app or clear app data when the version bumps (currently **5**). Run codegen when needed: `fvm dart run build_runner build --delete-conflicting-outputs`.
