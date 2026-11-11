using System.Globalization;
using System.Threading.RateLimiting;
using ArzlyAI.Api.Configuration;
using ArzlyAI.Api.Hubs;
using ArzlyAI.Api.Realtime;
using ArzlyAI.Application.Abstractions;
using ArzlyAI.Application.Integrations;
using ArzlyAI.Application.Mappers.Presets;
using ArzlyAI.Application.Mappers.Workflows;
using ArzlyAI.Application.Repositories;
using ArzlyAI.Application.Repositories.Authoring;
using ArzlyAI.Application.Repositories.Presets;
using ArzlyAI.Application.Repositories.Workflows;
using ArzlyAI.Application.Security;
using ArzlyAI.Application.Services.Agents;
using ArzlyAI.Application.Services.Admin;
using ArzlyAI.Application.Services.Authoring;
using ArzlyAI.Application.Services.Connectors;
using ArzlyAI.Application.Services.Models;
using ArzlyAI.Application.Services.Presets;
using ArzlyAI.Application.Services.Realtime;
using ArzlyAI.Application.Services.Workflows;
using ArzlyAI.Application.Services.Workflows.Execution;
using ArzlyAI.Application.Services.Workflows.Operations;
using ArzlyAI.Application.Services.Workflows.Rendering;
using ArzlyAI.Infrastructure.Agents;
using ArzlyAI.Infrastructure.Agents.Authoring;
using ArzlyAI.Infrastructure.Health;
using ArzlyAI.Infrastructure.Integrations.Google;
using ArzlyAI.Infrastructure.Integrations.LinkedIn;
using ArzlyAI.Infrastructure.Identity;
using ArzlyAI.Infrastructure.Persistence;
using ArzlyAI.Infrastructure.Persistence.Interceptors;
using ArzlyAI.Infrastructure.Persistence.Repositories;
using ArzlyAI.Infrastructure.Persistence.Repositories.Authoring;
using ArzlyAI.Infrastructure.Persistence.Repositories.Presets;
using ArzlyAI.Infrastructure.Persistence.Repositories.Workflows;
using ArzlyAI.Infrastructure.Security;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using ArzlyAI.Infrastructure.Services.Models;
using Asp.Versioning;
using Microsoft.AspNetCore.HttpLogging;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;

namespace ArzlyAI.Api.Helpers;

public static class DIContainer
{
    public const string CorsPolicyName = "ArzlyAiClients";

    public static IServiceCollection RegisterDependencies(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        return services
            .RegisterApi()
            .RegisterApiVersioning()
            .RegisterIdentity(configuration)
            .RegisterJwtToken(configuration)
            .RegisterCors(configuration)
            .RegisterHttpLogging()
            .RegisterHealthAndRateLimiting(configuration)
            .RegisterSignalR(configuration)
            .RegisterPersistence(configuration)
            .RegisterRepositories()
            .RegisterApplicationServices()
            .RegisterInfrastructureServices()
            .RegisterIntegrations();
    }

    public static async Task InitializeDatabaseAsync(
        this WebApplication app,
        CancellationToken cancellationToken = default)
    {
        await using var scope = app.Services.CreateAsyncScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<ArzlyDbContext>();
        await dbContext.InitializeAsync(cancellationToken);
        await scope.ServiceProvider.GetRequiredService<CapabilityCatalogValidator>()
            .ValidateAsync(cancellationToken);
        await scope.ServiceProvider.GetRequiredService<AdminIdentitySeeder>()
            .InitializeAsync(cancellationToken);
    }

    private static IServiceCollection RegisterApi(this IServiceCollection services)
    {
        services.AddControllers();
        services.AddOpenApi();
        services.AddProblemDetails();
        return services;
    }

    private static IServiceCollection RegisterApiVersioning(this IServiceCollection services)
    {
        services.AddApiVersioning(options =>
            {
                options.DefaultApiVersion = new ApiVersion(1, 0);
                options.AssumeDefaultVersionWhenUnspecified = false;
                options.ReportApiVersions = true;
                options.ApiVersionReader = new UrlSegmentApiVersionReader();
            })
            .AddMvc()
            .AddApiExplorer(options =>
            {
                options.GroupNameFormat = "'v'VVV";
                options.SubstituteApiVersionInUrl = true;
            });
        return services;
    }

    private static IServiceCollection RegisterCors(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        services.AddCors(options => options.AddPolicy(CorsPolicyName, policy =>
        {
            var origins = configuration.GetSection("AllowedOrigins").Get<string[]>() ?? [];
            if (origins.Length > 0)
                policy.WithOrigins(origins).AllowCredentials();
            policy.AllowAnyHeader().AllowAnyMethod();
        }));
        return services;
    }

