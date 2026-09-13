using ArzlyAI.Application.DTOs.Admin.Auth;
using ArzlyAI.Infrastructure.Identity;
using ArzlyAI.Infrastructure.Persistence;
using ArzlyAI.Infrastructure.Security;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace ArzlyAI.Tests;

public sealed class IdentityAdminAuthTests
{
    [Fact]
    public async Task InitializeAsync_WhenCalledTwice_CreatesOneAdministratorInAdminRole()
    {
        await using var provider = CreateProvider();
        await using var scope = provider.CreateAsyncScope();
        var seeder = scope.ServiceProvider.GetRequiredService<AdminIdentitySeeder>();

        await seeder.InitializeAsync(CancellationToken.None);
        await seeder.InitializeAsync(CancellationToken.None);

        var users = scope.ServiceProvider.GetRequiredService<UserManager<ApplicationUser>>();
        var user = await users.FindByEmailAsync("admin@example.com");
        Assert.NotNull(user);
        Assert.True(await users.IsInRoleAsync(user, "Admin"));
        Assert.Equal(1, await scope.ServiceProvider.GetRequiredService<ArzlyDbContext>().Users.CountAsync());
    }

    [Fact]
    public async Task RefreshAsync_WhenRefreshTokenWasRotated_RejectsThePriorToken()
    {
        await using var provider = CreateProvider();
        await using var scope = provider.CreateAsyncScope();
        await scope.ServiceProvider.GetRequiredService<AdminIdentitySeeder>()
            .InitializeAsync(CancellationToken.None);
        var service = scope.ServiceProvider.GetRequiredService<AuthService>();

        var login = await service.LoginAsync(new AdminLoginRequest("admin@example.com", "Admin123!Pass"),
            CancellationToken.None);
        var refreshed = await service.RefreshAsync(
            new AdminRefreshRequest(login.AccessToken, login.RefreshToken), CancellationToken.None);

        Assert.NotEqual(login.AccessToken, refreshed.AccessToken);
        Assert.NotEqual(login.RefreshToken, refreshed.RefreshToken);
        await Assert.ThrowsAsync<UnauthorizedAccessException>(() => service.RefreshAsync(
            new AdminRefreshRequest(login.AccessToken, login.RefreshToken), CancellationToken.None));
    }

    [Fact]
    public async Task LoginAsync_WhenSeededAdministrator_ReturnsAdminBearerToken()
    {
        await using var provider = CreateProvider();
        await using var scope = provider.CreateAsyncScope();
        await scope.ServiceProvider.GetRequiredService<AdminIdentitySeeder>()
            .InitializeAsync(CancellationToken.None);
        var service = scope.ServiceProvider.GetRequiredService<AuthService>();

        var login = await service.LoginAsync(
            new AdminLoginRequest("admin@example.com", "Admin123!Pass"), CancellationToken.None);

        var token = new JwtSecurityTokenHandler().ReadJwtToken(login.AccessToken);
        Assert.Equal("admin@example.com", login.Email);
        Assert.Contains(token.Claims, claim =>
            claim.Type == ClaimTypes.Role && claim.Value == "Admin");
        Assert.Contains(token.Claims, claim =>
            claim.Type == ClaimTypes.NameIdentifier && claim.Value == login.AdminId.ToString());
    }

    private static ServiceProvider CreateProvider()
    {
        var services = new ServiceCollection();
        services.AddLogging();
        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string?>
            {
                ["Jwt:Issuer"] = "ArzlyAI.Tests",
                ["Jwt:Audience"] = "ArzlyAI.Tests.Admin",
                ["Jwt:Key"] = "test-jwt-signing-key-must-contain-32-bytes",
                ["Jwt:ExpirationMinutes"] = "60",
                ["RefreshToken:ExpirationDays"] = "30"
            })
            .Build();
        services.AddSingleton<IConfiguration>(configuration);
        services.AddDbContext<ArzlyDbContext>(options =>
            options.UseInMemoryDatabase(Guid.NewGuid().ToString()));
        services.AddIdentity<ApplicationUser, ApplicationRole>(options =>
            {
                options.Password.RequiredLength = 12;
                options.Password.RequireDigit = true;
                options.Password.RequireLowercase = true;
                options.Password.RequireNonAlphanumeric = true;
                options.Password.RequireUppercase = true;
                options.Lockout.AllowedForNewUsers = true;
                options.Lockout.MaxFailedAccessAttempts = 5;
                options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(15);
            })
            .AddEntityFrameworkStores<ArzlyDbContext>()
            .AddDefaultTokenProviders();
        services.Configure<AdminSeedOptions>(options =>
        {
            options.Id = Guid.Parse("00000000-0000-0000-0000-00000000000A");
            options.Email = "admin@example.com";
            options.Password = "Admin123!Pass";
            options.DisplayName = "Administrator";
        });
        services.AddSingleton<IJwtService, JwtService>();
        services.AddScoped<AdminIdentitySeeder>();
        services.AddScoped<AuthService>();
        return services.BuildServiceProvider();
    }
}
