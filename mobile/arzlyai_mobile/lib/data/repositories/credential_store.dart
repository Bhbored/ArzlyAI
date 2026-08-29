import 'package:arzlyai_mobile/core/storage/secure_storage/secure_storage_android.dart';

class CredentialStore {
  CredentialStore(this._storage);

  final SecureStorageAndroid _storage;

  Future<void> setValue(String envelopeKey, String value) =>
      _storage.setValue(envelopeKey, value);

  Future<String?> getValue(String envelopeKey) => _storage.getValue(envelopeKey);

  Future<void> deleteValue(String envelopeKey) =>
      _storage.deleteValue(envelopeKey);

  Future<Map<String, String>> readValues(List<String> envelopeKeys) async {
    final values = <String, String>{};
    for (final key in envelopeKeys) {
      final value = await getValue(key);
      if (value != null && value.isNotEmpty) {
        values[key] = value;
      }
    }
    return values;
  }

  Future<void> writeValues(Map<String, String> values) async {
    for (final entry in values.entries) {
      final trimmed = entry.value.trim();
      if (trimmed.isEmpty) {
        await deleteValue(entry.key);
      } else {
        await setValue(entry.key, trimmed);
      }
    }
  }
}
