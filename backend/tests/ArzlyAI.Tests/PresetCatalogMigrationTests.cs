using ArzlyAI.Infrastructure.Persistence.Migrations;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Migrations.Operations;

namespace ArzlyAI.Tests;

public sealed class PresetCatalogMigrationTests
{
    [Theory]
    [InlineData("daily-linkedin-ai-post")]
    [InlineData("smart-purchase-decision")]
    [InlineData("brain-dump-to-action")]
    [InlineData("receipt-intelligence")]
    [InlineData("receipt-monthly-spending")]
    [InlineData("receipt-weekly-budget")]
    [InlineData("receipt-quarterly-tax")]
    [InlineData("receipt-yearly-review")]
    [InlineData("receipt-category-dive")]
    [InlineData("receipt-anomaly-detector")]
    [InlineData("receipt-savings-tracker")]
    public void Up_WhenGenerated_ContainsKeyScopedLegacyDeletion(string key)
    {
        var sql = string.Join(Environment.NewLine, new ExposedMigration().Operations()
            .OfType<SqlOperation>().Select(x => x.Sql));

        Assert.Contains(key, sql, StringComparison.Ordinal);
        Assert.DoesNotContain("TRUNCATE", sql, StringComparison.OrdinalIgnoreCase);
    }

    private sealed class ExposedMigration : AdminAuthoredPresetCatalog
    {
        public IReadOnlyList<MigrationOperation> Operations()
        {
            var builder = new MigrationBuilder("Npgsql.EntityFrameworkCore.PostgreSQL");
            Up(builder);
            return builder.Operations;
        }
    }
}
