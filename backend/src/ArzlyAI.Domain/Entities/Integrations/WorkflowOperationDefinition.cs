using ArzlyAI.Domain.Entities.Common;

namespace ArzlyAI.Domain.Catalog;

public sealed class WorkflowOperationDefinition : Base
{
    public required string Key { get; init; }
    public required string DisplayName { get; init; }
    public required string Description { get; init; }
    public string InputSchemaJson { get; set; } = "{}";
    public string OutputSchemaJson { get; set; } = "{}";
    public bool SupportsBackgroundExecution { get; set; }
    public bool IsEnabled { get; init; }
}
