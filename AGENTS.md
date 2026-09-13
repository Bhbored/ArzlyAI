# Repository Guidelines

## Project Structure

This monorepo contains three independently built applications:

- `backend/src/`: .NET 10 Clean Architecture projects (`Domain`, `Application`, `Infrastructure`, and `Api`).
- `backend/tests/ArzlyAI.Tests/`: xUnit backend tests.
- `mobile/arzlyai_mobile/`: Flutter Android/iOS client and tests.
- `admin/arzlyai_admin/`: React TypeScript preset-admin client.
- `docs/presets/`: preset and client-contract documentation.

Backend dependencies point inward. Domain must not reference outer projects. The API is the composition root; register dependencies in `backend/src/ArzlyAI.Api/Helpers/DIContainer.cs`. Flutter and React must consume versioned API contracts and must not import backend source.

GUID-backed EF entities inherit `Entities/Common/Base.cs`. `AuditTimestampInterceptor` owns timestamps. There is no soft delete. Use `IGenericRepository<TEntity>` for ordinary EF CRUD and feature repositories for specialized queries. Keep memory-backed stores outside the EF abstraction.

## Commands

```powershell
dotnet restore backend/ArzlyAI.slnx
dotnet build backend/ArzlyAI.slnx --no-restore -m:1
dotnet test backend/tests/ArzlyAI.Tests/ArzlyAI.Tests.csproj --no-build --no-restore -m:1
dotnet run --project backend/src/ArzlyAI.Api/ArzlyAI.Api.csproj

cd mobile/arzlyai_mobile
flutter analyze
flutter test

cd admin/arzlyai_admin
npm run build
```

Build with zero warnings. Use `dotnet format`, `dart format`, and the frontend's configured linting tools for mechanical formatting.

## Coding and Testing

For C#, use four-space indentation, file-scoped namespaces, nullable references, `Async` suffixes, `PascalCase` public names, `camelCase` locals, and `I` interface prefixes. Keep one public type per file.

Name xUnit tests `Method_WhenCondition_ExpectedResult`. Test mappings, validation, state transitions, seed idempotency, and credential rules. Add Flutter unit/widget tests and React component tests with their features. Isolate all external APIs behind contracts and never use real secrets.

## Adding a Preset

A preset contains agents, Harness policies, workflow nodes/connections, integrations, client background guidance, and admin-only operational notes. Presets are authored through the protected admin API and published as immutable database versions; they are no longer source-code seeds. Keep execution generic and never hard-code a preset key into the runtime.

1. Add reusable connectors, integration handlers, or deterministic operations first. Register runtime handlers in `DIContainer.cs` and catalog metadata in `CapabilityCatalogSeed.cs`.
2. Verify capability metadata includes schemas, credentials, scopes, required APIs, risk, documentation, and background support.
3. Create an authoring session, refine its structured draft through chat, and validate it. Never let an AI tool publish directly.
4. Publish explicitly through `POST /api/v1/admin/authoring/sessions/{id}/publish` with the expected revision.
5. Reuse Domain graph entities; extend generic DTOs and mappers only for concepts shared by multiple presets.
6. Select runtime handlers by capability `Key`; keep preset-specific behavior out of `WorkflowExecutionService`.
7. Add catalog, schema, mapping, graph, transition, versioning, and contract tests plus `docs/presets/<preset-key>.md` when a preset becomes a maintained product example.

## Implemented Presets

| Preset | Workflow | Description |
| --- | --- | --- |
| None | Admin-authored | The legacy seeded presets were removed. Published rows now come only from validated admin authoring sessions. |

## Git and Security

Agents must **never commit, amend, push, create branches, or open pull requests**. Leave changes uncommitted and preserve unrelated work.

Never persist or log plaintext credentials. They are decrypted briefly from short-lived, replay-protected envelopes. Backend PostgreSQL stores only the public catalog. User workflow data belongs in Flutter SQLite; provider credentials belong in platform secure storage.
