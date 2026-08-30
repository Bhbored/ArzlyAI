namespace ArzlyAI.Application.Services.Models;

public interface IModelCapabilityPolicy
{
    bool IsUsable(string provider, string model);
    bool SupportsTemperature(string provider, string model);
    bool SupportsWebSearch(string provider, string model);
}
