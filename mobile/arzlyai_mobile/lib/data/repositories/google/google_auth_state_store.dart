import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_store.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_auth_cache.dart';

class GoogleAuthStateStore {
  GoogleAuthStateStore(this._store);

  static const _emailKey = 'google.auth.accountEmail';
  static const _displayNameKey = 'google.auth.accountDisplayName';
  static const _authorizedConnectorsKey = 'google.auth.authorizedConnectors';

  final CredentialStore _store;

  Future<GoogleAuthCache?> read() async {
    final values = await _store.readValues([
      _emailKey,
      _displayNameKey,
      _authorizedConnectorsKey,
    ]);
    final email = values[_emailKey]?.trim();
    if (email == null || email.isEmpty) return null;
    final authorized = (values[_authorizedConnectorsKey] ?? '')
        .split(',')
        .where(ConnectorKeys.googleConnectors.contains)
        .toSet();
    return GoogleAuthCache(
      accountEmail: email,
      accountDisplayName: values[_displayNameKey],
      authorizedConnectors: authorized,
    );
  }

  Future<void> save(GoogleAuthCache cache) {
    return _store.writeValues({
      _emailKey: cache.accountEmail,
      _displayNameKey: cache.accountDisplayName ?? '',
      _authorizedConnectorsKey: cache.authorizedConnectors.join(','),
    });
  }

  Future<void> clear() async {
    await _store.deleteValue(_emailKey);
    await _store.deleteValue(_displayNameKey);
    await _store.deleteValue(_authorizedConnectorsKey);
  }
}
