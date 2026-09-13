using ArzlyAI.Application.DTOs.Admin.Auth;

namespace ArzlyAI.Application.Services.Admin;

public interface IAuthService
{
    Task<AdminAuthenticationResponse> LoginAsync(AdminLoginRequest request, CancellationToken cancellationToken);
    Task<AdminAuthenticationResponse> RefreshAsync(AdminRefreshRequest request, CancellationToken cancellationToken);
    Task LogoutAsync(Guid adminId, CancellationToken cancellationToken);
    Task ChangePasswordAsync(Guid adminId, ChangeAdminPasswordRequest request, CancellationToken cancellationToken);
}
