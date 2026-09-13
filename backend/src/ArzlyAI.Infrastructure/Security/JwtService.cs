using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using ArzlyAI.Infrastructure.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace ArzlyAI.Infrastructure.Security;

public sealed class JwtService(IConfiguration configuration) : IJwtService
{
    public (string AccessToken, DateTimeOffset ExpiresAtUtc) CreateAccessToken(
        ApplicationUser user, string role)
    {
        var now = DateTimeOffset.UtcNow;
        var expiresAtUtc = now.AddMinutes(ExpirationMinutes());
        var token = new JwtSecurityToken(
            RequiredConfiguration("Jwt:Issuer"),
            RequiredConfiguration("Jwt:Audience"),
            [
                new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(JwtRegisteredClaimNames.Email, user.Email ?? string.Empty),
                new Claim(ClaimTypes.Email, user.Email ?? string.Empty),
                new Claim("display_name", user.DisplayName),
                new Claim(ClaimTypes.Role, role),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString("N")),
                new Claim(JwtRegisteredClaimNames.Iat, now.ToUnixTimeSeconds().ToString(), ClaimValueTypes.Integer64)
            ],
            now.UtcDateTime,
            expiresAtUtc.UtcDateTime,
            new SigningCredentials(SigningKey(), SecurityAlgorithms.HmacSha256));
        return (new JwtSecurityTokenHandler().WriteToken(token), expiresAtUtc);
    }

    public ClaimsPrincipal GetPrincipalFromExpiredToken(string accessToken)
    {
        var principal = new JwtSecurityTokenHandler().ValidateToken(accessToken, new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = RequiredConfiguration("Jwt:Issuer"),
            ValidateAudience = true,
            ValidAudience = RequiredConfiguration("Jwt:Audience"),
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = SigningKey(),
            ValidateLifetime = false
        }, out var securityToken);
        if (securityToken is not JwtSecurityToken jwtSecurityToken ||
            !jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256,
                StringComparison.OrdinalIgnoreCase))
            throw new SecurityTokenException("The access token is invalid.");
        return principal;
    }

    public string GenerateRefreshToken() => Convert.ToBase64String(RandomNumberGenerator.GetBytes(64))
        .Replace('+', '-').Replace('/', '_').TrimEnd('=');

    public static string HashRefreshToken(string refreshToken) =>
        Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(refreshToken)));

    private SymmetricSecurityKey SigningKey()
    {
        var key = RequiredConfiguration("Jwt:Key");
        if (Encoding.UTF8.GetByteCount(key) < 32)
            throw new InvalidOperationException("Jwt:Key must contain at least 32 UTF-8 bytes.");
        return new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key));
    }

    private int ExpirationMinutes() => Math.Max(1, configuration.GetValue("Jwt:ExpirationMinutes", 60));

    private string RequiredConfiguration(string key) =>
        configuration[key] ?? throw new InvalidOperationException($"{key} must be configured.");
}
