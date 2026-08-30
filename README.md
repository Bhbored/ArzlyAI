# ArzlyAI

ArzlyAI is an open-source, local-first AI workflow platform. Users select preset agent workflows, provide their own provider credentials, review generated output, and invoke integrations without creating an ArzlyAI account.

This monorepo keeps the ASP.NET Core coordinator, Flutter mobile client, React administration client, tests, and preset documentation versioned together.

## Repository Layout

```text
backend/
  ArzlyAI.slnx
  src/
    ArzlyAI.Domain/
    ArzlyAI.Application/
    ArzlyAI.Infrastructure/
    ArzlyAI.Api/
  tests/
    ArzlyAI.Tests/
mobile/
  arzlyai_mobile/          # Flutter Android/iOS client
admin/
  arzlyai_admin/           # React + TypeScript preset admin
docs/
  presets/
```

The backend follows Clean Architecture: Domain is independent, Application depends on Domain, Infrastructure implements Application contracts, and API is the composition root. Flutter and React communicate only through versioned HTTP and SignalR contracts; neither imports backend source code.

## Current Scope

- Backend preset catalog in PostgreSQL with idempotent seeding.
- `daily-linkedin-ai-post` preset with generation, human review/edit, and LinkedIn publishing.
- `smart-purchase-decision` preset with plain-language confirmation, web search, and shopper-friendly recommendations.
- Short-lived replay-protected credential envelopes; plaintext credentials are never persisted by the backend.
- SignalR node-status events, rate limits, health probes, and structured logging.
- Generic, deterministic sequential DAG execution driven by each preset's nodes, connections, and input mappings.
- Empty Flutter Android/iOS shell ready for the first vertical slice.
- Empty React TypeScript admin shell reserved for later preset administration.

Flutter SQLite will be the source of truth for user workflow instances, history, schedules, and generated content. Provider credentials belong in platform secure storage. Backend PostgreSQL stores only the public preset catalog.

## Documentation

- [LinkedIn preset](docs/presets/linkedin-preset.md)
- [Smart Buy preset](docs/presets/smart-purchase-decision.md)
- [Flutter Smart Buy Lab HTML report handoff](docs/presets/flutter-smart-purchase-html-report.md)
- [Flutter workflow timeout and realtime handoff](docs/presets/flutter-workflow-execution-timeout.md)
- [Flutter LinkedIn client plan](docs/presets/flutter-linkedin-client-plan.md)
- [Flutter client scheduling and notifications](docs/presets/flutter-client-scheduling-notifications.md)
- [Flutter online OpenAI model-catalog prompt](docs/presets/flutter-openai-model-catalog-prompt.md)
- [Flutter LinkedIn edit-regeneration prompt](docs/presets/flutter-linkedin-edit-regeneration-prompt.md)
- [Nango LinkedIn connector](docs/connectors/nango-linkedin.md)
- [Flutter Nango connector prompt](docs/connectors/flutter-nango-connector-prompt.md)
- [Contributor instructions](AGENTS.md)

## Backend Development

Requirements: .NET 10 SDK and PostgreSQL.

```powershell
dotnet restore backend/ArzlyAI.slnx
dotnet build backend/ArzlyAI.slnx --no-restore -m:1
dotnet test backend/tests/ArzlyAI.Tests/ArzlyAI.Tests.csproj --no-build --no-restore -m:1
dotnet run --project backend/src/ArzlyAI.Api/ArzlyAI.Api.csproj
```

Configure `ConnectionStrings:Catalog` using user secrets or environment variable `ConnectionStrings__Catalog`. The checked-in connection string is development-only.

Operational endpoints:

| Method | Path | Purpose |
| --- | --- | --- |
| `GET` | `/health/live` | Process liveness; no dependency query |
| `GET` | `/health/ready` | Readiness including PostgreSQL connectivity |
| `GET` | `/api/v1/presets` | Published preset catalog |
| `GET` | `/api/v1/presets/{key}` | Complete preset graph |
| `POST` | `/api/v1/providers/openai/models` | List usable account models and UI capabilities using an encrypted API key |
| `POST` | `/api/v1/connectors/{connectorKey}/session` | Start a device-scoped Nango connect session |
| `GET` | `/api/v1/connectors/{connectorKey}/status` | Read device connector status |
| `GET` | `/api/v1/connectors/{connectorKey}/credentials` | Fetch mapped connector credentials from Nango |
| `DELETE` | `/api/v1/connectors/{connectorKey}` | Disconnect the device connector |
| `POST` | `/api/v1/workflows/runs` | Start a preset run |
| `GET` | `/api/v1/workflows/runs/{runId}` | Retrieve an ephemeral run |
| `POST` | `/api/v1/workflows/runs/{runId}/approval` | Accept, edit, or reject output |

### EF Core Package Manager Console

Set `ArzlyAI.Api` as the startup project and `ArzlyAI.Infrastructure` as the Package Manager Console default project.

```powershell
Add-Migration YourMigrationName -Context ArzlyDbContext -OutputDir Persistence/Migrations
Update-Database -Context ArzlyDbContext
```

The initial PostgreSQL migration already exists; a new database normally needs only `Update-Database`.

### Docker

Use `backend/` as the Docker build context:

```powershell
docker build -f backend/src/ArzlyAI.Api/Dockerfile -t arzlyai-backend backend
```

## Flutter Development

```powershell
cd mobile/arzlyai_mobile
flutter pub get
flutter analyze
flutter test
flutter run
```

Implement the first client against [the Flutter plan](docs/presets/flutter-linkedin-client-plan.md). Keep secrets out of SQLite, logs, analytics, and URLs.

## Admin Development

```powershell
cd admin/arzlyai_admin
npm install
npm run dev
npm run build
```

The admin is intentionally a placeholder. Do not implement preset editing until the generic workflow contract and versioning rules are stable.

## Security Boundary

There is no registration or backend user database. Credentials are encrypted client-side using the ephemeral public-key descriptor, decrypted briefly in server memory, and discarded after the provider call. Never commit real keys or production connection strings, and never log credential payloads, access tokens, API keys, author URNs, or user content.

## Stage 1 Limitations

- Workflow graphs are validated and executed sequentially in topological order; parallel branches and conditional routing are not implemented yet.
- Runs are memory-backed and expire after 30 minutes.
- Device-owned scheduling and local notifications still need the Flutter implementation described above.
- Mobile operating systems do not guarantee exact background network execution.
- LinkedIn OAuth acquisition and refresh are not implemented.
