import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/domain/mappers/connectors/connector_credential_mapper.dart';

void main() {
  const mapper = ConnectorCredentialMapper();

  test('localFields maps valid LinkedIn API response', () {
    final fields = mapper.localFields(ConnectorKeys.linkedin, {
      'linkedin.accessToken': 'token',
      'linkedin.authorUrn': 'urn:li:person:1',
    });
    expect(fields, {
      LinkedInConnectorFields.accessToken: 'token',
      LinkedInConnectorFields.authorUrn: 'urn:li:person:1',
    });
  });

  test('localFields rejects partial LinkedIn response', () {
    expect(
      mapper.localFields(ConnectorKeys.linkedin, {
        'linkedin.accessToken': 'token',
      }),
      isNull,
    );
    expect(
      mapper.localFields(ConnectorKeys.linkedin, {
        'linkedin.authorUrn': 'urn:li:person:1',
      }),
      isNull,
    );
  });

  test('localFields maps Google token and optional email', () {
    expect(
      mapper.localFields(ConnectorKeys.google, {
        'google.accessToken': 'google-token',
        'google.email': 'person@example.com',
      }),
      {
        GoogleConnectorFields.accessToken: 'google-token',
        GoogleConnectorFields.email: 'person@example.com',
      },
    );
    expect(
      mapper.localFields(ConnectorKeys.google, {
        'google.email': 'person@example.com',
      }),
      isNull,
    );
  });
}