    private static IServiceCollection RegisterHttpLogging(this IServiceCollection services)
    {
        services.AddHttpLogging(options =>
        {
            options.LoggingFields = HttpLoggingFields.RequestPropertiesAndHeaders |
                                    HttpLoggingFields.ResponsePropertiesAndHeaders;
            options.CombineLogs = true;
        });
        return services;
    }

    private static IServiceCollection RegisterHealthAndRateLimiting(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        services.AddHealthChecks()
            .AddCheck<DatabaseHealthCheck>("database", tags: ["ready"]);

        services.AddRateLimiter(options =>
        {
            options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
            options.OnRejected = (context, _) =>
            {
                if (context.Lease.TryGetMetadata(MetadataName.RetryAfter, out var retryAfter))
                    context.HttpContext.Response.Headers.RetryAfter =
                        Math.Max(1, (int)Math.Ceiling(retryAfter.TotalSeconds))
                            .ToString(CultureInfo.InvariantCulture);
                return ValueTask.CompletedTask;
            };
            AddFixedWindowPolicy(options, configuration, ApiRateLimitPolicies.PresetReads,
                "PresetReads", 600, 60);
            AddFixedWindowPolicy(options, configuration, ApiRateLimitPolicies.Security,
                "Security", 120, 60);
            AddFixedWindowPolicy(options, configuration, ApiRateLimitPolicies.WorkflowExecution,
                "WorkflowExecution", 120, 60);
            AddFixedWindowPolicy(options, configuration, ApiRateLimitPolicies.SignalR,
                "SignalR", 600, 60);
            AddFixedWindowPolicy(options, configuration, ApiRateLimitPolicies.Connectors,
                "Connectors", 120, 60);
            AddFixedWindowPolicy(options, configuration, ApiRateLimitPolicies.AdminAuthoring,
                "AdminAuthoring", 60, 60);
        });
        return services;
    }

    private static IServiceCollection RegisterSignalR(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var permitLimit = Positive(configuration, "RateLimits:SignalR:PermitLimit", 600);
        var windowSeconds = Positive(configuration, "RateLimits:SignalR:WindowSeconds", 60);
        services.AddSingleton<PartitionedRateLimiter<string>>(_ =>
            PartitionedRateLimiter.Create<string, string>(partitionKey =>
                RateLimitPartition.GetFixedWindowLimiter(partitionKey, _ =>
                    new FixedWindowRateLimiterOptions
                    {
                        AutoReplenishment = true,
                        PermitLimit = permitLimit,
                        QueueLimit = 0,
                        Window = TimeSpan.FromSeconds(windowSeconds)
                    })));
        services.AddSignalR(options => options.AddFilter<WorkflowHubRateLimitFilter>());
        services.AddSingleton<IWorkflowRealtimeNotifier, SignalRWorkflowRealtimeNotifier>();
        services.AddSingleton<IAuthoringRealtimeNotifier, SignalRAuthoringRealtimeNotifier>();
        return services;
    }

    private static IServiceCollection RegisterPersistence(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var catalogConnection = configuration.GetConnectionString("Catalog")
            ?? throw new InvalidOperationException(
                "ConnectionStrings:Catalog is required for PostgreSQL.");

        services.AddSingleton<AuditTimestampInterceptor>();
        services.AddDbContext<ArzlyDbContext>((serviceProvider, options) => options
            .UseNpgsql(catalogConnection)
            .AddInterceptors(serviceProvider.GetRequiredService<AuditTimestampInterceptor>()));
        return services;
    }

    private static IServiceCollection RegisterRepositories(this IServiceCollection services)
    {
        services.AddScoped(typeof(IGenericRepository<>), typeof(GenericRepository<>));
        services.AddScoped<CapabilityCatalogValidator>();
        services.AddScoped<IPresetRepository, PresetRepository>();
        services.AddScoped<IPresetAuthoringRepository, PresetAuthoringRepository>();
        services.AddScoped<ICapabilityCatalogRepository, CapabilityCatalogRepository>();
        services.AddScoped<IPresetPublishingRepository, PresetPublishingRepository>();
        services.AddSingleton<IWorkflowRunRepository, InMemoryWorkflowRunRepository>();
        return services;
    }

