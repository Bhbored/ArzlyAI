import 'package:google_sign_in/google_sign_in.dart';
import 'package:arzlyai_mobile/core/credentials/connector_integration_support.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
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
    _account = await _adapter.attemptLightweightAuthentication();
  }

  Future<GoogleSignInAccount> ensureSignedIn({bool interactive = true}) async {
    await initialize();
    final current = _account ?? await _adapter.attemptLightweightAuthentication();
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

  Future<bool> isAuthorized(String connectorKey, {bool interactive = false}) async {
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
  }) async {
    _validateGoogleConnector(connectorKey);
    final account = await ensureSignedIn(interactive: interactive);
    final scopes = GoogleAuthScopes.scopesForConnector(connectorKey);
    final accessToken = interactive
        ? await _resolveInteractiveToken(account, scopes)
        : await _resolveSilentToken(account, scopes);
    final integrationKey = integrationKeyForConnector(connectorKey);
    final values = <String, String>{
      integrationFieldEnvelopeKey(
        integrationKey,
        GoogleEnvelopeFields.accessToken,
      ): accessToken,
    };
    if (GoogleAuthScopes.connectorRequiresEmail(connectorKey)) {
      final email = _adapter.accountEmail(account)?.trim();
      if (email == null || email.isEmpty) {
        throw StateError('Google account email is required for Gmail.');
      }
      values[integrationFieldEnvelopeKey(integrationKey, GoogleEnvelopeFields.email)] =
          email;
    }
    return values;
  }

  Future<Map<String, String>> envelopeValuesForEnvelopeKeys(
    List<String> envelopeKeys, {
    bool interactive = true,
  }) async {
    final values = <String, String>{};
    for (final connectorKey in ConnectorKeys.googleConnectors) {
      final integrationKey = integrationKeyForConnector(connectorKey);
      final requiredKeys = _envelopeKeysForConnector(integrationKey, connectorKey);
      if (!requiredKeys.any(envelopeKeys.contains)) continue;
      final connectorValues = await envelopeValuesForConnector(
        connectorKey,
        interactive: interactive,
      );
      for (final entry in connectorValues.entries) {
        if (envelopeKeys.contains(entry.key)) {
          values[entry.key] = entry.value;
        }
      }
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

  List<String> _envelopeKeysForConnector(
    String integrationKey,
    String connectorKey,
  ) {
    final keys = <String>[
      integrationFieldEnvelopeKey(
        integrationKey,
        GoogleEnvelopeFields.accessToken,
      ),
    ];
    if (GoogleAuthScopes.connectorRequiresEmail(connectorKey)) {
      keys.add(
        integrationFieldEnvelopeKey(integrationKey, GoogleEnvelopeFields.email),
      );
    }
    return keys;
  }

  void _validateGoogleConnector(String connectorKey) {
    if (!ConnectorKeys.googleConnectors.contains(connectorKey)) {
      throw ArgumentError('Not a Google connector: $connectorKey');
    }
  }
}
