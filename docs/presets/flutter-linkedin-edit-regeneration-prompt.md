# Flutter Agent Prompt: LinkedIn Edit Regeneration

Copy the prompt below into the Flutter implementation agent.

```text
Update the Flutter `daily-linkedin-ai-post` flow to match the backend's new ApprovalDecision.Edit behavior. Follow the repository's existing Clean Architecture, Riverpod, Dio, Freezed, secure-storage, SQLite, and preset-specific UI organization. Preserve unrelated work and do not change the backend.

Workflow and enum contract

- `ApprovalDecision.accept` serializes as 0.
- `ApprovalDecision.edit` serializes as 1.
- `ApprovalDecision.reject` serializes as 2.
- Do not rename, reorder, or convert these numeric values to strings.

Behavior

1. Accept and publish
   - Send decision 0 with no editedContent.
   - Create a fresh encrypted envelope containing only `linkedin.accessToken` and `linkedin.authorUrn`.
   - Backend continues through `linkedin-publisher` and `linkedin.posts`.

2. Request an edit
   - Send decision 1 and require non-empty editedContent. Treat this value as feedback/instructions, not approved publishable text.
   - Create a fresh encrypted envelope containing only `openai.apiKey`.
   - Do not send LinkedIn credentials.
   - Backend resets and reruns the upstream writer, then returns a run in `WaitingForApproval` with a new approval snapshot.
   - Do not navigate to the result/published screen. Return to or retain the workflow hub, reconcile the response, and show the new draft for another review cycle.
   - Support repeated edit requests.

3. Reject
   - Send decision 2 with editedContent and credentials null.
   - Backend returns `Cancelled`; publisher and integration remain idle.

Request contract

POST /api/v1/workflows/runs/{runId}/approval

Request-edit example:
{
  "decision": 1,
  "editedContent": "Use a stronger opening and make the post shorter.",
  "credentials": { existing encrypted CredentialEnvelope fields }
}

No DTO schema change is required. Continue parsing the existing WorkflowRunResponse, ApprovalSnapshotResponse, WorkflowNodeRunResponse, and SignalR WorkflowNodeChanged event.

UI requirements

- Rename edit actions and confirmation copy to “Request an edit”; remove wording that implies the edited field will be published immediately.
- Label the input as edit feedback/instructions. Explain that AI will generate a new draft.
- During submission, disable duplicate actions and show Review Content as busy using the existing local request state.
- Reconcile the returned snapshot before navigation.
- After Edit succeeds, expected states are:
  - writer: Completed with new output
  - approval: WaitingForApproval
  - publisher: Idle
  - integration: Idle
- Display `Approval.OriginalContent`/`CurrentContent` from the returned response as the new draft. Do not keep showing the previous draft from temporary state.
- SignalR is transient; merge events using the existing timestamp logic and reconcile with GET /api/v1/workflows/runs/{runId} after reconnect.
- Show actionable errors for missing OpenAI credentials, expired/replayed envelopes, regeneration failures, and offline mode. Preserve the current review draft/feedback when a request fails.

Implementation guidance

- Update the review screen under `lib/ui/features/presets/implementations/daily_linkedin_ai_post/`.
- Update `active_run_provider.submitApproval` so credential selection depends on the decision:
  - Accept -> CredentialPhase.approval integration keys.
  - Edit -> upstream agent provider key (`openai.apiKey`).
  - Reject -> no envelope and no encryption-key request.
- Reuse CredentialRepository and CredentialEnvelopeService. Never place plaintext credentials in DTOs, logs, SQLite, analytics, URLs, or error messages.
- Clear temporary edit feedback only after a successful regenerated response has been persisted/reconciled.
- Keep generic workflow networking in the existing shared service/repository; keep LinkedIn-specific labels and dialog copy in its preset implementation folder.
- Do not change preset keys, routes, SignalR method names, or approval enum ordering.

Tests

- Accept sends decision 0 plus LinkedIn envelope and navigates only after completion.
- Edit requires feedback, sends decision 1 plus OpenAI envelope, and sends no LinkedIn credentials.
- Edit response returns to WaitingForApproval and renders the new draft.
- Repeated Edit cycles work.
- Reject sends decision 2 with null credentials and renders Cancelled.
- Publisher/integration cards stay idle after Edit and Reject.
- Failed Edit preserves feedback and permits retry without duplicate submission.
- Numeric approval serialization remains 0/1/2.
- Verify plaintext credentials never enter SQLite or logs.

Run the repository's code generation command if annotated DTO/provider sources change, then run `dart format`, `flutter analyze`, and `flutter test`. Report exact files changed and any remaining backend dependency.
```

## Backend reference

The behavior is implemented in:

- `backend/src/ArzlyAI.Application/Services/Workflows/WorkflowExecutionService.cs`
- `backend/src/ArzlyAI.Application/Services/Workflows/Execution/WorkflowInputMapper.cs`
- `backend/src/ArzlyAI.Application/Models/WorkflowRun.cs`
- `backend/tests/ArzlyAI.Tests/WorkflowApprovalTransitionTests.cs`

The full preset contract is documented in [`linkedin-preset.md`](linkedin-preset.md).
