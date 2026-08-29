namespace ArzlyAI.Application.Security;
public interface ICredentialEnvelopeProtector
{
    EncryptionKeyDescriptor DescribeKey();
    IReadOnlyDictionary<string, string> Decrypt(CredentialEnvelope envelope);
}
