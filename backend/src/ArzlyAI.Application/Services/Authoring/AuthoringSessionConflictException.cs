namespace ArzlyAI.Application.Services.Authoring;

public sealed class AuthoringSessionConflictException(string message, Exception? innerException = null)
    : InvalidOperationException(message, innerException);
