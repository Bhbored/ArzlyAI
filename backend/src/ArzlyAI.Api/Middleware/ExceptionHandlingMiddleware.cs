using System.Security.Cryptography;
using ArzlyAI.Application.Services.Authoring;

namespace ArzlyAI.Api.Middleware;

public sealed class ExceptionHandlingMiddleware(
    RequestDelegate next,
    ILogger<ExceptionHandlingMiddleware> logger,
    IHostEnvironment environment)
{
    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await next(context);
        }
        catch (Exception exception)
        {
            if (context.Response.HasStarted)
            {
                logger.LogWarning(exception,
                    "Response already started for {CorrelationId}; exception response cannot be written",
                    context.TraceIdentifier);
                throw;
            }

            var statusCode = GetStatusCode(exception);
            if (statusCode >= StatusCodes.Status500InternalServerError)
                logger.LogError(exception, "Unhandled {ExceptionType} for {CorrelationId}",
                    exception.GetType().Name, context.TraceIdentifier);
            else
                logger.LogWarning("Request failed with {ExceptionType}, status {StatusCode}, correlation {CorrelationId}",
                    exception.GetType().Name, statusCode, context.TraceIdentifier);

            context.Response.Clear();
            context.Response.StatusCode = statusCode;
            var message = environment.IsDevelopment() ? exception.Message : PublicMessage(statusCode);
            if (exception is PresetValidationException validationException)
                await context.Response.WriteAsJsonAsync(new
                {
                    success = false, message, validation = validationException.Validation,
                    correlationId = context.TraceIdentifier
                }, context.RequestAborted);
            else
                await context.Response.WriteAsJsonAsync(new
                {
                    success = false, message, correlationId = context.TraceIdentifier
                }, context.RequestAborted);
        }
    }

    private static int GetStatusCode(Exception exception) => exception switch
    {
        ArgumentException or FormatException or CryptographicException => StatusCodes.Status400BadRequest,
        UnauthorizedAccessException => StatusCodes.Status401Unauthorized,
        KeyNotFoundException or FileNotFoundException => StatusCodes.Status404NotFound,
        InvalidOperationException => StatusCodes.Status409Conflict,
        TimeoutException or OperationCanceledException => StatusCodes.Status408RequestTimeout,
        HttpRequestException => StatusCodes.Status502BadGateway,
        NotImplementedException => StatusCodes.Status501NotImplemented,
        PresetValidationException => StatusCodes.Status422UnprocessableEntity,
        _ => StatusCodes.Status500InternalServerError
    };

    private static string PublicMessage(int statusCode) => statusCode switch
    {
        StatusCodes.Status400BadRequest => "The request is invalid.",
        StatusCodes.Status401Unauthorized => "The request is unauthorized.",
        StatusCodes.Status404NotFound => "The requested resource was not found.",
        StatusCodes.Status408RequestTimeout => "The request timed out.",
        StatusCodes.Status409Conflict => "The request conflicts with the current state.",
        StatusCodes.Status422UnprocessableEntity => "The preset draft is not publishable.",
        StatusCodes.Status502BadGateway => "An upstream service failed.",
        _ => "An unexpected error occurred."
    };
}
