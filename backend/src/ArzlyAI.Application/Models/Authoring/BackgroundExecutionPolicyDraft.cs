using ArzlyAI.Domain.Enums;
using System.Text.Json.Serialization;

namespace ArzlyAI.Application.Models.Authoring;

public sealed record BackgroundExecutionPolicyDraft(
    [property: JsonConverter(typeof(JsonStringEnumConverter))] BackgroundExecutionMode Mode,
    string Rationale,
    IReadOnlyList<string> AllowedTriggerTypes);
