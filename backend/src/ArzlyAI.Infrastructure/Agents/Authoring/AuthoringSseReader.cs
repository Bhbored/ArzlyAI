using System.Runtime.CompilerServices;
using System.Text;

namespace ArzlyAI.Infrastructure.Agents.Authoring;

public static class AuthoringSseReader
{
    public static async IAsyncEnumerable<string> ReadAsync(
        Stream stream, [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        using var reader = new StreamReader(stream, Encoding.UTF8, leaveOpen: true);
        var data = new List<string>();
        while (await reader.ReadLineAsync(cancellationToken) is { } line)
        {
            if (line.Length == 0)
            {
                if (data.Count > 0)
                {
                    yield return string.Join('\n', data);
                    data.Clear();
                }
            }
            else if (line.StartsWith("data:", StringComparison.Ordinal))
            {
                var value = line[5..];
                data.Add(value.StartsWith(' ') ? value[1..] : value);
            }
        }
        if (data.Count > 0) yield return string.Join('\n', data);
    }
}
