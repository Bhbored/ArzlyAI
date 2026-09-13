using Microsoft.AspNetCore.Identity;

namespace ArzlyAI.Infrastructure.Identity;

public sealed class ApplicationUser : IdentityUser<Guid>
{
    public required string DisplayName { get; set; }
    public string? RefreshTokenHash { get; set; }
    public DateTimeOffset? RefreshTokenExpiresAtUtc { get; set; }
}
