using ArzlyAI.Infrastructure.Identity;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Security;

public sealed class AdminIdentitySeeder(
    UserManager<ApplicationUser> userManager,
    RoleManager<ApplicationRole> roleManager,
    IOptions<AdminSeedOptions> options,
    ILogger<AdminIdentitySeeder> logger)
{
    private const string AdminRole = "Admin";

    public async Task InitializeAsync(CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("AdminIdentitySeeder.Initialize");
        var settings = options.Value;
        if (AllBlank(settings))
        {
            logger.LogWarning("AdminSeed is not configured; no administrator was created");
            return;
        }
        if (string.IsNullOrWhiteSpace(settings.Email) || string.IsNullOrWhiteSpace(settings.Password) ||
            string.IsNullOrWhiteSpace(settings.DisplayName) || settings.Id == Guid.Empty)
            throw new InvalidOperationException("AdminSeed must configure Id, Email, Password, and DisplayName together.");

        if (!await roleManager.RoleExistsAsync(AdminRole))
            Ensure(await roleManager.CreateAsync(new ApplicationRole { Id = Guid.NewGuid(), Name = AdminRole }));

        var existing = await userManager.FindByIdAsync(settings.Id.ToString());
        if (existing is not null)
        {
            if (!string.Equals(existing.Email, settings.Email, StringComparison.OrdinalIgnoreCase))
                throw new InvalidOperationException("The configured AdminSeed email conflicts with the existing administrator identity.");
            if (!await userManager.IsInRoleAsync(existing, AdminRole))
                Ensure(await userManager.AddToRoleAsync(existing, AdminRole));
            return;
        }

        if (await userManager.FindByEmailAsync(settings.Email) is not null)
            throw new InvalidOperationException("The configured AdminSeed email is already assigned to another identity.");
        var user = new ApplicationUser
        {
            Id = settings.Id,
            UserName = settings.Email,
            Email = settings.Email,
            EmailConfirmed = true,
            LockoutEnabled = true,
            DisplayName = settings.DisplayName
        };
        Ensure(await userManager.CreateAsync(user, settings.Password));
        Ensure(await userManager.AddToRoleAsync(user, AdminRole));
        logger.LogInformation("Seeded administrator identity {AdminId}", user.Id);
    }

    private static bool AllBlank(AdminSeedOptions options) =>
        string.IsNullOrWhiteSpace(options.Email) && string.IsNullOrWhiteSpace(options.Password);

    private static void Ensure(IdentityResult result)
    {
        if (!result.Succeeded)
            throw new InvalidOperationException(string.Join(" | ", result.Errors.Select(x => x.Description)));
    }
}
