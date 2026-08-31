import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';

abstract final class GoogleAuthScopes {
  static const spreadsheets = 'https://www.googleapis.com/auth/spreadsheets';
  static const driveMetadataReadonly =
      'https://www.googleapis.com/auth/drive.metadata.readonly';
  static const gmailSend = 'https://www.googleapis.com/auth/gmail.send';
  static const tasks = 'https://www.googleapis.com/auth/tasks';
  static const calendarEvents =
      'https://www.googleapis.com/auth/calendar.events';

  static const sheetsScopes = [spreadsheets, driveMetadataReadonly];
  static const gmailScopes = [gmailSend];
  static const tasksScopes = [tasks];
  static const calendarScopes = [calendarEvents];

  static List<String> scopesForConnector(String connectorKey) =>
      switch (connectorKey) {
        ConnectorKeys.googleSheets => sheetsScopes,
        ConnectorKeys.gmail => gmailScopes,
        ConnectorKeys.googleTasks => tasksScopes,
        ConnectorKeys.googleCalendar => calendarScopes,
        _ => throw ArgumentError('Not a Google connector: $connectorKey'),
      };

  static bool connectorRequiresEmail(String connectorKey) =>
      connectorKey == ConnectorKeys.gmail;
}
