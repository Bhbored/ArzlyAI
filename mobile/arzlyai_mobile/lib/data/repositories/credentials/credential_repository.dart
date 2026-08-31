import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/core/google/google_auth_exceptions.dart';
import 'package:arzlyai_mobile/core/storage/secure_storage/secure_storage_android.dart';
import 'package:arzlyai_mobile/data/providers/google/google_auth_provider.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/connector_credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_store.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_native_auth_repository.dart';
import 'package:arzlyai_mobile/domain/entities/credentials/credential_requirement.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';

part 'credential_repository.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
CredentialStore credentialStore(Ref ref) {
  return CredentialStore(ref.read(secureStorageAndroidProvider));
}

@Riverpod(keepAlive: true, retry: retry)
CredentialRepository credentialRepository(Ref ref) {
  return CredentialRepository(
    ref.read(credentialStoreProvider),
    ref.read(connectorCredentialRepositoryProvider),
    ref.read(googleNativeAuthRepositoryProvider),
  );
}

class CredentialRepository {
  CredentialRepository(
    this._store,
    this._connectors,
    this._googleAuth,
  );

  final CredentialStore _store;
  final ConnectorCredentialRepository _connectors;
  final GoogleNativeAuthRepository _googleAuth;

  Future<Map<String, String>> readForEnvelopeKeys(List<String> envelopeKeys) {
    return _store.readValues(envelopeKeys);
  }

  Future<Map<String, String>> readForEnvelopeKeysWithConnectors(
    List<String> envelopeKeys, {
    bool interactive = true,
  }) async {
    final values = await readForEnvelopeKeys(envelopeKeys);
    if (envelopeKeys.any((key) => key.startsWith('google.'))) {
      try {
        final googleValues = await _googleAuth.envelopeValuesForEnvelopeKeys(
          envelopeKeys,
          interactive: interactive,
        );
        values.addAll(googleValues);
      } on GoogleAuthorizationInteractionRequired {
        if (!interactive) rethrow;
      }
    }
    final linkedInValues = await _connectors.readEnvelopeValues(
      ConnectorKeys.linkedin,
    );
    for (final entry in linkedInValues.entries) {
      if (envelopeKeys.contains(entry.key) && entry.value.trim().isNotEmpty) {
        values[entry.key] = entry.value;
      }
    }
    return values;
  }

  Future<Map<String, String>> readForPreset(
    PresetDetails preset,
    CredentialPhase phase, {
    bool interactive = true,
  }) async {
    final envelopeKeys = preset.envelopeKeysForPhase(phase);
    return readForEnvelopeKeysWithConnectors(
      envelopeKeys,
      interactive: interactive,
    );
  }

  Future<void> saveDraftValues(Map<String, String> values) {
    return _store.writeValues(values);
  }

  Future<Map<String, String>> readDraftValues(List<String> envelopeKeys) {
    return _store.readValues(envelopeKeys);
  }

  List<String> missingEnvelopeKeys(
    List<String> envelopeKeys,
    Map<String, String> values,
  ) {
    return envelopeKeys
        .where((key) => values[key]?.trim().isEmpty ?? true)
        .toList();
  }
}
