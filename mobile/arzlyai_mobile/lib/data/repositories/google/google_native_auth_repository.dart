import 'package:google_sign_in/google_sign_in.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/core/google/google_auth_exceptions.dart';
import 'package:arzlyai_mobile/core/google/google_auth_scopes.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_native_auth_adapter.dart';

class GoogleNativeAuthRepository {
  GoogleNativeAuthRepository(this._adapter);

  final GoogleNativeAuthAdapter _adapter;
  GoogleSignInAccount? _account;
  var _initialized = false;

  GoogleSignInAccount? get currentAccount => _account;

  Future<void> initialize() async {
    if (_initialized) return;
    await _adapter.initialize();
    _initialized = true;
  }

  Future<void> restoreSilently() async {
    await initialize();
    if (_account != null) return;
    _account = await _adapter.attemptLightweightAuthentication();
  }

  Future<GoogleSignInAccount> ensureSignedIn({bool interactive = true}) async {
    await initialize();
    final current =
        _account ?? await _adapter.attemptLightweightAuthentication();
    if (current != null) {
      _account = current;
      return current;
    }
    if (!interactive) {
      throw const GoogleAuthorizationInteractionRequired();
    }
    final account = await _adapter.authenticate();
    _account = account;
    return account;
  }

  Future<bool> isAuthorized(
    String connectorKey, {
    bool interactive = false,
  }) async {
    _validateGoogleConnector(connectorKey);
    await initialize();
    final account =
        _account ?? await _adapter.attemptLightweightAuthentication();
    if (account == null) return false;
    _account = account;
    final token = await _adapter.authorizationForScopes(
      account,
      GoogleAuthScopes.scopesForConnector(connectorKey),
    );
    return token?.trim().isNotEmpty ?? false;
  }

  Future<void> authorizeConnector(
    String connectorKey, {
    bool interactive = true,
  }) async {
    _validateGoogleConnector(connectorKey);
    final account = await ensureSignedIn(interactive: interactive);
    final scopes = GoogleAuthScopes.scopesForConnector(connectorKey);
    if (interactive) {
      await _adapter.authorizeScopes(account, scopes);
      return;
    }
    final token = await _adapter.authorizationForScopes(account, scopes);
    if (token == null || token.trim().isEmpty) {
      throw const GoogleAuthorizationInteractionRequired();
    }
  }

  Future<Map<String, String>> envelopeValuesForConnector(
    String connectorKey, {
    bool interactive = true,
  }) {
    return envelopeValuesForConnectors([
      connectorKey,
    ], interactive: interactive);
  }

  Future<Map<String, String>> envelopeValuesForConnectors(
    Iterable<String> connectorKeys, {
    bool interactive = true,
  }) async {
    final connectors = connectorKeys.toSet();
    for (final connectorKey in connectors) {
      _validateGoogleConnector(connectorKey);
    }
    if (connectors.isEmpty) return {};
    final account = await ensureSignedIn(interactive: interactive);
    final scopes = connectors
        .expand(GoogleAuthScopes.scopesForConnector)
        .toSet()
        .toList(growable: false);
    final accessToken = interactive
        ? await _resolveInteractiveToken(account, scopes)
        : await _resolveSilentToken(account, scopes);
    final values = <String, String>{
      'google.${GoogleEnvelopeFields.accessToken}': accessToken,
    };
    if (connectors.any(GoogleAuthScopes.connectorRequiresEmail)) {
      final email = _adapter.accountEmail(account)?.trim();
      if (email == null || email.isEmpty) {
        throw StateError('Google account email is required for Gmail.');
      }
      values['google.${GoogleEnvelopeFields.email}'] = email;
    }
    return values;
  }

  Future<void> disconnect() async {
    await initialize();
    await _adapter.disconnect();
    _account = null;
  }

  Future<String> _resolveInteractiveToken(
    GoogleSignInAccount account,
    List<String> scopes,
  ) async {
    final existing = await _adapter.authorizationForScopes(account, scopes);
    if (existing != null && existing.trim().isNotEmpty) return existing;
    return _adapter.authorizeScopes(account, scopes);
  }

  Future<String> _resolveSilentToken(
    GoogleSignInAccount account,
    List<String> scopes,
  ) async {
    final token = await _adapter.authorizationForScopes(account, scopes);
    if (token == null || token.trim().isEmpty) {
      throw const GoogleAuthorizationInteractionRequired();
    }
    return token;
  }

  void _validateGoogleConnector(String connectorKey) {
    if (!ConnectorKeys.googleConnectors.contains(connectorKey)) {
      throw ArgumentError('Not a Google connector: $connectorKey');
    }
  }
}
