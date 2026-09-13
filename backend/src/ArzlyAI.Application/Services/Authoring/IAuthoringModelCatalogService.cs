using ArzlyAI.Application.DTOs.Admin.Authoring;
using ArzlyAI.Application.Models.Authoring;

namespace ArzlyAI.Application.Services.Authoring;

public interface IAuthoringModelCatalogService
{
    Task<IReadOnlyList<AuthoringModelResponse>> ListAsync(CancellationToken cancellationToken);
    Task<AuthoringModelSelection> ResolveAsync(string provider, string model, CancellationToken cancellationToken);
    AuthoringModelSelection GetDefaultSelection();
}
