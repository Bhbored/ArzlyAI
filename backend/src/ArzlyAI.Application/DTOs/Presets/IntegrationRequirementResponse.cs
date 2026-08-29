namespace ArzlyAI.Application.DTOs.Presets;
public sealed record IntegrationRequirementResponse(
    string Key, string Name, string Description, string CredentialSchemaJson);
