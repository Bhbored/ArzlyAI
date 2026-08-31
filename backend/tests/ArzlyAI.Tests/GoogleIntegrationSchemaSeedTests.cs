using ArzlyAI.Infrastructure.Persistence.Seeds;

namespace ArzlyAI.Tests;

public sealed class GoogleIntegrationSchemaSeedTests
{
    [Theory]
    [InlineData("google.sheets.read", "google.accessToken")]
    [InlineData("google.sheets.report", "google.accessToken")]
    [InlineData("google.tasks.create", "google.accessToken")]
    [InlineData("google.calendar.create-events", "google.accessToken")]
    public void Schemas_WhenSheetsTasksOrCalendar_RequireAccessTokenOnly(
        string integrationKey,
        string requiredField)
    {
        var schema = GoogleIntegrationSchemaSeed.Schemas[integrationKey];
        Assert.Contains(requiredField, schema, StringComparison.Ordinal);
        Assert.DoesNotContain("google.email", schema, StringComparison.Ordinal);
    }

    [Fact]
    public void Schemas_WhenGmail_RequiresAccessTokenAndEmail()
    {
        var schema = GoogleIntegrationSchemaSeed.Schemas["google.gmail.send-html"];
        Assert.Contains("google.accessToken", schema, StringComparison.Ordinal);
        Assert.Contains("google.email", schema, StringComparison.Ordinal);
    }
}
