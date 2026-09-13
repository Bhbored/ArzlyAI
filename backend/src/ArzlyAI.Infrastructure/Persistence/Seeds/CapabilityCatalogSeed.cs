using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Enums;
using Microsoft.EntityFrameworkCore;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Persistence.Seeds;

public static class CapabilityCatalogSeed
{
    public static async Task SeedAsync(
        ArzlyDbContext dbContext,
        CancellationToken cancellationToken = default)
    {
        using var operation = Operation.Time("CapabilityCatalogSeed.Seed");
        var google = await EnsureConnectorAsync(dbContext, "google", "Google Workspace",
            "Google Workspace services authorized natively by the mobile client.", "oauth2", cancellationToken);
        var linkedIn = await EnsureConnectorAsync(dbContext, "linkedin", "LinkedIn",
            "LinkedIn publishing credentials supplied by the mobile client.", "oauth2", cancellationToken);

        await EnsureIntegrationAsync(dbContext, google, "google.sheets.read", "Google Sheets Read",
            "Read a bounded range from Google Sheets.", "[\"https://www.googleapis.com/auth/spreadsheets\",\"https://www.googleapis.com/auth/drive.metadata.readonly\"]",
            "[\"Google Sheets API\",\"Google Drive API\"]", IntegrationRiskLevel.Read, true, cancellationToken);
        await EnsureIntegrationAsync(dbContext, google, "google.sheets.write", "Google Sheets Write",
            "Append structured values to Google Sheets.", "[\"https://www.googleapis.com/auth/spreadsheets\"]",
            "[\"Google Sheets API\"]", IntegrationRiskLevel.Write, true, cancellationToken);
        await EnsureIntegrationAsync(dbContext, google, "google.sheets.report", "Google Sheets Report",
            "Write a formatted report tab to Google Sheets.", "[\"https://www.googleapis.com/auth/spreadsheets\"]",
            "[\"Google Sheets API\"]", IntegrationRiskLevel.Write, true, cancellationToken);
        await EnsureIntegrationAsync(dbContext, google, "google.tasks.create", "Google Tasks",
            "Create task lists, tasks, and subtasks.", "[\"https://www.googleapis.com/auth/tasks\"]",
            "[\"Google Tasks API\"]", IntegrationRiskLevel.Write, true, cancellationToken);
        await EnsureIntegrationAsync(dbContext, google, "google.calendar.create-events", "Google Calendar",
            "Create calendar events.", "[\"https://www.googleapis.com/auth/calendar.events\"]",
            "[\"Google Calendar API\"]", IntegrationRiskLevel.Write, true, cancellationToken);
        await EnsureIntegrationAsync(dbContext, google, "google.gmail.send-html", "Gmail HTML",
            "Send an HTML email with Gmail.", "[\"https://www.googleapis.com/auth/gmail.send\"]",
            "[\"Gmail API\"]", IntegrationRiskLevel.ExternalAction, true, cancellationToken,
            "{\"type\":\"oauth2AccessToken\",\"fields\":[\"google.accessToken\",\"google.email\"]}");
        await EnsureIntegrationAsync(dbContext, linkedIn, "linkedin.posts", "LinkedIn Posts",
            "Publish text posts to LinkedIn.", "[\"w_member_social\"]", "[\"LinkedIn Posts API\"]",
            IntegrationRiskLevel.ExternalAction, true, cancellationToken,
            "{\"type\":\"oauth2AccessToken\",\"fields\":[\"linkedin.accessToken\",\"linkedin.authorUrn\"]}");

        await EnsureOperationAsync(dbContext, "decision.weighted-score", "Weighted decision score",
            "Score purchase candidates deterministically using configured weights.", cancellationToken);
        await EnsureOperationAsync(dbContext, "receipt.analyze", "Receipt analysis",
            "Normalize and analyze up to 1,000 receipt rows deterministically.", cancellationToken);
        await dbContext.SaveChangesAsync(cancellationToken);
    }

    private static async Task<ConnectorDefinition> EnsureConnectorAsync(
        ArzlyDbContext dbContext, string key, string name, string description, string authenticationType,
        CancellationToken cancellationToken)
    {
        var existing = await dbContext.Connectors.SingleOrDefaultAsync(x => x.Key == key, cancellationToken);
        if (existing is not null) return existing;
        var connector = new ConnectorDefinition
        {
            Id = StableId($"connector:{key}"), Key = key, DisplayName = name,
            Description = description, AuthenticationType = authenticationType, IsEnabled = true
        };
        dbContext.Connectors.Add(connector);
        return connector;
    }

    private static async Task EnsureIntegrationAsync(
        ArzlyDbContext dbContext, ConnectorDefinition connector, string key, string name,
        string description, string scopesJson, string apisJson, IntegrationRiskLevel riskLevel,
        bool supportsBackgroundExecution, CancellationToken cancellationToken,
        string credentialSchema = "{\"type\":\"oauth2AccessToken\",\"fields\":[\"google.accessToken\"]}")
    {
        var existing = await dbContext.Integrations.SingleOrDefaultAsync(x => x.Key == key, cancellationToken);
        if (existing is null)
        {
            existing = new IntegrationDefinition
            {
                Id = StableId($"integration:{key}"), Key = key, DisplayName = name,
                Description = description, CredentialSchemaJson = credentialSchema, IsEnabled = true
            };
            dbContext.Integrations.Add(existing);
        }
        existing.Connector = connector;
        existing.ConnectorId = connector.Id;
        existing.CredentialSchemaJson = credentialSchema;
        existing.InputSchemaJson = IntegrationInputSchema(key);
        existing.OutputSchemaJson = "{\"type\":\"string\"}";
        existing.RequiredOAuthScopesJson = scopesJson;
        existing.RequiredApisJson = apisJson;
        existing.DocumentationLinksJson = DocumentationLinks(key);
        existing.RiskLevel = riskLevel;
        existing.SupportsBackgroundExecution = supportsBackgroundExecution;
    }

