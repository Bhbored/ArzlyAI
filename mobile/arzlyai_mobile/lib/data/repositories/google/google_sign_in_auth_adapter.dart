import 'package:google_sign_in/google_sign_in.dart';
import 'package:arzlyai_mobile/core/google/google_auth_config.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_native_auth_adapter.dart';

class GoogleSignInAuthAdapter implements GoogleNativeAuthAdapter {
  GoogleSignIn get _signIn => GoogleSignIn.instance;

  @override
  Future<void> initialize() async {
    await _signIn.initialize(
      clientId: GoogleAuthConfig.iosClientId.isEmpty
          ? null
          : GoogleAuthConfig.iosClientId,
      serverClientId: GoogleAuthConfig.serverClientId.isEmpty
          ? null
          : GoogleAuthConfig.serverClientId,
    );
  }

  @override
  Future<GoogleSignInAccount?> attemptLightweightAuthentication() {
    return _signIn.attemptLightweightAuthentication() ??
        Future<GoogleSignInAccount?>.value();
  }

  @override
  Future<GoogleSignInAccount> authenticate({
    List<String> scopeHint = const [],
  }) {
    return _signIn.authenticate(scopeHint: scopeHint);
  }

  @override
  Future<String?> authorizationForScopes(
    GoogleSignInAccount account,
    List<String> scopes,
  ) async {
    final authorization = await account.authorizationClient
        .authorizationForScopes(scopes);
    return authorization?.accessToken;
  }

  @override
  Future<String> authorizeScopes(
    GoogleSignInAccount account,
    List<String> scopes,
  ) async {
    final authorization = await account.authorizationClient.authorizeScopes(
      scopes,
    );
    return authorization.accessToken;
  }

  @override
  Future<void> disconnect() => _signIn.disconnect();

  @override
  String? accountEmail(GoogleSignInAccount account) => account.email;

  @override
  String? accountDisplayName(GoogleSignInAccount account) => account.displayName;
}
