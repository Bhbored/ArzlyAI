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

- PostgreSQL capability catalog for registered connectors, integrations, deterministic operations, providers, and models.
- Protected AI-assisted preset authoring with persistent chats, structured drafts, validation, admin notes, and SignalR progress.
- Explicit publication of immutable preset versions. Publishing a new version archives the prior active version atomically.
- One ASP.NET Core Identity administrator using JWT access tokens and rotating JSON refresh tokens.
- Short-lived replay-protected credential envelopes; plaintext credentials are never persisted by the backend.
- SignalR node-status events, rate limits, health probes, and structured logging.
- Generic, deterministic sequential DAG execution driven by each preset's nodes, connections, and input mappings.
- Flutter Android/iOS client and a React TypeScript admin shell, built independently from the backend.

Flutter SQLite remains the source of truth for user workflow instances, history, schedules, and generated content. Provider credentials belong in platform secure storage. Backend PostgreSQL stores the public/capability catalog and admin authoring state, never end-user workflow data or provider credentials.

## Documentation

- [Preset authoring backend](docs/admin/preset-authoring-backend.md)
- [React admin API contract](docs/admin/react-admin-contract.md)
- [Preset catalog migration](docs/architecture/preset-catalog-migration.md)
- [Legacy preset designs](docs/presets/README.md)
- [Native Google authorization (Flutter)](docs/connectors/google-oauth.md)
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

Configure each server-owned authoring provider key with user secrets. The single administrator is seeded from the `Jwt`, `RefreshToken`, and `AdminSeed` sections in `appsettings.json`.

```powershell
dotnet user-secrets set "AdminAuthoring:Providers:openai:ApiKey" "<server-openai-key>" --project backend/src/ArzlyAI.Api
dotnet user-secrets set "AdminAuthoring:Providers:openai:Enabled" "true" --project backend/src/ArzlyAI.Api
```

Repeat the same two settings for `anthropic`, `gemini`, or `deepseek` when needed. Set `AdminSeed:Email` and `AdminSeed:Password` before first startup. Identity hashes that password and creates the fixed configured admin identity once; later startups never reset it. The authoring provider keys are server-owned and separate from users' workflow credentials.

Operational endpoints:

| Method | Path | Purpose |
| --- | --- | --- |
| `GET` | `/health/live` | Process liveness; no dependency query |
| `GET` | `/health/ready` | Readiness including PostgreSQL connectivity |
| `GET` | `/api/v1/presets` | Published preset catalog |
| `GET` | `/api/v1/presets/{key}` | Complete preset graph |
| `GET` | `/api/v1/providers` | Supported AI provider catalog |
| `POST` | `/api/v1/providers/{provider}/models` | List usable account models and UI capabilities using an encrypted `{provider}.apiKey` |
| `POST` | `/api/v1/connectors/google-sheets/resources/spreadsheets/query` | List spreadsheets using encrypted `google.accessToken` |
| `POST` | `/api/v1/connectors/google-sheets/resources/spreadsheets/{spreadsheetId}/tabs/query` | List sheet tabs for a spreadsheet |
| `POST` | `/api/v1/connectors/google-sheets/resources/spreadsheets/{spreadsheetId}/tabs/{tabTitle}/headers/query` | Read header row for a tab |
| `POST` | `/api/v1/workflows/runs` | Start a preset run |
| `GET` | `/api/v1/workflows/runs/{runId}` | Retrieve an ephemeral run |
| `POST` | `/api/v1/workflows/runs/{runId}/approval` | Accept, edit, or reject output |
| `POST` | `/api/v1/admin/auth/login` | Identity admin login; returns access and refresh tokens in JSON |
| `POST` | `/api/v1/admin/auth/refresh` | Rotates access and refresh tokens from the current token pair |
| `POST` | `/api/v1/admin/auth/logout` | Revokes the current refresh token |
| `GET` | `/api/v1/admin/authoring/capabilities` | Registered building blocks available to the authoring agent |
| `POST` | `/api/v1/admin/authoring/sessions` | Create a persistent authoring session |
| `POST` | `/api/v1/admin/authoring/sessions/{id}/messages` | Refine the structured draft through the authoring agent |
| `POST` | `/api/v1/admin/authoring/sessions/{id}/validate` | Validate the current revision |
| `POST` | `/api/v1/admin/authoring/sessions/{id}/publish` | Explicitly publish a validated immutable version |

### EF Core Package Manager Console

Set `ArzlyAI.Api` as the startup project and `ArzlyAI.Infrastructure` as the Package Manager Console default project.

```powershell
Add-Migration YourMigrationName -Context ArzlyDbContext -OutputDir Persistence/Migrations
Update-Database -Context ArzlyDbContext
```

The `AdminAuthoredPresetCatalog` migration removes the former seeded preset keys and introduces authoring, connector, and immutable-version tables. `ReplaceCustomAdminAuthWithIdentity` replaces its temporary custom admin tables with ASP.NET Core Identity tables. A new database normally needs only `Update-Database`.

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

Implement the client against [the Flutter plan](docs/presets/flutter-linkedin-client-plan.md). Google account authorization is native via `google_sign_in`; configure Android/iOS OAuth clients as described in [Native Google authorization](docs/connectors/google-oauth.md). The project includes its public Web client ID and supports overriding it with `--dart-define=GOOGLE_SERVER_CLIENT_ID=...`. Keep secrets out of SQLite, logs, analytics, and URLs.

## Admin Development

```powershell
cd admin/arzlyai_admin
npm install
npm run dev
npm run build
```

The React project is currently a shell. Implement it against the protected contract in [React admin API contract](docs/admin/react-admin-contract.md); do not duplicate backend draft validation or allow chat turns to publish implicitly.

## Security Boundary

There is no end-user registration or backend user database. Admin authentication protects only catalog authoring. Workflow credentials are encrypted client-side using the ephemeral public-key descriptor, decrypted briefly in server memory, and discarded after the provider call. Provider API keys use envelope fields `{provider}.apiKey` (`openai`, `anthropic`, `gemini`, `deepseek`). Never commit or log credentials, access tokens, author URNs, user content, JWT signing keys, bootstrap passwords, or the authoring API key.

## Stage 1 Limitations

- Workflow graphs are validated and executed sequentially in topological order; parallel branches and conditional routing are not implemented yet.
- Runs are memory-backed and expire after 30 minutes.
- Mobile operating systems do not guarantee exact background network execution.
- LinkedIn OAuth acquisition and refresh are not implemented.
- No presets are published by default. An administrator must author, validate, and explicitly publish the first version.
