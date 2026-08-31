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

A preset contains agents, Harness policies, workflow nodes/connections, and integrations. Keep execution generic; never hard-code a preset key into the runtime.

1. Add an idempotent seed under `backend/src/ArzlyAI.Infrastructure/Persistence/Seeds/` and invoke it from `ArzlyDbContext.InitializeAsync()`.
2. Reuse Domain graph entities; add only concepts that apply to multiple presets.
3. Put contracts in Application and adapters under `Infrastructure/Integrations/<Provider>`; register them in `DIContainer.cs`.
4. Extend generic DTOs and mappers only when the client contract changes.
5. Select integration handlers by `Key`; keep preset behavior out of `WorkflowExecutionService`.
6. Add mapping, graph, settings, seed, transition, Flutter fixture, and contract tests.
7. Add `docs/presets/<preset-key>.md` with diagrams, inputs, credentials, lifecycle, exact backend/mobile files, and limitations; update README.

## Implemented Presets

| Preset | Workflow | Description |
| --- | --- | --- |
| `daily-linkedin-ai-post` | `generate-and-publish` | Writer -> review/edit -> passthrough publisher -> `linkedin.posts`. Publishes only approved text. |
| `smart-purchase-decision` | `confirm-and-recommend` | Brief -> confirmation -> web search -> recommendation -> review. |
| `brain-dump-to-action` | `compile-and-sync` | Planner -> review -> optional Google Tasks/Calendar/Gmail sync. |

## Git and Security

Agents must **never commit, amend, push, create branches, or open pull requests**. Leave changes uncommitted and preserve unrelated work.

Never persist or log plaintext credentials. They are decrypted briefly from short-lived, replay-protected envelopes. Backend PostgreSQL stores only the public catalog. User workflow data belongs in Flutter SQLite; provider credentials belong in platform secure storage.
