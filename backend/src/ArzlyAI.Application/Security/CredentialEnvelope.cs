namespace ArzlyAI.Application.Security;

public sealed record CredentialEnvelope(
    string KeyId,
    string RequestId,
    long ExpiresAtUnixSeconds,
    string WrappedKey,
    string Nonce,
    string Ciphertext,
    string Tag);
