using ArzlyAI.Domain.Catalog;
using Microsoft.EntityFrameworkCore;

namespace ArzlyAI.Infrastructure.Persistence.Seeds;

public static class GoogleIntegrationSchemaSeed
{
    public static readonly IReadOnlyDictionary<string, string> Schemas =
        new Dictionary<string, string>(StringComparer.Ordinal)
        {
            ["google.sheets.read"] =
                """{"type":"oauth2AccessToken","fields":["google.accessToken"]}""",
            ["google.sheets.report"] =
                """{"type":"oauth2AccessToken","fields":["google.accessToken"]}""",
            ["google.sheets.write"] =
                """{"type":"oauth2AccessToken","fields":["google.accessToken"]}""",
            ["google.tasks.create"] =
                """{"type":"oauth2AccessToken","fields":["google.accessToken"]}""",
            ["google.calendar.create-events"] =
                """{"type":"oauth2AccessToken","fields":["google.accessToken"]}""",
            ["google.gmail.send-html"] =
                """{"type":"oauth2AccessToken","fields":["google.accessToken","google.email"]}""",
        };

    public static async Task SeedAsync(
        ArzlyDbContext dbContext,
        CancellationToken cancellationToken = default)
    {
        foreach (var (key, schema) in Schemas)
        {
            await dbContext.Integrations
                .Where(integration => integration.Key == key)
                .ExecuteUpdateAsync(
                    setters => setters.SetProperty(
                        integration => integration.CredentialSchemaJson,
                        schema),
                    cancellationToken);
        }
    }
}
