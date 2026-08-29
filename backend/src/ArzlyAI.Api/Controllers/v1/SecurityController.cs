using ArzlyAI.Api.Configuration;
using ArzlyAI.Application.Security;
using Asp.Versioning;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using SerilogTimings;

namespace ArzlyAI.Api.Controllers.v1;

[ApiController]
[ApiVersion(1.0)]
[EnableRateLimiting(ApiRateLimitPolicies.Security)]
[Route("api/v{version:apiVersion}/security")]
public sealed class SecurityController(
    ICredentialEnvelopeProtector protector,
    ILogger<SecurityController> logger) : ControllerBase
{
    [HttpGet("encryption-key")]
    public ActionResult<EncryptionKeyDescriptor> GetEncryptionKey()
    {
        using var operation = Operation.Time("SecurityController.GetEncryptionKey");
        logger.LogDebug("Issuing ephemeral credential-encryption public key descriptor");
        return Ok(protector.DescribeKey());
    }
}
