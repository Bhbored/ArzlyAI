using System.Text.Json;

namespace ArzlyAI.Application.Services.Workflows.Rendering;

public interface IWorkflowResultRenderer
{
    bool CanRender(string contractKey, int contractVersion);
    string Render(JsonElement document);
}
