using ArzlyAI.Api.Hubs;
using ArzlyAI.Api.Configuration;
using ArzlyAI.Api.Helpers;
using ArzlyAI.Api.Middleware;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.AspNetCore.RateLimiting;
using Serilog;

var builder = WebApplication.CreateBuilder(args);
builder.Host.UseSerilog((context, services, loggerConfiguration) => loggerConfiguration
    .ReadFrom.Configuration(context.Configuration)
    .ReadFrom.Services(services));
builder.Services.RegisterDependencies(builder.Configuration);

var app = builder.Build();
await app.InitializeDatabaseAsync();

app.UseMiddleware<CorrelationIdMiddleware>();
app.UseMiddleware<ExceptionHandlingMiddleware>();
app.UseSerilogRequestLogging(options =>
{
    options.EnrichDiagnosticContext = (diagnosticContext, httpContext) =>
    {
        diagnosticContext.Set("RequestHost", httpContext.Request.Host.Value);
        diagnosticContext.Set("RequestScheme", httpContext.Request.Scheme);
        diagnosticContext.Set("RequestProtocol", httpContext.Request.Protocol);
    };
});
app.UseHttpLogging();
if (app.Environment.IsDevelopment()) app.MapOpenApi();
app.UseHttpsRedirection();
app.UseCors(DIContainer.CorsPolicyName);
app.UseRateLimiter();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.MapHub<WorkflowHub>("/api/v1/hubs/workflows")
    .RequireRateLimiting(ApiRateLimitPolicies.SignalR);
app.MapHub<AdminAuthoringHub>("/api/v1/hubs/admin-authoring")
    .RequireRateLimiting(ApiRateLimitPolicies.AdminAuthoring);
app.MapHealthChecks("/health/live", new HealthCheckOptions
{
    Predicate = _ => false
});
app.MapHealthChecks("/health/ready", new HealthCheckOptions
{
    Predicate = check => check.Tags.Contains("ready")
});
app.Run();

public partial class Program;
