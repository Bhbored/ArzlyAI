using ArzlyAI.Application.DTOs.Admin.Authoring;
using ArzlyAI.Application.DTOs.Admin.Presets;

namespace ArzlyAI.Application.Services.Authoring;

public interface IAdminPresetCatalogService
{
    Task<IReadOnlyList<AdminPresetSummaryResponse>> ListAsync(CancellationToken cancellationToken);
    Task<AdminPresetDetailsResponse?> GetAsync(string key, int version, CancellationToken cancellationToken);
    Task<AuthoringSessionResponse> CloneToDraftAsync(string key, int version, Guid adminId, CancellationToken cancellationToken);
    Task ArchiveAsync(string key, int version, CancellationToken cancellationToken);
}
