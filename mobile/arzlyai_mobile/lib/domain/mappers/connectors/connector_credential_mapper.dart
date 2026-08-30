import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';

class ConnectorCredentialMapper {
  const ConnectorCredentialMapper();

  static const linkedInIntegrationKey = 'linkedin.posts';
  static const googleIntegrationKey = 'google';

  Map<String, String>? localFields(
    String connectorKey,
    Map<String, String> apiValues,
  ) {
    final fieldNames = switch (connectorKey) {
      ConnectorKeys.linkedin => LinkedInConnectorFields.all,
      ConnectorKeys.google => GoogleConnectorFields.all,
      _ => throw ArgumentError('Unsupported connector key: $connectorKey'),
    };
    final requiredFields = switch (connectorKey) {
      ConnectorKeys.linkedin => LinkedInConnectorFields.all,
      ConnectorKeys.google => GoogleConnectorFields.required,
      _ => const <String>[],
    };
    final integrationKey = switch (connectorKey) {
      ConnectorKeys.linkedin => linkedInIntegrationKey,
      ConnectorKeys.google => googleIntegrationKey,
      _ => connectorKey,
    };
    final fields = <String, String>{};
    for (final fieldName in fieldNames) {
      final envelopeKey = integrationFieldEnvelopeKey(
        integrationKey,
        fieldName,
      );
      final value = apiValues[envelopeKey]?.trim() ?? '';
      if (value.isNotEmpty) fields[fieldName] = value;
    }
    if (requiredFields.any((field) => fields[field]?.isEmpty ?? true)) {
      return null;
    }
    return fields;
  }

  String integrationKey(String connectorKey) {
    return switch (connectorKey) {
      ConnectorKeys.linkedin => linkedInIntegrationKey,
      ConnectorKeys.google => googleIntegrationKey,
      _ => throw ArgumentError('Unsupported connector key: $connectorKey'),
    };
  }
}
