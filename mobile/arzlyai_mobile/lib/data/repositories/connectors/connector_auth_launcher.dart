import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/credentials/connector_oauth_config.dart';

part 'connector_auth_launcher.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
ConnectorAuthLauncher connectorAuthLauncher(Ref ref) {
  return ConnectorAuthLauncher();
}

class ConnectorAuthLauncher {
  Future<void> launchConnect(String connectorKey, String connectUrl) async {
    final callback = await FlutterWebAuth2.authenticate(
      url: connectUrl,
      callbackUrlScheme: ConnectorOAuthConfig.callbackScheme,
    );
    final callbackUri = Uri.parse(callback);
    final error = callbackUri.queryParameters['error'];
    if (error != null && error.isNotEmpty) {
      throw StateError('$connectorKey authorization failed.');
    }
  }
}
