using System.Security.Claims;
using ArzlyAI.Infrastructure.Identity;

namespace ArzlyAI.Infrastructure.Security;

public interface IJwtService
{
    (string AccessToken, DateTimeOffset ExpiresAtUtc) CreateAccessToken(
        ApplicationUser user, string role);

    ClaimsPrincipal GetPrincipalFromExpiredToken(string accessToken);

    string GenerateRefreshToken();
}
