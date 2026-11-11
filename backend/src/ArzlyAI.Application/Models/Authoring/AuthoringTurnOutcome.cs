using ArzlyAI.Application.DTOs.Admin.Authoring;

namespace ArzlyAI.Application.Models.Authoring;

public sealed record AuthoringTurnOutcome(AuthoringTurnResponse? Response, bool IsConflict)
{
    public static AuthoringTurnOutcome Success(AuthoringTurnResponse response) => new(response, false);

    public static AuthoringTurnOutcome Conflict() => new(null, true);
}
