using ArzlyAI.Application.Models.Authoring;

namespace ArzlyAI.Application.Services.Authoring;

public interface IPresetDraftValidator
{
    Task<PresetValidationResult> ValidateAsync(PresetDraftDocument draft, CancellationToken cancellationToken);
}
