using ArzlyAI.Domain.Catalog;
using Microsoft.EntityFrameworkCore;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Persistence.Seeds;

public static class ProviderCatalogSeed
{
    private static readonly (string Key, string DisplayName)[] Providers =
    [
        ("openai", "OpenAI"),
        ("anthropic", "Anthropic"),
        ("gemini", "Google Gemini"),
        ("deepseek", "DeepSeek")
    ];

    public static async Task SeedAsync(ArzlyDbContext dbContext, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("ProviderCatalogSeed.Seed");
        foreach (var (key, displayName) in Providers)
        {
            var existing = await dbContext.Providers
                .SingleOrDefaultAsync(provider => provider.Key == key, cancellationToken);
            if (existing is not null) continue;

            dbContext.Providers.Add(new ProviderDefinition
            {
                Id = Guid.NewGuid(),
                Key = key,
                DisplayName = displayName
            });
        }

        await dbContext.SaveChangesAsync(cancellationToken);

        var openAi = await dbContext.Providers
            .SingleAsync(provider => provider.Key == "openai", cancellationToken);
        if (!await dbContext.Models.AnyAsync(
                model => model.ProviderId == openAi.Id && model.Key == "gpt-5-mini",
                cancellationToken))
        {
            dbContext.Models.Add(new ModelDefinition
            {
                Id = Guid.NewGuid(),
                ProviderId = openAi.Id,
                Key = "gpt-5-mini",
                DisplayName = "GPT-5 mini",
                IsDefault = true
            });
            await dbContext.SaveChangesAsync(cancellationToken);
        }
    }
}
