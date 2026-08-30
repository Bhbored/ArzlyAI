using ArzlyAI.Domain.Entities.Common;

namespace ArzlyAI.Domain.Presets;
public sealed class AgentHarnessDefinition : Base
{
    public Guid AgentId { get; init; }
    public bool PlanningEnabled { get; init; }
    public bool TodoTrackingEnabled { get; init; }
    public bool ContextCompactionEnabled { get; init; }
    public bool RequireToolApproval { get; init; }
    public int MaxIterations { get; init; }
    public bool WebSearchEnabled { get; init; }
    public AgentDefinition Agent { get; init; } = null!;
}
