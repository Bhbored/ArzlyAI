using ArzlyAI.Application.DTOs.Admin.Auth;
using ArzlyAI.Application.Services.Admin;
using ArzlyAI.Api.Extensions;
using Asp.Versioning;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SerilogTimings;

namespace ArzlyAI.Api.Controllers.Admin;

[ApiController]
[ApiVersion(1.0)]
[Route("api/v{version:apiVersion}/admin/auth")]
public sealed class AdminAuthController(IAuthService service) : ControllerBase
{
    [HttpPost("login")]
    [AllowAnonymous]
    public async Task<ActionResult<AdminAuthenticationResponse>> Login(
        AdminLoginRequest request, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("AdminAuthController.Login");
        return Ok(await service.LoginAsync(request, cancellationToken));
    }

    [HttpPost("refresh")]
    [AllowAnonymous]
    public async Task<ActionResult<AdminAuthenticationResponse>> Refresh(
        AdminRefreshRequest request,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("AdminAuthController.Refresh");
        return Ok(await service.RefreshAsync(request, cancellationToken));
    }

    [HttpPost("logout")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> Logout(CancellationToken cancellationToken)
    {
        await service.LogoutAsync(User.GetUserId(), cancellationToken);
        return NoContent();
    }

    [HttpPost("change-password")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> ChangePassword(
        ChangeAdminPasswordRequest request,
        CancellationToken cancellationToken)
    {
        await service.ChangePasswordAsync(User.GetUserId(), request, cancellationToken);
        return NoContent();
    }
}
