using ArzlyAI.Application.Security;

namespace ArzlyAI.Application.DTOs.Connectors;

public sealed record GoogleResourceRequest(CredentialEnvelope Credentials);
