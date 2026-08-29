using ArzlyAI.Domain.Catalog;
using ArzlyAI.Domain.Presets;
using ArzlyAI.Domain.Enums;
using Microsoft.EntityFrameworkCore;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Persistence.Seeds;

public static class LinkedInPresetSeed
{
    public const string PresetKey = "daily-linkedin-ai-post";

    public static async Task SeedAsync(ArzlyDbContext dbContext, CancellationToken cancellationToken)
    {
        using var operation = Operation.Time("LinkedInPresetSeed.Seed");
        if (await dbContext.Presets.AnyAsync(
                preset => preset.Key == PresetKey,
                cancellationToken))
            return;

        var provider = new ProviderDefinition { Id = Id("0001"), Key = "openai", DisplayName = "OpenAI" };
        var model = new ModelDefinition { Id = Id("0002"), ProviderId = provider.Id, Key = "gpt-5-mini", DisplayName = "GPT-5 mini", IsDefault = true };
        var linkedIn = new IntegrationDefinition
        {
            Id = Id("0003"), Key = "linkedin.posts", DisplayName = "LinkedIn Posts",
            Description = "Publish text posts to LinkedIn.", IsEnabled = true,
            CredentialSchemaJson = "{\"type\":\"oauth2AccessToken\",\"fields\":[\"accessToken\",\"authorUrn\"]}"
        };
        var preset = new PresetDefinition
        {
            Id = Id("0010"), Key = PresetKey, Name = "Daily LinkedIn AI Post",
            Description = "Generate a concise post for a topic and publish it to LinkedIn.",
            Version = 1, IsPublished = true
        };
        var agent = new AgentDefinition
        {
            Id = Id("0011"), PresetId = preset.Id, ModelId = model.Id, Key = "content-writer",
            Name = "AI Content Writer",
            Instructions = "Write a concise, useful LinkedIn post. Do not invent facts. Return only the final post.",
            RuntimeType = AgentRuntimeType.Model,
            DefaultTemperature = 0.7, MinimumTemperature = 0, MaximumTemperature = 1.5,
            AllowModelOverride = true, AllowTemperatureOverride = true
        };
        var harness = new AgentHarnessDefinition
        {
            Id = Id("0012"), AgentId = agent.Id, PlanningEnabled = false,
            TodoTrackingEnabled = false, ContextCompactionEnabled = true,
            RequireToolApproval = false, MaxIterations = 3
        };
        var publisherAgent = new AgentDefinition
        {
            Id = Id("0016"), PresetId = preset.Id, ModelId = model.Id, Key = "linkedin-publisher",
            Name = "LinkedIn Publisher",
            Instructions = "Publish only the exact content approved by the user. Never rewrite approved content.",
            RuntimeType = AgentRuntimeType.Passthrough,
            DefaultTemperature = 0, MinimumTemperature = 0, MaximumTemperature = 0,
            AllowModelOverride = false, AllowTemperatureOverride = false
        };
        var publisherHarness = new AgentHarnessDefinition
        {
            Id = Id("0017"), AgentId = publisherAgent.Id, PlanningEnabled = false,
            TodoTrackingEnabled = false, ContextCompactionEnabled = false,
            RequireToolApproval = false, MaxIterations = 1
        };
        var workflow = new WorkflowDefinition { Id = Id("0013"), PresetId = preset.Id, Key = "generate-and-publish" };
        var steps = new[]
        {
            new WorkflowStepDefinition { Id = Id("0014"), WorkflowId = workflow.Id, Position = 1,
                Type = WorkflowNodeType.Agent, ReferenceKey = agent.Key, DisplayName = agent.Name,
                InputMappingJson = "{\"topic\":\"$.inputs.topic\"}", RequiresHumanApproval = false },
            new WorkflowStepDefinition { Id = Id("0015"), WorkflowId = workflow.Id, Position = 2,
                Type = WorkflowNodeType.HumanApproval, ReferenceKey = "approve-content", DisplayName = "Review Content",
                InputMappingJson = "{\"content\":\"$.steps[0].output\"}", RequiresHumanApproval = true },
            new WorkflowStepDefinition { Id = Id("0018"), WorkflowId = workflow.Id, Position = 3,
                Type = WorkflowNodeType.Agent, ReferenceKey = publisherAgent.Key, DisplayName = publisherAgent.Name,
                InputMappingJson = "{\"content\":\"$.steps[1].approvedOutput\"}", RequiresHumanApproval = false },
            new WorkflowStepDefinition { Id = Id("0019"), WorkflowId = workflow.Id, Position = 4,
                Type = WorkflowNodeType.Integration, ReferenceKey = linkedIn.Key, DisplayName = "Post to LinkedIn",
                InputMappingJson = "{\"text\":\"$.steps[2].output\"}", RequiresHumanApproval = false }
        };
        var connections = new[]
        {
            new WorkflowConnectionDefinition { Id = Id("0020"), WorkflowId = workflow.Id, SourceStepId = Id("0014"), TargetStepId = Id("0015") },
            new WorkflowConnectionDefinition { Id = Id("0021"), WorkflowId = workflow.Id, SourceStepId = Id("0015"), TargetStepId = Id("0018") },
            new WorkflowConnectionDefinition { Id = Id("0022"), WorkflowId = workflow.Id, SourceStepId = Id("0018"), TargetStepId = Id("0019") }
        };

        dbContext.AddRange(provider, model, linkedIn, preset, agent, harness, publisherAgent, publisherHarness, workflow);
        dbContext.AddRange(steps);
        dbContext.AddRange(connections);
        dbContext.Add(new PresetIntegration { PresetId = preset.Id, IntegrationId = linkedIn.Id });
        await dbContext.SaveChangesAsync(cancellationToken);
    }

    private static Guid Id(string suffix) => Guid.Parse($"00000000-0000-0000-0000-{suffix.PadLeft(12, '0')}");
}
