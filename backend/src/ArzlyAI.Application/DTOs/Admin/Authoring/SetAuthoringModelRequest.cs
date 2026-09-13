namespace ArzlyAI.Application.DTOs.Admin.Authoring;

public sealed record SetAuthoringModelRequest(string Provider, string Model, int ExpectedRevision);
