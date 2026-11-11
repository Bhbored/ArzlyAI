using ArzlyAI.Api.Helpers;
using ArzlyAI.Infrastructure.Identity;
using ArzlyAI.Infrastructure.Security;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace ArzlyAI.Tests;

public sealed class AdminJwtAuthenticationTests
{
    [Fact]
    public async Task AuthenticateAsync_WhenAdminBearerTokenIsValid_AuthenticatesWithJwtBearer()
    {
        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string?>
            {
                ["ConnectionStrings:Catalog"] =
                    "Host=localhost;Database=arzlyai-tests;Username=postgres;Password=postgres",
                ["Jwt:Issuer"] = "ArzlyAI.Tests",
                ["Jwt:Audience"] = "ArzlyAI.Tests.Admin",
                ["Jwt:Key"] = "test-jwt-signing-key-must-contain-32-bytes",
                ["Jwt:ExpirationMinutes"] = "60"
            })
            .Build();
        var services = new ServiceCollection();
        services.AddLogging();
        services.AddSingleton<IConfiguration>(configuration);
        services.RegisterDependencies(configuration);
        await using var provider = services.BuildServiceProvider();
        var authentication = provider.GetRequiredService<IOptions<AuthenticationOptions>>().Value;
        var jwtService = provider.GetRequiredService<IJwtService>();
        var user = new ApplicationUser
        {
            Id = Guid.NewGuid(),
            Email = "admin@example.com",
            DisplayName = "Administrator"
        };
        var accessToken = jwtService.CreateAccessToken(user, "Admin").AccessToken;
        var context = new DefaultHttpContext
        {
            RequestServices = provider
        };
        context.Request.Headers.Authorization = $"Bearer {accessToken}";

        var result = await context.AuthenticateAsync();

        Assert.Equal(JwtBearerDefaults.AuthenticationScheme, authentication.DefaultAuthenticateScheme);
        Assert.Equal(JwtBearerDefaults.AuthenticationScheme, authentication.DefaultChallengeScheme);
        Assert.True(result.Succeeded);
        Assert.True(result.Principal.IsInRole("Admin"));
    }
}