    private static IServiceCollection RegisterApplicationServices(this IServiceCollection services)
    {
        services.AddSingleton<IModelCapabilityPolicy, ProviderModelCapabilityPolicy>();
        services.AddSingleton<IPresetMapper, PresetMapper>();
        services.AddSingleton<IWorkflowRunMapper, WorkflowRunMapper>();
        services.AddSingleton<IWorkflowGraphPlanner, WorkflowGraphPlanner>();
        services.AddSingleton<IWorkflowInputMapper, WorkflowInputMapper>();
        services.AddScoped<IPresetService, PresetService>();
        services.AddScoped<IPresetDraftValidator, PresetDraftValidator>();
        services.AddScoped<IPresetAuthoringToolbox, PresetAuthoringToolbox>();
        services.AddScoped<IAuthoringModelCatalogService, AuthoringModelCatalogService>();
        services.AddScoped<IPresetPublisher, PresetPublisher>();
        services.AddScoped<IPresetAuthoringService, PresetAuthoringService>();
        services.AddScoped<IAdminPresetCatalogService, AdminPresetCatalogService>();
        services.AddScoped<IProviderCatalogService, ProviderCatalogService>();
        services.AddScoped<IProviderModelCatalogService, ProviderModelCatalogService>();
        services.AddScoped<IWorkflowNodeHandler, AgentWorkflowNodeHandler>();
        services.AddScoped<IWorkflowNodeHandler, HumanApprovalWorkflowNodeHandler>();
        services.AddScoped<IWorkflowNodeHandler, IntegrationWorkflowNodeHandler>();
        services.AddScoped<IWorkflowNodeHandler, OperationWorkflowNodeHandler>();
        services.AddSingleton<IWorkflowOperation, WeightedDecisionScoringOperation>();
        services.AddSingleton<IWorkflowOperation, ReceiptAnalysisOperation>();
        services.AddSingleton<IWorkflowResultRenderer, ArzlyReportHtmlRenderer>();
        services.AddScoped<IWorkflowExecutionService, WorkflowExecutionService>();
        return services;
    }

    private static IServiceCollection RegisterInfrastructureServices(this IServiceCollection services)
    {
        services.AddSingleton(TimeProvider.System);
        services.AddSingleton<ICredentialEnvelopeProtector, EphemeralCredentialEnvelopeProtector>();
        services.AddScoped<IAuthService, AuthService>();
        services.AddSingleton<IJwtService, JwtService>();
        services.AddScoped<AdminIdentitySeeder>();
        services.AddScoped<PresetAuthoringToolExecutor>();
        services.AddScoped<IPresetAuthoringProviderAgent, OpenAiPresetAuthoringAgent>();
        services.AddScoped<IPresetAuthoringProviderAgent>(serviceProvider =>
            serviceProvider.GetRequiredService<AnthropicPresetAuthoringAgent>());
        services.AddScoped<IPresetAuthoringProviderAgent>(serviceProvider =>
            serviceProvider.GetRequiredService<GeminiPresetAuthoringAgent>());
        services.AddScoped<IPresetAuthoringProviderAgent>(serviceProvider =>
            serviceProvider.GetRequiredService<DeepSeekPresetAuthoringAgent>());
        services.AddScoped<IPresetAuthoringAgent, PresetAuthoringAgent>();
        services.AddSingleton<IAgentRuntime, OpenAiAgentRuntime>();
        services.AddSingleton<IAgentRuntimeResolver, AgentRuntimeResolver>();
        services.AddHttpClient<IProviderModelClient, OpenAiModelClient>(client =>
            client.BaseAddress = new Uri("https://api.openai.com/"));
        services.AddHttpClient<IProviderModelClient, AnthropicModelClient>(client =>
            client.BaseAddress = new Uri("https://api.anthropic.com/"));
        services.AddHttpClient<IProviderModelClient, GeminiModelClient>(client =>
            client.BaseAddress = new Uri("https://generativelanguage.googleapis.com/"));
        services.AddHttpClient<IProviderModelClient, DeepSeekModelClient>(client =>
            client.BaseAddress = new Uri("https://api.deepseek.com/"));
        services.AddHttpClient<AnthropicPresetAuthoringAgent>(client =>
            client.BaseAddress = new Uri("https://api.anthropic.com/"));
        services.AddHttpClient<GeminiPresetAuthoringAgent>(client =>
            client.BaseAddress = new Uri("https://generativelanguage.googleapis.com/"));
        services.AddHttpClient<DeepSeekPresetAuthoringAgent>(client =>
            client.BaseAddress = new Uri("https://api.deepseek.com/"));
        services.AddHttpClient<IAgentRuntime, AnthropicAgentRuntime>(client =>
            client.BaseAddress = new Uri("https://api.anthropic.com/"));
        services.AddHttpClient<IAgentRuntime, GeminiAgentRuntime>(client =>
            client.BaseAddress = new Uri("https://generativelanguage.googleapis.com/"));
        services.AddHttpClient<IAgentRuntime, DeepSeekAgentRuntime>(client =>
            client.BaseAddress = new Uri("https://api.deepseek.com/"));
        services.AddHttpClient<IGoogleSheetsClient, GoogleSheetsClient>();
        services.AddHttpClient<IGmailClient, GmailClient>();
        services.AddHttpClient<IGoogleTasksClient, GoogleTasksClient>();
        services.AddHttpClient<IGoogleCalendarClient, GoogleCalendarClient>();
        services.AddScoped<IGoogleResourceService, GoogleResourceService>();
        return services;
    }

