import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/connector_credential_repository.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

void main() {
  late AppDatabase db;
  late ConnectorCredentialRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ConnectorCredentialRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('save isConnected readEnvelopeValues delete', () async {
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

    await repository.deleteConnector(ConnectorKeys.linkedin);
    expect(await repository.isConnected(ConnectorKeys.linkedin), isFalse);
  });
}
