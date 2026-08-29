import 'package:freezed_annotation/freezed_annotation.dart';

part 'encryption_key_descriptor.freezed.dart';
part 'encryption_key_descriptor.g.dart';

@freezed
sealed class EncryptionKeyDescriptor with _$EncryptionKeyDescriptor {
  const factory EncryptionKeyDescriptor({
    required String keyId,
    required String algorithm,
    required String publicKeyPem,
    required int maximumLifetimeSeconds,
  }) = _EncryptionKeyDescriptor;

  factory EncryptionKeyDescriptor.fromJson(Map<String, dynamic> json) =>
      _$EncryptionKeyDescriptorFromJson(json);
}
