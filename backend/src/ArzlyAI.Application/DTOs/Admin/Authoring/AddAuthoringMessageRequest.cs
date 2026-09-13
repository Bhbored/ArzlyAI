namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record AddAuthoringMessageRequest(string Content, int ExpectedRevision);
