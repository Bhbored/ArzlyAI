namespace ArzlyAI.Domain.Entities.Common;

public abstract class Base
{
    public Guid Id { get; init; }
    public DateTimeOffset CreatedAtUtc { get; set; }
    public DateTimeOffset UpdatedAtUtc { get; set; }
}
