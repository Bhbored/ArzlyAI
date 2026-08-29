namespace ArzlyAI.Application.DTOs.Workflows;
public sealed record ApprovalSnapshotResponse(string OriginalContent, string CurrentContent, bool WasEdited);
