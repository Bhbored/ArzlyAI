import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/credentials/connector_integration_support.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';

class ConnectorCredentialMapper {
  const ConnectorCredentialMapper();

  static const linkedInIntegrationKey = 'linkedin.posts';

  Map<String, String>? localFields(
    String connectorKey,
    Map<String, String> apiValues,
  ) {
    if (connectorKey != ConnectorKeys.linkedin) return null;
    final fieldNames = LinkedInConnectorFields.all;
    final integrationKey = integrationKeyForConnector(connectorKey);
    final fields = <String, String>{};
    for (final fieldName in fieldNames) {
      final envelopeKey = integrationFieldEnvelopeKey(
        integrationKey,
        fieldName,
      );
      final value = apiValues[envelopeKey]?.trim() ?? '';
      if (value.isNotEmpty) fields[fieldName] = value;
    }
    if (fieldNames.any((field) => fields[field]?.isEmpty ?? true)) {
      return null;
    }
    return fields;
  }

  String integrationKey(String connectorKey) =>
      integrationKeyForConnector(connectorKey);
}
