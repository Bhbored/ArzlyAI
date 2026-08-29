// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_envelope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CredentialEnvelope _$CredentialEnvelopeFromJson(Map<String, dynamic> json) =>
    _CredentialEnvelope(
      keyId: json['keyId'] as String,
      requestId: json['requestId'] as String,
      expiresAtUnixSeconds: (json['expiresAtUnixSeconds'] as num).toInt(),
      wrappedKey: json['wrappedKey'] as String,
      nonce: json['nonce'] as String,
      ciphertext: json['ciphertext'] as String,
      tag: json['tag'] as String,
    );

Map<String, dynamic> _$CredentialEnvelopeToJson(_CredentialEnvelope instance) =>
    <String, dynamic>{
      'keyId': instance.keyId,
      'requestId': instance.requestId,
      'expiresAtUnixSeconds': instance.expiresAtUnixSeconds,
      'wrappedKey': instance.wrappedKey,
      'nonce': instance.nonce,
      'ciphertext': instance.ciphertext,
      'tag': instance.tag,
    };
