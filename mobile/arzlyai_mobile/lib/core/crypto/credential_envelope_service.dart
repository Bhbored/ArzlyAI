import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_builder.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/network/dto/security/credential_envelope.dart';
import 'package:arzlyai_mobile/core/network/services/security/security_service.dart';

part 'credential_envelope_service.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
CredentialEnvelopeService credentialEnvelopeService(Ref ref) {
  return CredentialEnvelopeService(
    ref.read(securityServiceProvider),
    CredentialEnvelopeBuilder(),
  );
}

class CredentialEnvelopeService {
  CredentialEnvelopeService(this._security, this._builder);

  final SecurityService _security;
  final CredentialEnvelopeBuilder _builder;

  Future<CredentialEnvelope> encrypt(Map<String, String> credentials) async {
    try {
      final descriptor = await _security.getEncryptionKey();
      return _builder.build(descriptor: descriptor, credentials: credentials);
    } on ApiException {
      final descriptor = await _security.getEncryptionKey();
      return _builder.build(descriptor: descriptor, credentials: credentials);
    }
  }
}
