namespace ArzlyAI.Application.Models.Authoring;

public sealed record PresetValidationResult(IReadOnlyList<PresetValidationIssue> Errors)
{
    public bool IsValid => Errors.Count == 0;
}
