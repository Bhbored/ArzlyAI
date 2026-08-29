using ArzlyAI.Application.Security;
using ArzlyAI.Domain.Enums;
namespace ArzlyAI.Application.DTOs.Workflows;
public sealed record SubmitApprovalRequest(
    ApprovalDecision Decision,
    string? EditedContent,
    CredentialEnvelope? Credentials);
