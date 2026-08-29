import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';

class ConnectorCredentialMapper {
  const ConnectorCredentialMapper();

  static const linkedInIntegrationKey = 'linkedin.posts';

  Map<String, String>? linkedInEnvelopeValues(Map<String, String> apiValues) {
    final accessTokenKey = integrationFieldEnvelopeKey(
      linkedInIntegrationKey,
      LinkedInConnectorFields.accessToken,
    );
    final authorUrnKey = integrationFieldEnvelopeKey(
      linkedInIntegrationKey,
      LinkedInConnectorFields.authorUrn,
    );
    final accessToken = apiValues[accessTokenKey]?.trim() ?? '';
    final authorUrn = apiValues[authorUrnKey]?.trim() ?? '';
    if (accessToken.isEmpty || authorUrn.isEmpty) return null;
    return {accessTokenKey: accessToken, authorUrnKey: authorUrn};
  }

  Map<String, String> linkedInLocalFields(Map<String, String> envelopeValues) {
    final accessTokenKey = integrationFieldEnvelopeKey(
      linkedInIntegrationKey,
      LinkedInConnectorFields.accessToken,
    );
    final authorUrnKey = integrationFieldEnvelopeKey(
      linkedInIntegrationKey,
      LinkedInConnectorFields.authorUrn,
    );
    return {
      LinkedInConnectorFields.accessToken: envelopeValues[accessTokenKey]!,
      LinkedInConnectorFields.authorUrn: envelopeValues[authorUrnKey]!,
    };
  }
}
