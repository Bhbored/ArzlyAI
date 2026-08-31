import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/core/google/google_auth_exceptions.dart';
import 'package:arzlyai_mobile/core/google/google_auth_scopes.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_native_auth_adapter.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_native_auth_repository.dart';

void main() {
  group('GoogleNativeAuthRepository', () {
    late FakeGoogleNativeAuthAdapter adapter;
    late GoogleNativeAuthRepository repository;

    setUp(() {
      adapter = FakeGoogleNativeAuthAdapter();
      repository = GoogleNativeAuthRepository(adapter);
    });

    test('restoreSilently_WhenAccountExists_RestoresAccount', () async {
      adapter.account = _account('person@example.com');

      await repository.restoreSilently();

      expect(repository.currentAccount?.email, 'person@example.com');
    });

    test('authorizeConnector_WhenInteractiveRequested_GrantsScopes', () async {
      adapter.account = _account('person@example.com');

      await repository.authorizeConnector(ConnectorKeys.googleSheets);

      expect(
        adapter.authorizedScopes,
        containsAll(GoogleAuthScopes.sheetsScopes),
      );
      expect(await repository.isAuthorized(ConnectorKeys.googleSheets), isTrue);
    });

    test('envelopeValuesForConnector_WhenGmailAuthorized_IncludesEmail', () async {
      adapter.account = _account('sender@example.com');
      adapter.grant(ConnectorKeys.gmail);

      final values = await repository.envelopeValuesForConnector(
        ConnectorKeys.gmail,
      );

      expect(values['google.accessToken'], 'token-gmail.send');
      expect(values['google.email'], 'sender@example.com');
    });

    test('envelopeValuesForConnector_WhenSilentAndMissingScopes_Throws', () async {
      adapter.account = _account('person@example.com');

      expect(
        () => repository.envelopeValuesForConnector(
          ConnectorKeys.googleTasks,
          interactive: false,
        ),
        throwsA(isA<GoogleAuthorizationInteractionRequired>()),
      );
    });

    test('disconnect_WhenCalled_ClearsAccountAndScopes', () async {
      adapter.account = _account('person@example.com');
      adapter.grant(ConnectorKeys.googleSheets);

      await repository.disconnect();

      expect(adapter.disconnected, isTrue);
      expect(repository.currentAccount, isNull);
      expect(await repository.isAuthorized(ConnectorKeys.googleSheets), isFalse);
    });
  });
}

GoogleSignInAccount _account(String email) => FakeGoogleSignInAccount(email);

final class FakeGoogleSignInAccount implements GoogleSignInAccount {
  FakeGoogleSignInAccount(this.email);

  @override
  final String email;

  @override
  String get displayName => email;

  @override
  String get id => email;

  @override
  GoogleSignInAuthorizationClient get authorizationClient =>
      FakeGoogleSignInAuthorizationClient(email);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeGoogleSignInAuthorizationClient
    implements GoogleSignInAuthorizationClient {
  FakeGoogleSignInAuthorizationClient(this.email);

  final String email;

  @override
  Future<GoogleSignInClientAuthorization?> authorizationForScopes(
    List<String> scopes,
  ) async {
    final key = FakeGoogleNativeAuthAdapter.scopeKey(scopes);
    if (!FakeGoogleNativeAuthAdapter.authorized.contains(key)) return null;
    return GoogleSignInClientAuthorization(accessToken: 'token-$key');
  }

  @override
  Future<GoogleSignInClientAuthorization> authorizeScopes(
    List<String> scopes,
  ) async {
    final key = FakeGoogleNativeAuthAdapter.scopeKey(scopes);
    FakeGoogleNativeAuthAdapter.authorized.add(key);
    return GoogleSignInClientAuthorization(accessToken: 'token-$key');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeGoogleNativeAuthAdapter implements GoogleNativeAuthAdapter {
  static final authorized = <String>{};

  GoogleSignInAccount? account;
  var disconnected = false;
  final authorizedScopes = <String>[];

  @override
  Future<void> initialize() async {}

  @override
  Future<GoogleSignInAccount?> attemptLightweightAuthentication() async =>
      account;

  @override
  Future<GoogleSignInAccount> authenticate({
    List<String> scopeHint = const [],
  }) async {
    account ??= FakeGoogleSignInAccount('person@example.com');
    return account!;
  }

  @override
  Future<String?> authorizationForScopes(
    GoogleSignInAccount account,
    List<String> scopes,
  ) {
    return account.authorizationClient
        .authorizationForScopes(scopes)
        .then((value) => value?.accessToken);
  }

  @override
  Future<String> authorizeScopes(
    GoogleSignInAccount account,
    List<String> scopes,
  ) async {
    authorizedScopes.addAll(scopes);
    final authorization = await account.authorizationClient.authorizeScopes(
      scopes,
    );
    return authorization.accessToken;
  }

  @override
  Future<void> disconnect() async {
    disconnected = true;
    account = null;
    authorized.clear();
  }

  @override
  String? accountEmail(GoogleSignInAccount account) => account.email;

  @override
  String? accountDisplayName(GoogleSignInAccount account) =>
      account.displayName;

  void grant(String connectorKey) {
    authorized.add(scopeKey(GoogleAuthScopes.scopesForConnector(connectorKey)));
  }

  static String scopeKey(List<String> scopes) =>
      scopes.map((scope) => scope.split('/').last).join('+');
}