    private static IServiceCollection RegisterIdentity(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        services.AddOptions<AdminSeedOptions>()
            .Bind(configuration.GetSection(AdminSeedOptions.SectionName));
        services.AddOptions<PresetAuthoringOptions>()
            .Bind(configuration.GetSection(PresetAuthoringOptions.SectionName));
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
        return services;
    }

    private static IServiceCollection RegisterJwtToken(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        services.AddAuthentication(options =>
            {
                options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultForbidScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidIssuer = RequiredConfiguration(configuration, "Jwt:Issuer"),
                    ValidateAudience = true,
                    ValidAudience = RequiredConfiguration(configuration, "Jwt:Audience"),
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(
                        Encoding.UTF8.GetBytes(RequiredConfiguration(configuration, "Jwt:Key")))
                };
                options.Events = new JwtBearerEvents
                {
                    OnMessageReceived = context =>
                    {
                        var token = context.Request.Query["access_token"];
                        if (!string.IsNullOrWhiteSpace(token) &&
                            context.HttpContext.Request.Path.StartsWithSegments("/api/v1/hubs/admin-authoring"))
                            context.Token = token;
                        return Task.CompletedTask;
                    },
                    OnAuthenticationFailed = context =>
                    {
                        var logger = context.HttpContext.RequestServices
                            .GetRequiredService<ILoggerFactory>()
                            .CreateLogger("ArzlyAI.Authentication");
                        logger.LogWarning(
                            context.Exception,
                            "JWT authentication failed for {Method} {Path}",
                            context.Request.Method,
                            context.Request.Path);
                        return Task.CompletedTask;
                    },
                    OnChallenge = context =>
                    {
                        var logger = context.HttpContext.RequestServices
                            .GetRequiredService<ILoggerFactory>()
                            .CreateLogger("ArzlyAI.Authentication");
                        logger.LogWarning(
                            "JWT challenge for {Method} {Path}; authorization header present: {HasAuthorizationHeader}; failure: {FailureType}; error: {Error}",
                            context.Request.Method,
                            context.Request.Path,
                            context.Request.Headers.ContainsKey("Authorization"),
                            context.AuthenticateFailure?.GetType().Name ?? "none",
                            context.Error ?? "none");
                        return Task.CompletedTask;
                    }
                };
            });
        services.AddAuthorization();
        return services;
    }

    private static string RequiredConfiguration(IConfiguration configuration, string key) =>
        configuration[key] ?? throw new InvalidOperationException($"{key} must be configured.");

    private static IServiceCollection RegisterIntegrations(this IServiceCollection services)
    {
        services.AddHttpClient<ILinkedInPublisher, LinkedInPublisher>(client =>
            client.BaseAddress = new Uri("https://api.linkedin.com/"));
        services.AddScoped<IIntegrationHandler, LinkedInPostsIntegrationHandler>();
        services.AddScoped<IIntegrationHandler, GoogleSheetsReadIntegrationHandler>();
        services.AddScoped<IIntegrationHandler, GoogleSheetsWriteIntegrationHandler>();
        services.AddScoped<IIntegrationHandler, GoogleSheetsReportIntegrationHandler>();
        services.AddScoped<IIntegrationHandler, GmailHtmlIntegrationHandler>();
        services.AddScoped<IIntegrationHandler, GoogleTasksCreateIntegrationHandler>();
        services.AddScoped<IIntegrationHandler, GoogleCalendarCreateEventsIntegrationHandler>();
        return services;
    }

    private static void AddFixedWindowPolicy(
        RateLimiterOptions options,
        IConfiguration configuration,
        string policyName,
        string configurationName,
        int defaultPermitLimit,
        int defaultWindowSeconds)
    {
        var permitLimit = Positive(configuration,
            $"RateLimits:{configurationName}:PermitLimit", defaultPermitLimit);
        var windowSeconds = Positive(configuration,
            $"RateLimits:{configurationName}:WindowSeconds", defaultWindowSeconds);

        options.AddPolicy(policyName, context => RateLimitPartition.GetFixedWindowLimiter(
            GetRateLimitPartitionKey(context),
            _ => new FixedWindowRateLimiterOptions
            {
                AutoReplenishment = true,
                PermitLimit = permitLimit,
                QueueLimit = 0,
                Window = TimeSpan.FromSeconds(windowSeconds)
            }));
    }

    internal static string GetRateLimitPartitionKey(HttpContext context)
    {
        var address = context.Connection.RemoteIpAddress;
        return address is null ? "ip:unknown" : $"ip:{address.MapToIPv6()}";
    }

    private static int Positive(IConfiguration configuration, string key, int fallback) =>
        Math.Max(1, configuration.GetValue<int?>(key) ?? fallback);
}
