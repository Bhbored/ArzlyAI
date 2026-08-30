using ArzlyAI.Application.DTOs.Models;
using ArzlyAI.Application.Security;
using Microsoft.Extensions.Logging;
using SerilogTimings;

namespace ArzlyAI.Application.Services.Models;

public sealed class OpenAiModelCatalogService(
    IOpenAiModelClient client,
    IModelCapabilityPolicy capabilities,
    ICredentialEnvelopeProtector credentialsProtector,
    ILogger<OpenAiModelCatalogService> logger) : IOpenAiModelCatalogService
{
    public async Task<IReadOnlyList<OpenAiModelResponse>> ListAsync(
        ListOpenAiModelsRequest request,
        CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("OpenAiModelCatalogService.List");
        var credentials = credentialsProtector.Decrypt(request.Credentials);
        var apiKey = credentials.TryGetValue("openai.apiKey", out var value) &&
                     !string.IsNullOrWhiteSpace(value)
            ? value
            : throw new ArgumentException("Required credential 'openai.apiKey' is missing.");

        var models = await client.ListAsync(apiKey, cancellationToken);
        var response = models
            .Where(model => capabilities.IsUsable("openai", model.Id))
            .OrderBy(model => model.Id, StringComparer.OrdinalIgnoreCase)
            .Select(model => new OpenAiModelResponse(
                model.Id,
                ToDisplayName(model.Id),
                model.OwnedBy,
                model.CreatedAtUtc,
                capabilities.SupportsTemperature("openai", model.Id),
                capabilities.SupportsWebSearch("openai", model.Id)))
            .ToList();
        logger.LogInformation("Loaded {ModelCount} usable OpenAI models", response.Count);
        return response;
    }

    private static string ToDisplayName(string id) =>
        string.Join(' ', id.Split('-', StringSplitOptions.RemoveEmptyEntries)
            .Select(part => part.Equals("gpt", StringComparison.OrdinalIgnoreCase)
                ? "GPT"
                : char.ToUpperInvariant(part[0]) + part[1..]));
}
