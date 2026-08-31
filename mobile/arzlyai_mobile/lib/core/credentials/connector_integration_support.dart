import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';

const integrationConnectorMap = <String, String>{
  'google.sheets.read': ConnectorKeys.googleSheets,
  'google.sheets.report': ConnectorKeys.googleSheets,
  'google.sheets.write': ConnectorKeys.googleSheets,
  'google.gmail.send-html': ConnectorKeys.gmail,
  'google.tasks.create': ConnectorKeys.googleTasks,
  'google.calendar.create-events': ConnectorKeys.googleCalendar,
  'linkedin.posts': ConnectorKeys.linkedin,
};

const connectorIntegrationMap = <String, String>{
  ConnectorKeys.googleSheets: 'google.sheets.read',
  ConnectorKeys.gmail: 'google.gmail.send-html',
  ConnectorKeys.googleTasks: 'google.tasks.create',
  ConnectorKeys.googleCalendar: 'google.calendar.create-events',
  ConnectorKeys.linkedin: 'linkedin.posts',
};

String? connectorKeyForIntegration(String integrationKey) =>
    integrationConnectorMap[integrationKey];

String integrationKeyForConnector(String connectorKey) =>
    connectorIntegrationMap[connectorKey] ??
    (throw ArgumentError('Unsupported connector key: $connectorKey'));

String connectorSettingsLabel(String connectorKey) => switch (connectorKey) {
  ConnectorKeys.linkedin => 'LinkedIn',
  ConnectorKeys.googleSheets => 'Google Sheets',
  ConnectorKeys.gmail => 'Gmail',
  ConnectorKeys.googleTasks => 'Google Tasks',
  ConnectorKeys.googleCalendar => 'Google Calendar',
  _ => connectorKey,
};

String connectorSettingsHint(String connectorKey) => switch (connectorKey) {
  ConnectorKeys.linkedin =>
    'Connect LinkedIn in Settings before you publish.',
  ConnectorKeys.googleSheets =>
    'Connect Google Sheets in Settings before you run receipt presets.',
  ConnectorKeys.gmail =>
    'Connect Gmail in Settings before you enable email delivery.',
  ConnectorKeys.googleTasks =>
    'Connect Google Tasks in Settings before you enable task sync.',
  ConnectorKeys.googleCalendar =>
    'Connect Google Calendar in Settings before you enable calendar sync.',
  _ => 'Add required credentials in Settings before you run this preset.',
};

String integrationSettingsHint(String integrationKey) {
  final connectorKey = connectorKeyForIntegration(integrationKey);
  if (connectorKey == null) {
    return 'Add required credentials in Settings before you run this preset.';
  }
  return connectorSettingsHint(connectorKey);
}

Set<String> connectorKeysForIntegrations(Iterable<String> integrationKeys) {
  return {
    for (final integrationKey in integrationKeys)
      ?connectorKeyForIntegration(integrationKey),
  };
}
