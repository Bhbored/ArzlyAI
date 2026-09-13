abstract final class GoogleAuthConfig {
  static const serverClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue:
        '989009017147-1a88ljaaa8t8dpm19lj0ea13c74fn5j7.apps.googleusercontent.com',
  );

  static const iosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: '',
  );
}
