using System.Security.Cryptography;

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
            await context.Response.WriteAsJsonAsync(new
            {
                success = false,
                message = environment.IsDevelopment() ? exception.Message : PublicMessage(statusCode),
                correlationId = context.TraceIdentifier
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
        _ => StatusCodes.Status500InternalServerError
    };

    private static string PublicMessage(int statusCode) => statusCode switch
    {
        StatusCodes.Status400BadRequest => "The request is invalid.",
        StatusCodes.Status401Unauthorized => "The request is unauthorized.",
        StatusCodes.Status404NotFound => "The requested resource was not found.",
        StatusCodes.Status408RequestTimeout => "The request timed out.",
        StatusCodes.Status409Conflict => "The request conflicts with the current state.",
        StatusCodes.Status502BadGateway => "An upstream service failed.",
        _ => "An unexpected error occurred."
    };
}
