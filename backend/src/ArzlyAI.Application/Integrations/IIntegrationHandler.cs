namespace ArzlyAI.Application.Integrations;
public interface IIntegrationHandler
{
    string Key { get; }
    Task<string> ExecuteAsync(
        IReadOnlyDictionary<string, string> inputs,
        IReadOnlyDictionary<string, string> credentials,
        CancellationToken cancellationToken);
}
