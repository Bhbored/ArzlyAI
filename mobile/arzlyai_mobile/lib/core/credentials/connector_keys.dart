abstract final class ConnectorKeys {
  static const linkedin = 'linkedin';
  static const googleSheets = 'google-sheets';
  static const gmail = 'gmail';
  static const googleTasks = 'google-tasks';
  static const googleCalendar = 'google-calendar';

  static const googleConnectors = [
    googleSheets,
    gmail,
    googleTasks,
    googleCalendar,
  ];

  static const all = [linkedin, ...googleConnectors];
}

abstract final class LinkedInConnectorFields {
  static const accessToken = 'accessToken';
  static const authorUrn = 'authorUrn';

  static const all = [accessToken, authorUrn];
}

abstract final class GoogleOAuthConnectorFields {
  static const accessToken = 'accessToken';
  static const email = 'email';

  static const required = [accessToken];
  static const all = [accessToken, email];
}
