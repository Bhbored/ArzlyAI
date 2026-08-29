using ArzlyAI.Application.Security;

namespace ArzlyAI.Application.DTOs.Models;

public sealed record ListOpenAiModelsRequest(CredentialEnvelope Credentials);
