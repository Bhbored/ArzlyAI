using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using ArzlyAI.Application.DTOs.Admin.Auth;
using ArzlyAI.Application.Services.Admin;
using ArzlyAI.Infrastructure.Identity;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Security;

public sealed class AuthService(
    UserManager<ApplicationUser> userManager,
    SignInManager<ApplicationUser> signInManager,
    IJwtService jwtService,
    IConfiguration configuration) : IAuthService
{
    private const string AdminRole = "Admin";

    public async Task<AdminAuthenticationResponse> LoginAsync(
        AdminLoginRequest request,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("AuthService.Login");
        var user = await userManager.FindByEmailAsync(request.Email)
            ?? throw new UnauthorizedAccessException("Invalid administrator credentials.");
        var signIn = await signInManager.CheckPasswordSignInAsync(
            user, request.Password, lockoutOnFailure: false);
        if (!signIn.Succeeded)
            throw new UnauthorizedAccessException("Invalid administrator credentials.");
        if (!await userManager.IsInRoleAsync(user, AdminRole))
            throw new UnauthorizedAccessException("Invalid administrator credentials.");
        return await IssueAndPersistAsync(user, cancellationToken);
    }

    public async Task<AdminAuthenticationResponse> RefreshAsync(
        AdminRefreshRequest request,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("AuthService.Refresh");
        ClaimsPrincipal principal;
        try
        {
            principal = jwtService.GetPrincipalFromExpiredToken(request.AccessToken);
        }
        catch (SecurityTokenException exception)
        {
            throw new UnauthorizedAccessException("The access token is invalid.", exception);
        }

        var subject = principal.FindFirstValue(JwtRegisteredClaimNames.Sub) ??
                      principal.FindFirstValue(ClaimTypes.NameIdentifier);
        if (!Guid.TryParse(subject, out var adminId))
            throw new UnauthorizedAccessException("The access token is invalid.");
        var user = await userManager.FindByIdAsync(adminId.ToString())
            ?? throw new UnauthorizedAccessException("The administrator account is unavailable.");
        var now = DateTimeOffset.UtcNow;
        if (!await userManager.IsInRoleAsync(user, AdminRole) ||
            await userManager.IsLockedOutAsync(user) ||
            user.RefreshTokenExpiresAtUtc <= now ||
            !RefreshTokenMatches(user.RefreshTokenHash, request.RefreshToken))
            throw new UnauthorizedAccessException("The refresh token is invalid or expired.");
        return await IssueAndPersistAsync(user, cancellationToken);
    }

    public async Task LogoutAsync(Guid adminId, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("AuthService.Logout");
        var user = await RequiredAdminAsync(adminId);
        user.RefreshTokenHash = null;
        user.RefreshTokenExpiresAtUtc = null;
        await UpdateAsync(user);
    }

    public async Task ChangePasswordAsync(
        Guid adminId,
        ChangeAdminPasswordRequest request,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("AuthService.ChangePassword");
        var user = await RequiredAdminAsync(adminId);
        var result = await userManager.ChangePasswordAsync(user, request.CurrentPassword, request.NewPassword);
        if (!result.Succeeded)
            throw new ArgumentException(string.Join(" | ", result.Errors.Select(x => x.Description)));
        user.RefreshTokenHash = null;
        user.RefreshTokenExpiresAtUtc = null;
        await UpdateAsync(user);
    }

    private async Task<AdminAuthenticationResponse> IssueAndPersistAsync(
        ApplicationUser user,
        CancellationToken cancellationToken)
    {
        var refreshToken = jwtService.GenerateRefreshToken();
        var refreshExpiresAtUtc = DateTimeOffset.UtcNow
            .AddDays(Math.Max(1, configuration.GetValue("RefreshToken:ExpirationDays", 30)));
        user.RefreshTokenHash = JwtService.HashRefreshToken(refreshToken);
        user.RefreshTokenExpiresAtUtc = refreshExpiresAtUtc;
        await UpdateAsync(user);
        var role = (await userManager.GetRolesAsync(user)).FirstOrDefault(
            candidate => string.Equals(candidate, AdminRole, StringComparison.OrdinalIgnoreCase))
            ?? throw new UnauthorizedAccessException("The administrator account is unavailable.");
        var access = jwtService.CreateAccessToken(user, role);
        return new AdminAuthenticationResponse(
            user.Id,
            user.Email ?? string.Empty,
            user.DisplayName,
            access.AccessToken,
            access.ExpiresAtUtc,
            refreshToken,
            refreshExpiresAtUtc);
    }

    private async Task<ApplicationUser> RequiredAdminAsync(Guid adminId)
    {
        var user = await userManager.FindByIdAsync(adminId.ToString())
            ?? throw new UnauthorizedAccessException("The administrator account is unavailable.");
        if (!await userManager.IsInRoleAsync(user, AdminRole))
            throw new UnauthorizedAccessException("The administrator account is unavailable.");
        return user;
    }

    private async Task UpdateAsync(ApplicationUser user)
    {
        var result = await userManager.UpdateAsync(user);
        if (!result.Succeeded)
            throw new InvalidOperationException(string.Join(" | ", result.Errors.Select(x => x.Description)));
    }

    private static bool RefreshTokenMatches(string? storedHash, string refreshToken)
    {
        if (string.IsNullOrWhiteSpace(storedHash)) return false;
        try
        {
            return CryptographicOperations.FixedTimeEquals(
                Convert.FromHexString(storedHash),
                Convert.FromHexString(JwtService.HashRefreshToken(refreshToken)));
        }
        catch (FormatException)
        {
            return false;
        }
    }
}
