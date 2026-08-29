import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:cryptography/cryptography.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:uuid/uuid.dart';
import 'package:arzlyai_mobile/core/network/dto/security/credential_envelope.dart';
import 'package:arzlyai_mobile/core/network/dto/security/encryption_key_descriptor.dart';

class CredentialEnvelopeBuilder {
  CredentialEnvelopeBuilder({Uuid? uuid, Random? random})
    : _uuid = uuid ?? const Uuid(),
      _random = random ?? Random.secure();

  final Uuid _uuid;
  final Random _random;
  final _aes = AesGcm.with256bits();

  Future<CredentialEnvelope> build({
    required EncryptionKeyDescriptor descriptor,
    required Map<String, String> credentials,
    DateTime? now,
  }) async {
    final aesKey = _randomBytes(32);
    final nonce = _randomBytes(12);
    final requestId = _uuid.v4();
    final lifetime = descriptor.maximumLifetimeSeconds.clamp(1, 120);
    final expiresAt =
        ((now ?? DateTime.now().toUtc()).millisecondsSinceEpoch / 1000)
            .floor() +
        lifetime;
    final aad = utf8.encode('${descriptor.keyId}|$requestId|$expiresAt');
    final plaintext = Uint8List.fromList(utf8.encode(jsonEncode(credentials)));
    try {
      final box = await _aes.encrypt(
        plaintext,
        secretKey: SecretKey(aesKey),
        nonce: nonce,
        aad: aad,
      );
      final wrapped = _wrapAesKey(
        CryptoUtils.rsaPublicKeyFromPem(descriptor.publicKeyPem),
        aesKey,
      );
      return CredentialEnvelope(
        keyId: descriptor.keyId,
        requestId: requestId,
        expiresAtUnixSeconds: expiresAt,
        wrappedKey: base64Encode(wrapped),
        nonce: base64Encode(nonce),
        ciphertext: base64Encode(box.cipherText),
        tag: base64Encode(box.mac.bytes),
      );
    } finally {
      aesKey.fillRange(0, aesKey.length, 0);
      nonce.fillRange(0, nonce.length, 0);
      plaintext.fillRange(0, plaintext.length, 0);
    }
  }

  Uint8List _wrapAesKey(pc.RSAPublicKey publicKey, Uint8List aesKey) {
    final engine = pc.OAEPEncoding.withSHA256(pc.RSAEngine())
      ..init(true, pc.PublicKeyParameter<pc.RSAPublicKey>(publicKey));
    return engine.process(aesKey);
  }

  Uint8List _randomBytes(int length) {
    return Uint8List.fromList(
      List<int>.generate(length, (_) => _random.nextInt(256)),
    );
  }
}
