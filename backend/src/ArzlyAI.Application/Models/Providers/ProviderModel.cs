namespace ArzlyAI.Application.Models.Providers;

public sealed record ProviderModel(
    string Id,
    string OwnedBy,
    DateTimeOffset CreatedAtUtc);
