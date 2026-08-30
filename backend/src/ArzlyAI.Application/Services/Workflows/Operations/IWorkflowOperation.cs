namespace ArzlyAI.Application.Services.Workflows.Operations;

public interface IWorkflowOperation
{
    string Key { get; }
    Task<string> ExecuteAsync(
        IReadOnlyDictionary<string, string> inputs,
        CancellationToken cancellationToken);
}
