namespace ArzlyAI.Application.Security;
public sealed record EncryptionKeyDescriptor(
    string KeyId, string Algorithm, string PublicKeyPem, int MaximumLifetimeSeconds);
