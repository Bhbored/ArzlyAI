import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/credentials/connector_integration_support.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_store.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

part 'connector_credential_repository.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
ConnectorCredentialRepository connectorCredentialRepository(Ref ref) {
  return ConnectorCredentialRepository(
    ref.watch(credentialStoreProvider),
    legacyDatabase: ref.watch(appDatabaseProvider),
  );
}

class ConnectorCredentialRepository {
  ConnectorCredentialRepository(this._store, {AppDatabase? legacyDatabase})
    : _legacyDatabase = legacyDatabase;

  final CredentialStore _store;
  final AppDatabase? _legacyDatabase;

  Future<bool> isConnected(String connectorKey) async {
    final fields = await _readFields(connectorKey);
    return _requiredFieldsFor(
      connectorKey,
    ).every((field) => fields[field]?.trim().isNotEmpty ?? false);
  }

  Future<Map<String, String>> readFields(String connectorKey) =>
      _readFields(connectorKey);

  Future<Map<String, String>> readEnvelopeValues(String connectorKey) async {
    final fields = await _readFields(connectorKey);
    final integrationKey = integrationKeyForConnector(connectorKey);
    return {
      for (final field in _allFieldsFor(connectorKey))
        if (fields[field]?.trim().isNotEmpty ?? false)
          integrationFieldEnvelopeKey(integrationKey, field): fields[field]!,
    };
  }

  Future<void> saveFields(
    String connectorKey,
    Map<String, String> fields,
  ) async {
    await _store.writeValues({
      for (final entry in fields.entries)
        _storageKey(connectorKey, entry.key): entry.value,
    });
    final saved = await _readSecureFields(connectorKey);
    if (_requiredFieldsFor(
      connectorKey,
    ).any((field) => saved[field]?.trim().isEmpty ?? true)) {
      throw StateError('Connector credentials could not be stored securely.');
    }
    await _deleteLegacyConnector(connectorKey);
  }

  Future<void> deleteConnector(String connectorKey) async {
    for (final field in _allFieldsFor(connectorKey)) {
      await _store.deleteValue(_storageKey(connectorKey, field));
    }
    await _deleteLegacyConnector(connectorKey);
  }

  Future<void> clearLegacyGoogleCredentials() async {
    const legacyFields = [
      ...GoogleEnvelopeFields.all,
      'refreshToken',
      'expiresAtUtc',
    ];
    for (final connectorKey in ConnectorKeys.googleConnectors) {
      for (final field in legacyFields) {
        await _store.deleteValue(_storageKey(connectorKey, field));
      }
      await _deleteLegacyConnector(connectorKey);
    }
  }

  Future<Map<String, String>> _readFields(String connectorKey) async {
    final secureFields = await _readSecureFields(connectorKey);
    if (_requiredFieldsFor(
      connectorKey,
    ).every((field) => secureFields[field]?.trim().isNotEmpty ?? false)) {
      return secureFields;
    }
    final legacyFields = await _readLegacyFields(connectorKey);
    if (legacyFields.isEmpty) return secureFields;
    await saveFields(connectorKey, legacyFields);
    return _readSecureFields(connectorKey);
  }

  Future<Map<String, String>> _readSecureFields(String connectorKey) async {
    final values = await _store.readValues([
      for (final field in _allFieldsFor(connectorKey))
        _storageKey(connectorKey, field),
    ]);
    final fields = <String, String>{};
    for (final field in _allFieldsFor(connectorKey)) {
      final value = values[_storageKey(connectorKey, field)];
      if (value != null) fields[field] = value;
    }
    return fields;
  }

  Future<Map<String, String>> _readLegacyFields(String connectorKey) async {
    final db = _legacyDatabase;
    if (db == null) return {};
    final rows = await (db.select(
      db.connectorCredentials,
    )..where((row) => row.connectorKey.equals(connectorKey))).get();
    return {for (final row in rows) row.fieldKey: row.value};
  }

  Future<void> _deleteLegacyConnector(String connectorKey) async {
    final db = _legacyDatabase;
    if (db == null) return;
    await (db.delete(
      db.connectorCredentials,
    )..where((row) => row.connectorKey.equals(connectorKey))).go();
  }

  List<String> _requiredFieldsFor(String connectorKey) {
    return switch (connectorKey) {
      ConnectorKeys.linkedin => LinkedInConnectorFields.all,
      _ => throw ArgumentError(
        'Unsupported connector key for local storage: $connectorKey',
      ),
    };
  }

  List<String> _allFieldsFor(String connectorKey) => switch (connectorKey) {
    ConnectorKeys.linkedin => LinkedInConnectorFields.all,
    _ => throw ArgumentError(
      'Unsupported connector key for local storage: $connectorKey',
    ),
  };

  String _storageKey(String connectorKey, String field) =>
      'connector.$connectorKey.$field';
}
