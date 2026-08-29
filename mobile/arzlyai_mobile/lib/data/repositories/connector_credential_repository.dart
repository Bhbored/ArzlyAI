import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

part 'connector_credential_repository.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
ConnectorCredentialRepository connectorCredentialRepository(Ref ref) {
  return ConnectorCredentialRepository(ref.watch(appDatabaseProvider));
}

class ConnectorCredentialRepository {
  ConnectorCredentialRepository(this._db);

  final AppDatabase _db;

  Future<bool> isConnected(String connectorKey) async {
    final fields = await _readFields(connectorKey);
    return _requiredFieldsFor(
      connectorKey,
    ).every((field) => fields[field]?.trim().isNotEmpty ?? false);
  }

  Future<Map<String, String>> readEnvelopeValues(String connectorKey) async {
    final fields = await _readFields(connectorKey);
    if (connectorKey == ConnectorKeys.linkedin) {
      return {
        integrationFieldEnvelopeKey(
          'linkedin.posts',
          LinkedInConnectorFields.accessToken,
        ): fields[LinkedInConnectorFields.accessToken] ?? '',
        integrationFieldEnvelopeKey(
          'linkedin.posts',
          LinkedInConnectorFields.authorUrn,
        ): fields[LinkedInConnectorFields.authorUrn] ?? '',
      };
    }
    return {};
  }

  Future<void> saveFields(
    String connectorKey,
    Map<String, String> fields,
  ) async {
    final now = DateTime.now().toUtc();
    await _db.batch((batch) {
      for (final entry in fields.entries) {
        final trimmed = entry.value.trim();
        if (trimmed.isEmpty) continue;
        batch.insert(
          _db.connectorCredentials,
          ConnectorCredentialsCompanion.insert(
            connectorKey: connectorKey,
            fieldKey: entry.key,
            value: trimmed,
            updatedAtUtc: now,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<void> deleteConnector(String connectorKey) async {
    await (_db.delete(
      _db.connectorCredentials,
    )..where((row) => row.connectorKey.equals(connectorKey))).go();
  }

  Future<Map<String, String>> _readFields(String connectorKey) async {
    final rows = await (_db.select(
      _db.connectorCredentials,
    )..where((row) => row.connectorKey.equals(connectorKey))).get();
    return {for (final row in rows) row.fieldKey: row.value};
  }

  List<String> _requiredFieldsFor(String connectorKey) {
    if (connectorKey == ConnectorKeys.linkedin) {
      return LinkedInConnectorFields.all;
    }
    return [];
  }
}
