using ArzlyAI.Domain.Enums;
using System.Text.Json.Serialization;

namespace ArzlyAI.Application.Models.Authoring;

public sealed record PresetDraftAdminNote(
    string Title,
    string Description,
    [property: JsonConverter(typeof(JsonStringEnumConverter))] AdminNoteSeverity Severity,
    IReadOnlyList<string> Links);
