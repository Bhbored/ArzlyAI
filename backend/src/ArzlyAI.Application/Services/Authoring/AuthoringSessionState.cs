using ArzlyAI.Application.DTOs.Admin.Authoring;
using ArzlyAI.Domain.Authoring;
using ArzlyAI.Domain.Enums;

namespace ArzlyAI.Application.Services.Authoring;

public static class AuthoringSessionState
{
    public static void RequireIdle(PresetAuthoringSession session)
    {
        if (session.LastTurnStatus == "Running")
            throw new AuthoringSessionConflictException("The assistant is still working. Wait for this turn to finish.");
    }

    public static PublishReadinessResponse Readiness(PresetAuthoringSession session)
    {
        var blockers = new List<string>();
        if (session.Status is AuthoringSessionStatus.Published or AuthoringSessionStatus.Abandoned)
            blockers.Add("This chat is read-only.");
        if (session.LastTurnStatus == "Running") blockers.Add("Wait for the assistant to finish.");
        if (session.DraftJson is null) blockers.Add("Create a draft first.");
        else if (session.ValidatedDraftRevision != session.DraftRevision)
            blockers.Add("Validate the current draft before publishing.");
        else if (!PresetDraftSerializer.DeserializeValidation(session.ValidationJson).IsValid)
            blockers.Add("Resolve the draft's validation issues.");
        return new PublishReadinessResponse(blockers.Count == 0, blockers);
    }
}
