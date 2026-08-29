// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encryption_key_descriptor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EncryptionKeyDescriptor _$EncryptionKeyDescriptorFromJson(
  Map<String, dynamic> json,
) => _EncryptionKeyDescriptor(
  keyId: json['keyId'] as String,
  algorithm: json['algorithm'] as String,
  publicKeyPem: json['publicKeyPem'] as String,
  maximumLifetimeSeconds: (json['maximumLifetimeSeconds'] as num).toInt(),
);

Map<String, dynamic> _$EncryptionKeyDescriptorToJson(
  _EncryptionKeyDescriptor instance,
) => <String, dynamic>{
  'keyId': instance.keyId,
  'algorithm': instance.algorithm,
  'publicKeyPem': instance.publicKeyPem,
  'maximumLifetimeSeconds': instance.maximumLifetimeSeconds,
};
