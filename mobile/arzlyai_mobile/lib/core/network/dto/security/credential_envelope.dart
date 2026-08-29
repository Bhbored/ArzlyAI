import 'package:freezed_annotation/freezed_annotation.dart';

part 'credential_envelope.freezed.dart';
part 'credential_envelope.g.dart';

@freezed
sealed class CredentialEnvelope with _$CredentialEnvelope {
  const factory CredentialEnvelope({
    required String keyId,
    required String requestId,
    required int expiresAtUnixSeconds,
    required String wrappedKey,
    required String nonce,
    required String ciphertext,
    required String tag,
  }) = _CredentialEnvelope;

  factory CredentialEnvelope.fromJson(Map<String, dynamic> json) =>
      _$CredentialEnvelopeFromJson(json);
}
