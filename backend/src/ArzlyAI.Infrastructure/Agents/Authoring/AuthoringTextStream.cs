using System.Text;
using ArzlyAI.Application.Services.Realtime;

namespace ArzlyAI.Infrastructure.Agents.Authoring;

public sealed class AuthoringTextStream(Guid sessionId, IAuthoringRealtimeNotifier realtime)
{
    private readonly StringBuilder text = new();
    private readonly Guid streamId = Guid.NewGuid();
    private int sequence;

    public async Task AppendAsync(string? delta, CancellationToken cancellationToken)
    {
        if (string.IsNullOrEmpty(delta)) return;
        text.Append(delta);
        await realtime.NotifyAsync(sessionId, "AssistantTextUpdated",
            new { sessionId, streamId, sequence = ++sequence, text = text.ToString() }, cancellationToken);
    }

    public override string ToString() => text.ToString();
}
