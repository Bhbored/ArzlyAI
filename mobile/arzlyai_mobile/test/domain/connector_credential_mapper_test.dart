import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/domain/mappers/connectors/connector_credential_mapper.dart';

void main() {
  const mapper = ConnectorCredentialMapper();

  test('linkedInEnvelopeValues maps valid API response', () {
    final envelope = mapper.linkedInEnvelopeValues({
      'linkedin.accessToken': 'token',
      'linkedin.authorUrn': 'urn:li:person:1',
    });
    expect(envelope, {
      'linkedin.accessToken': 'token',
      'linkedin.authorUrn': 'urn:li:person:1',
    });
    expect(mapper.linkedInLocalFields(envelope!), {
      LinkedInConnectorFields.accessToken: 'token',
      LinkedInConnectorFields.authorUrn: 'urn:li:person:1',
    });
  });

  test('linkedInEnvelopeValues rejects partial response', () {
    expect(
      mapper.linkedInEnvelopeValues({'linkedin.accessToken': 'token'}),
      isNull,
    );
    expect(
      mapper.linkedInEnvelopeValues({'linkedin.authorUrn': 'urn:li:person:1'}),
      isNull,
    );
  });
}
