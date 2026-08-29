using ArzlyAI.Application.DTOs.Models;

namespace ArzlyAI.Application.Services.Models;

public interface IOpenAiModelCatalogService
{
    Task<IReadOnlyList<OpenAiModelResponse>> ListAsync(
        ListOpenAiModelsRequest request,
        CancellationToken cancellationToken);
}
