using System.Collections.Concurrent;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using ArzlyAI.Application.Security;
using SerilogTimings;

namespace ArzlyAI.Infrastructure.Security;

public sealed class EphemeralCredentialEnvelopeProtector : ICredentialEnvelopeProtector, IDisposable
{
    private const int MaximumLifetimeSeconds = 120;
    private readonly RSA rsa = RSA.Create(3072);
    private readonly string keyId = Guid.NewGuid().ToString("N");
    private readonly ConcurrentDictionary<string, long> usedRequestIds = new();

    public EncryptionKeyDescriptor DescribeKey()
    {
        using var operation = Operation.Time("CredentialEnvelopeProtector.DescribeKey");
        return new EncryptionKeyDescriptor(
            keyId,
            "RSA-OAEP-256+A256GCM",
            rsa.ExportSubjectPublicKeyInfoPem(),
            MaximumLifetimeSeconds);
    }

    public IReadOnlyDictionary<string, string> Decrypt(CredentialEnvelope envelope)
    {
        using var operation = Operation.Time("CredentialEnvelopeProtector.Decrypt");
        var now = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
        if (!CryptographicOperations.FixedTimeEquals(
                Encoding.UTF8.GetBytes(envelope.KeyId), Encoding.UTF8.GetBytes(keyId)))
            throw new CryptographicException("The credential envelope key is invalid.");
        if (envelope.ExpiresAtUnixSeconds < now || envelope.ExpiresAtUnixSeconds > now + MaximumLifetimeSeconds)
            throw new CryptographicException("The credential envelope has expired or lives too long.");

        RemoveExpiredReplayEntries(now);
        if (!usedRequestIds.TryAdd(envelope.RequestId, envelope.ExpiresAtUnixSeconds))
            throw new CryptographicException("The credential envelope was already used.");

        byte[]? aesKey = null;
        byte[]? plaintext = null;
        try
        {
            aesKey = rsa.Decrypt(Convert.FromBase64String(envelope.WrappedKey), RSAEncryptionPadding.OaepSHA256);
            if (aesKey.Length != 32) throw new CryptographicException("An AES-256 key is required.");
            var ciphertext = Convert.FromBase64String(envelope.Ciphertext);
            plaintext = new byte[ciphertext.Length];
            var associatedData = Encoding.UTF8.GetBytes(
                $"{envelope.KeyId}|{envelope.RequestId}|{envelope.ExpiresAtUnixSeconds}");
            using var aes = new AesGcm(aesKey, 16);
            aes.Decrypt(Convert.FromBase64String(envelope.Nonce), ciphertext,
                Convert.FromBase64String(envelope.Tag), plaintext, associatedData);
            return JsonSerializer.Deserialize<Dictionary<string, string>>(plaintext)
                ?? throw new CryptographicException("The credential payload is invalid.");
        }
        catch
        {
            usedRequestIds.TryRemove(envelope.RequestId, out _);
            throw;
        }
        finally
        {
            if (aesKey is not null) CryptographicOperations.ZeroMemory(aesKey);
            if (plaintext is not null) CryptographicOperations.ZeroMemory(plaintext);
        }
    }

    private void RemoveExpiredReplayEntries(long now)
    {
        foreach (var entry in usedRequestIds.Where(x => x.Value < now))
            usedRequestIds.TryRemove(entry.Key, out _);
    }

    public void Dispose() => rsa.Dispose();
}
