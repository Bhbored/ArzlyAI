import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pointycastle/export.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_builder.dart';
import 'package:arzlyai_mobile/core/network/dto/security/encryption_key_descriptor.dart';

void main() {
  test(
    'envelope uses rsa oaep sha256 aes gcm aad and unique request ids',
    () async {
      final pair = CryptoUtils.generateRSAKeyPair(keySize: 2048);
      final publicPem = CryptoUtils.encodeRSAPublicKeyToPem(
        pair.publicKey as RSAPublicKey,
      );
      final privateKey = pair.privateKey as RSAPrivateKey;
      const descriptor = EncryptionKeyDescriptor(
        keyId: 'key-1',
        algorithm: 'RSA-OAEP-256+A256GCM',
        publicKeyPem: '',
        maximumLifetimeSeconds: 120,
      );
      final withPem = EncryptionKeyDescriptor(
        keyId: descriptor.keyId,
        algorithm: descriptor.algorithm,
        publicKeyPem: publicPem,
        maximumLifetimeSeconds: descriptor.maximumLifetimeSeconds,
      );
      final builder = CredentialEnvelopeBuilder();
      final first = await builder.build(
        descriptor: withPem,
        credentials: {'openai.apiKey': 'secret-key'},
      );
      final second = await builder.build(
        descriptor: withPem,
        credentials: {'openai.apiKey': 'secret-key'},
      );
      expect(first.requestId, isNot(second.requestId));
      expect(first.keyId, 'key-1');
      final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      expect(first.expiresAtUnixSeconds, lessThanOrEqualTo(now + 120));
      expect(first.expiresAtUnixSeconds, greaterThan(now));

      final wrapped = base64Decode(first.wrappedKey);
      final aesKey = _decryptRsaOaep(privateKey, wrapped);
      expect(aesKey.length, 32);
      final nonce = base64Decode(first.nonce);
      expect(nonce.length, 12);
      final ciphertext = base64Decode(first.ciphertext);
      final tag = base64Decode(first.tag);
      expect(tag.length, 16);
      final aad = utf8.encode(
        '${first.keyId}|${first.requestId}|${first.expiresAtUnixSeconds}',
      );
      final plain = _decryptAesGcm(
        key: aesKey,
        nonce: nonce,
        ciphertext: ciphertext,
        tag: tag,
        aad: Uint8List.fromList(aad),
      );
      expect(jsonDecode(utf8.decode(plain)), {'openai.apiKey': 'secret-key'});
    },
  );
}

Uint8List _decryptRsaOaep(RSAPrivateKey key, Uint8List cipher) {
  final engine = OAEPEncoding.withSHA256(RSAEngine())
    ..init(false, PrivateKeyParameter<RSAPrivateKey>(key));
  return engine.process(cipher);
}

Uint8List _decryptAesGcm({
  required Uint8List key,
  required Uint8List nonce,
  required Uint8List ciphertext,
  required Uint8List tag,
  required Uint8List aad,
}) {
  final cipher = GCMBlockCipher(AESEngine())
    ..init(false, AEADParameters(KeyParameter(key), 128, nonce, aad));
  final combined = Uint8List(ciphertext.length + tag.length)
    ..setAll(0, ciphertext)
    ..setAll(ciphertext.length, tag);
  return cipher.process(combined);
}
