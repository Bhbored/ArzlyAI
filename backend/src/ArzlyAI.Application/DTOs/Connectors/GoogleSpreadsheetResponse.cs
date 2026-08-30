namespace ArzlyAI.Application.DTOs.Connectors;

public sealed record GoogleSpreadsheetResponse(
    string Id,
    string Name,
    DateTimeOffset? ModifiedAtUtc);
