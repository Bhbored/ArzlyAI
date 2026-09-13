namespace ArzlyAI.Infrastructure.Security;

public sealed class AdminSeedOptions
{
    public const string SectionName = "AdminSeed";
    public Guid Id { get; set; } = Guid.Parse("00000000-0000-0000-0000-00000000000A");
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public string DisplayName { get; set; } = "Administrator";
}
