using ArzlyAI.Application.Models.Authoring;

namespace ArzlyAI.Application.Services.Authoring;

public sealed class PresetValidationException(PresetValidationResult validation)
    : Exception("The preset draft is not publishable.")
{
    public PresetValidationResult Validation { get; } = validation;
}
