import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/storage/secure_storage/secure_storage_android.dart';
import 'package:arzlyai_mobile/data/repositories/credential_store.dart';
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
  return CredentialRepository(ref.read(credentialStoreProvider));
}

class CredentialRepository {
  CredentialRepository(this._store);

  final CredentialStore _store;

  Future<Map<String, String>> readForEnvelopeKeys(List<String> envelopeKeys) {
    return _store.readValues(envelopeKeys);
  }

  Future<Map<String, String>> readForPreset(
    PresetDetails preset,
    CredentialPhase phase,
  ) {
    return readForEnvelopeKeys(preset.envelopeKeysForPhase(phase));
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
