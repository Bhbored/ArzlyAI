using ArzlyAI.Application.DTOs.Workflows;
using ArzlyAI.Application.Models;

namespace ArzlyAI.Application.Mappers.Workflows;

public interface IWorkflowRunMapper
{
    WorkflowRunResponse ToResponse(WorkflowRun run);
}