    private static async Task EnsureOperationAsync(
        ArzlyDbContext dbContext, string key, string name, string description,
        CancellationToken cancellationToken)
    {
        var existing = await dbContext.WorkflowOperations.SingleOrDefaultAsync(x => x.Key == key, cancellationToken);
        if (existing is not null)
        {
            existing.InputSchemaJson = OperationInputSchema(key);
            existing.OutputSchemaJson = "{\"type\":\"object\"}";
            existing.SupportsBackgroundExecution = true;
            return;
        }
        dbContext.WorkflowOperations.Add(new WorkflowOperationDefinition
        {
            Id = StableId($"operation:{key}"), Key = key, DisplayName = name,
            Description = description, IsEnabled = true, SupportsBackgroundExecution = true,
            InputSchemaJson = OperationInputSchema(key), OutputSchemaJson = "{\"type\":\"object\"}"
        });
    }

    private static string IntegrationInputSchema(string key) => key switch
    {
        "google.sheets.read" => "{\"type\":\"object\",\"required\":[\"spreadsheetId\",\"range\"],\"properties\":{\"spreadsheetId\":{\"type\":\"string\"},\"range\":{\"type\":\"string\"},\"maximumRows\":{\"type\":\"integer\"}}}",
        "google.sheets.write" => "{\"type\":\"object\",\"required\":[\"spreadsheetId\",\"range\",\"rowsJson\"],\"properties\":{\"spreadsheetId\":{\"type\":\"string\"},\"range\":{\"type\":\"string\"},\"rowsJson\":{\"type\":\"string\"}}}",
        "google.sheets.report" => "{\"type\":\"object\",\"required\":[\"spreadsheetId\",\"tabTitle\"],\"properties\":{\"spreadsheetId\":{\"type\":\"string\"},\"tabTitle\":{\"type\":\"string\"},\"reportJson\":{\"type\":\"string\"},\"reportRowsJson\":{\"type\":\"string\"}}}",
        "google.tasks.create" => "{\"type\":\"object\",\"required\":[\"reportJson\"],\"properties\":{\"reportJson\":{\"type\":\"string\"},\"taskListTitle\":{\"type\":\"string\"}}}",
        "google.calendar.create-events" => "{\"type\":\"object\",\"required\":[\"reportJson\",\"asOfDate\",\"workingHoursStart\",\"workingHoursEnd\"],\"properties\":{\"reportJson\":{\"type\":\"string\"},\"calendarId\":{\"type\":\"string\"},\"asOfDate\":{\"type\":\"string\"},\"workingHoursStart\":{\"type\":\"string\"},\"workingHoursEnd\":{\"type\":\"string\"}}}",
        "google.gmail.send-html" => "{\"type\":\"object\",\"required\":[\"recipient\",\"subject\"],\"properties\":{\"recipient\":{\"type\":\"string\"},\"subject\":{\"type\":\"string\"},\"html\":{\"type\":\"string\"},\"reportJson\":{\"type\":\"string\"}}}",
        "linkedin.posts" => "{\"type\":\"object\",\"required\":[\"text\"],\"properties\":{\"text\":{\"type\":\"string\"}}}",
        _ => "{}"
    };

    private static string OperationInputSchema(string key) => key switch
    {
        "decision.weighted-score" => "{\"type\":\"object\",\"required\":[\"evidence\"],\"properties\":{\"evidence\":{\"type\":\"string\"}}}",
        "receipt.analyze" => "{\"type\":\"object\",\"required\":[\"rowsJson\",\"analysisMode\",\"columnMappingJson\",\"asOfDate\",\"currencyCode\"],\"properties\":{\"rowsJson\":{\"type\":\"string\"},\"analysisMode\":{\"type\":\"string\"},\"columnMappingJson\":{\"type\":\"string\"},\"asOfDate\":{\"type\":\"string\"},\"currencyCode\":{\"type\":\"string\"},\"budget\":{\"type\":\"number\"},\"taxRate\":{\"type\":\"number\"},\"category\":{\"type\":\"string\"}}}",
        _ => "{}"
    };

    private static string DocumentationLinks(string key) => key.StartsWith("google.sheets", StringComparison.Ordinal)
        ? "[\"https://developers.google.com/workspace/sheets/api/scopes\"]"
        : key.StartsWith("google.tasks", StringComparison.Ordinal)
            ? "[\"https://developers.google.com/workspace/tasks/auth\"]"
            : key.StartsWith("google.calendar", StringComparison.Ordinal)
                ? "[\"https://developers.google.com/workspace/calendar/api/v3/reference/events/insert\"]"
                : key.StartsWith("google.gmail", StringComparison.Ordinal)
                    ? "[\"https://developers.google.com/workspace/gmail/api/auth/scopes\"]"
                    : "[]";

    private static Guid StableId(string value)
    {
        var hash = System.Security.Cryptography.SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(value));
        return new Guid(hash[..16]);
    }
}
