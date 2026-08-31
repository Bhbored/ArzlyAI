import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/connector_credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_store.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';
import '../storage/device_id_store_test.dart';

void main() {
  late AppDatabase db;
  late MemorySecureStorage storage;
  late ConnectorCredentialRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    storage = MemorySecureStorage();
    repository = ConnectorCredentialRepository(
      CredentialStore(storage),
      legacyDatabase: db,
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('save stores LinkedIn credentials outside SQLite', () async {
    expect(await repository.isConnected(ConnectorKeys.linkedin), isFalse);

    await repository.saveFields(ConnectorKeys.linkedin, {
      LinkedInConnectorFields.accessToken: 'li-token',
      LinkedInConnectorFields.authorUrn: 'urn:li:person:1',
    });

    expect(await repository.isConnected(ConnectorKeys.linkedin), isTrue);
    expect(await repository.readEnvelopeValues(ConnectorKeys.linkedin), {
      integrationFieldEnvelopeKey('linkedin.posts', 'accessToken'): 'li-token',
      integrationFieldEnvelopeKey('linkedin.posts', 'authorUrn'):
          'urn:li:person:1',
    });
    expect(await db.select(db.connectorCredentials).get(), isEmpty);

    await repository.deleteConnector(ConnectorKeys.linkedin);
    expect(await repository.isConnected(ConnectorKeys.linkedin), isFalse);
  });

  test('clearLegacyGoogleCredentials removes stored Google token fields', () async {
    await storage.setValue('connector.gmail.accessToken', 'legacy-token');
    await storage.setValue('connector.gmail.refreshToken', 'legacy-refresh');
    await storage.setValue('connector.gmail.email', 'person@example.com');
    await storage.setValue(
      'connector.gmail.expiresAtUtc',
      '2026-08-31T14:00:00.0000000+00:00',
    );

    await repository.clearLegacyGoogleCredentials();

    expect(storage.values.containsKey('connector.gmail.accessToken'), isFalse);
    expect(storage.values.containsKey('connector.gmail.refreshToken'), isFalse);
    expect(storage.values.containsKey('connector.gmail.email'), isFalse);
  });

  test('read migrates legacy plaintext rows into secure storage', () async {
    await db
        .into(db.connectorCredentials)
        .insert(
          ConnectorCredentialsCompanion.insert(
            connectorKey: ConnectorKeys.linkedin,
            fieldKey: LinkedInConnectorFields.accessToken,
            value: 'legacy-token',
            updatedAtUtc: DateTime.now().toUtc(),
          ),
        );
    await db
        .into(db.connectorCredentials)
        .insert(
          ConnectorCredentialsCompanion.insert(
            connectorKey: ConnectorKeys.linkedin,
            fieldKey: LinkedInConnectorFields.authorUrn,
            value: 'urn:li:person:legacy',
            updatedAtUtc: DateTime.now().toUtc(),
          ),
        );

    expect(await repository.isConnected(ConnectorKeys.linkedin), isTrue);
    expect(storage.values.values, contains('legacy-token'));
    expect(await db.select(db.connectorCredentials).get(), isEmpty);
  });
}
