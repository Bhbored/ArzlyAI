import 'package:arzlyai_mobile/core/credentials/connector_integration_support.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';

abstract final class ConnectorOAuthConfig {
  static const linkedInRedirectUri = 'arzlyai://oauth/linkedin';
  static const googleSheetsRedirectUri = 'arzlyai://oauth/google-sheets';
  static const gmailRedirectUri = 'arzlyai://oauth/gmail';
  static const googleTasksRedirectUri = 'arzlyai://oauth/google-tasks';
  static const googleCalendarRedirectUri = 'arzlyai://oauth/google-calendar';
  static const callbackScheme = 'arzlyai';
}
