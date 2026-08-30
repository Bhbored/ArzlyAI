abstract final class ConnectorKeys {
  static const linkedin = 'linkedin';
  static const google = 'google';

  static const all = [linkedin, google];
}

abstract final class LinkedInConnectorFields {
  static const accessToken = 'accessToken';
  static const authorUrn = 'authorUrn';

  static const all = [accessToken, authorUrn];
}

abstract final class GoogleConnectorFields {
  static const accessToken = 'accessToken';
  static const email = 'email';

  static const required = [accessToken];
  static const all = [accessToken, email];
}
