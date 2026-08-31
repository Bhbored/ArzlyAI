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
    final fieldNames = _allFieldsFor(connectorKey);
    final requiredFields = _requiredFieldsFor(connectorKey);
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
    if (requiredFields.any((field) => fields[field]?.isEmpty ?? true)) {
      return null;
    }
    return fields;
  }

  String integrationKey(String connectorKey) =>
      integrationKeyForConnector(connectorKey);

  List<String> _requiredFieldsFor(String connectorKey) => switch (connectorKey) {
    ConnectorKeys.linkedin => LinkedInConnectorFields.all,
    ConnectorKeys.googleSheets ||
    ConnectorKeys.gmail ||
    ConnectorKeys.googleTasks ||
    ConnectorKeys.googleCalendar => GoogleOAuthConnectorFields.required,
    _ => const <String>[],
  };

  List<String> _allFieldsFor(String connectorKey) => switch (connectorKey) {
    ConnectorKeys.linkedin => LinkedInConnectorFields.all,
    ConnectorKeys.googleSheets ||
    ConnectorKeys.gmail ||
    ConnectorKeys.googleTasks ||
    ConnectorKeys.googleCalendar => GoogleOAuthConnectorFields.all,
    _ => throw ArgumentError('Unsupported connector key: $connectorKey'),
  };
}
