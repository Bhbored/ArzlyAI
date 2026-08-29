using ArzlyAI.Application.DTOs.Presets;
using ArzlyAI.Domain.Presets;

namespace ArzlyAI.Application.Mappers.Presets;

public interface IPresetMapper
{
    PresetSummaryResponse ToSummaryResponse(PresetDefinition preset);
    PresetDetailsResponse ToDetailsResponse(PresetDefinition preset);
}
