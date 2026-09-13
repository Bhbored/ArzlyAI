using ArzlyAI.Application.Models.Authoring;
using ArzlyAI.Application.Repositories.Authoring;
using ArzlyAI.Application.Services.Authoring;
using ArzlyAI.Application.Services.Models;
using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Tests;

public sealed class PresetDraftValidatorTests
{
    [Fact]
    public async Task ValidateAsync_WhenGraphUsesRegisteredOperation_IsValid()
    {
        var result = await Validator().ValidateAsync(ValidDraft(), CancellationToken.None);

        Assert.True(result.IsValid, string.Join(Environment.NewLine, result.Errors.Select(x => x.Message)));
    }

    [Fact]
    public async Task ValidateAsync_WhenIntegrationIsUnavailable_ReturnsError()
    {
        var draft = ValidDraft() with
        {
            Workflow = new PresetDraftWorkflow("flow",
            [new PresetDraftNode("send", "Send", WorkflowNodeType.Integration, "missing.send", 1,
                "{}", false, null, null, null)], [])
        };

        var result = await Validator().ValidateAsync(draft, CancellationToken.None);

        Assert.Contains(result.Errors, x => x.Message.Contains("unavailable", StringComparison.Ordinal));
    }

    [Fact]
    public async Task ValidateAsync_WhenMappingReferencesNonUpstreamNode_ReturnsError()
    {
        var first = new PresetDraftNode("first", "First", WorkflowNodeType.Operation,
            "receipt.analyze", 1, "{}", false, null, null, null);
        var second = new PresetDraftNode("second", "Second", WorkflowNodeType.Operation,
            "receipt.analyze", 2, "{\"value\":\"$.nodes.second.output\"}", false, null, null, null);
        var draft = ValidDraft() with
        {
            Workflow = new PresetDraftWorkflow("flow", [first, second],
                [new PresetDraftConnection("first", "second")])
        };

        var result = await Validator().ValidateAsync(draft, CancellationToken.None);

        Assert.Contains(result.Errors, x => x.Message.Contains("not upstream", StringComparison.Ordinal));
    }

    [Fact]
    public async Task ValidateAsync_WhenRequiredOperationMappingIsMissing_ReturnsError()
    {
        var catalog = new Catalog("{\"type\":\"object\",\"required\":[\"rowsJson\"]}");
        var validator = new PresetDraftValidator(catalog, new ProviderModelCapabilityPolicy());

        var result = await validator.ValidateAsync(ValidDraft(), CancellationToken.None);

        Assert.Contains(result.Errors, x => x.Message.Contains("'rowsJson' is missing", StringComparison.Ordinal));
    }

    private static PresetDraftValidator Validator() =>
        new(new Catalog(), new ProviderModelCapabilityPolicy());

    private static PresetDraftDocument ValidDraft() => new(
        "test-preset", "Test preset", "A useful test", "Short description", "Detailed description",
        "{\"type\":\"object\"}", null, null,
        new BackgroundExecutionPolicyDraft(BackgroundExecutionMode.Optional,
            "Safe to repeat with stored inputs.", ["manual", "daily"]),
        [],
        new PresetDraftWorkflow("flow",
        [new PresetDraftNode("analyze", "Analyze", WorkflowNodeType.Operation,
            "receipt.analyze", 1, "{}", false, null, null, null)], []),
        []);

    private sealed class Catalog(string operationInputSchema = "{}") : ICapabilityCatalogRepository
    {
        private readonly ProviderDefinition provider = new()
        {
            Id = Guid.NewGuid(), Key = "openai", DisplayName = "OpenAI"
        };

        public Task<IReadOnlyList<IntegrationDefinition>> ListIntegrationsAsync(CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<IntegrationDefinition>>([]);

        public Task<IReadOnlyList<WorkflowOperationDefinition>> ListOperationsAsync(CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<WorkflowOperationDefinition>>
            ([new WorkflowOperationDefinition
            {
                Id = Guid.NewGuid(), Key = "receipt.analyze", DisplayName = "Receipt analysis",
                Description = "Analyze", IsEnabled = true, InputSchemaJson = operationInputSchema
            }]);

        public Task<IReadOnlyList<ModelDefinition>> ListModelsAsync(CancellationToken cancellationToken) =>
            Task.FromResult<IReadOnlyList<ModelDefinition>>
            ([new ModelDefinition
            {
                Id = Guid.NewGuid(), ProviderId = provider.Id, Provider = provider,
                Key = "gpt-5-mini", DisplayName = "GPT-5 mini"
            }]);
    }
}
