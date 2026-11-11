using System.Net.Http.Headers;
using System.Net.Http.Json;
using ArzlyAI.Application.DTOs.Admin.Auth;
using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Infrastructure.Agents.Authoring;
using ArzlyAI.Infrastructure.Persistence;
using ArzlyAI.Infrastructure.Persistence.Interceptors;
using ArzlyAI.Infrastructure.Security;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.Extensions.Options;

namespace ArzlyAI.Tests;

public sealed class AdminAuthenticationIntegrationTests
{
    [Fact]
    public async Task ReplyAsync_WhenHttpProviderResolvedThroughInterface_UsesTypedClientBaseAddress()
    {
        await using var factory = new AdminApiFactory();
        await using var scope = factory.Services.CreateAsyncScope();
        var agents = scope.ServiceProvider
            .GetServices<IPresetAuthoringProviderAgent>()
            .Where(agent => agent is AnthropicPresetAuthoringAgent or
                            GeminiPresetAuthoringAgent or
                            DeepSeekPresetAuthoringAgent)
            .ToList();
        Assert.Equal(3, agents.Count);

        using var cancellation = new CancellationTokenSource();
        await cancellation.CancelAsync();
        foreach (var agent in agents)
        {
            var exception = await Record.ExceptionAsync(() => agent.ReplyAsync(
                Guid.NewGuid(),
                [],
                "Test message",
                new AuthoringModelSelection(agent.ProviderKey, "test-model"),
                "test-api-key",
                30,
                cancellation.Token));

            Assert.IsAssignableFrom<OperationCanceledException>(exception);
        }
    }

    [Fact]
    public async Task AdminEndpoints_WhenUsingTokenReturnedByLogin_ReturnSuccess()
    {
        await using var factory = new AdminApiFactory();
        using var client = factory.CreateClient(new WebApplicationFactoryClientOptions
        {
            BaseAddress = new Uri("https://localhost")
        });
        await SeedAdminAsync(factory.Services);
        var authenticationOptions = factory.Services
            .GetRequiredService<IOptions<AuthenticationOptions>>().Value;
        Assert.Equal(
            JwtBearerDefaults.AuthenticationScheme,
            authenticationOptions.DefaultAuthenticateScheme);
        Assert.Equal(
            JwtBearerDefaults.AuthenticationScheme,
            authenticationOptions.DefaultChallengeScheme);
        Assert.Equal(
            JwtBearerDefaults.AuthenticationScheme,
            authenticationOptions.DefaultForbidScheme);

        var loginResponse = await client.PostAsJsonAsync(
            "/api/v1/admin/auth/login",
            new AdminLoginRequest("admin@arzlyai.test", "Test-password-123!"));
        loginResponse.EnsureSuccessStatusCode();
        var authentication = await loginResponse.Content
            .ReadFromJsonAsync<AdminAuthenticationResponse>();
        Assert.NotNull(authentication);

        client.DefaultRequestHeaders.Authorization =
            new AuthenticationHeaderValue("Bearer", authentication.AccessToken);

        foreach (var path in new[]
                 {
                     "/api/v1/admin/authoring/capabilities",
                     "/api/v1/admin/authoring/assistant-providers",
                     "/api/v1/admin/authoring/sessions",
                     "/api/v1/admin/presets"
                 })
        {
            using var response = await client.GetAsync(path);
            response.EnsureSuccessStatusCode();
        }
    }

    private static async Task SeedAdminAsync(IServiceProvider services)
    {
        await using var scope = services.CreateAsyncScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<ArzlyDbContext>();
        await dbContext.Database.EnsureCreatedAsync();
        await scope.ServiceProvider.GetRequiredService<AdminIdentitySeeder>()
            .InitializeAsync(CancellationToken.None);
    }

    private sealed class AdminApiFactory : WebApplicationFactory<Program>
    {
        private readonly string databaseName = $"ArzlyAI-Auth-{Guid.NewGuid():N}";

        protected override void ConfigureWebHost(IWebHostBuilder builder)
        {
            builder.UseEnvironment("Test");
            builder.UseSetting("ConnectionStrings:Catalog", "Host=unused;Database=unused");
            builder.UseSetting("Jwt:Issuer", "ArzlyAI.Tests");
            builder.UseSetting("Jwt:Audience", "ArzlyAI.Tests.Admin");
            builder.UseSetting("Jwt:Key", "test-jwt-signing-key-must-contain-at-least-32-bytes");
            builder.UseSetting("Jwt:ExpirationMinutes", "15");
            builder.UseSetting("RefreshToken:ExpirationDays", "7");
            builder.UseSetting("AdminSeed:Id", "10000000-0000-0000-0000-000000000001");
            builder.UseSetting("AdminSeed:Email", "admin@arzlyai.test");
            builder.UseSetting("AdminSeed:Password", "Test-password-123!");
            builder.UseSetting("AdminSeed:DisplayName", "Test Administrator");

            builder.ConfigureServices(services =>
            {
                services.RemoveAll<DbContextOptions<ArzlyDbContext>>();
                services.RemoveAll<IDbContextOptionsConfiguration<ArzlyDbContext>>();
                services.RemoveAll<ArzlyDbContext>();
                services.AddDbContext<ArzlyDbContext>((serviceProvider, options) => options
                    .UseInMemoryDatabase(databaseName)
                    .AddInterceptors(serviceProvider.GetRequiredService<AuditTimestampInterceptor>()));
            });
        }
    }
}
