import 'package:google_sign_in/google_sign_in.dart';

abstract class GoogleNativeAuthAdapter {
  Future<void> initialize();

  Future<GoogleSignInAccount?> attemptLightweightAuthentication();

  Future<GoogleSignInAccount> authenticate({List<String> scopeHint = const []});

  Future<String?> authorizationForScopes(
    GoogleSignInAccount account,
    List<String> scopes,
  );

  Future<String> authorizeScopes(
    GoogleSignInAccount account,
    List<String> scopes,
  );

  Future<void> disconnect();

  String? accountEmail(GoogleSignInAccount account);

  String? accountDisplayName(GoogleSignInAccount account);
}
