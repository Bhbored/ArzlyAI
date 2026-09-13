import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arzlyai_mobile/core/storage/secure_storage/secure_storage_android.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_store.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_native_auth_adapter.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_native_auth_repository.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_auth_cache.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_auth_state_store.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_sign_in_auth_adapter.dart';

final googleNativeAuthAdapterProvider = Provider<GoogleNativeAuthAdapter>(
  (ref) => GoogleSignInAuthAdapter(),
);

final googleNativeAuthRepositoryProvider = Provider<GoogleNativeAuthRepository>(
  (ref) =>
      GoogleNativeAuthRepository(ref.watch(googleNativeAuthAdapterProvider)),
);

final googleAuthStateStoreProvider = Provider<GoogleAuthStateStore>(
  (ref) => GoogleAuthStateStore(
    CredentialStore(ref.watch(secureStorageAndroidProvider)),
  ),
);

final googleAuthCacheProvider = FutureProvider<GoogleAuthCache?>(
  (ref) => ref.watch(googleAuthStateStoreProvider).read(),
);

class GoogleAuthState {
  const GoogleAuthState({
    this.accountEmail,
    this.accountDisplayName,
    this.authorizedConnectors = const {},
    this.isLoading = false,
    this.isBusy = false,
    this.requiresReconnect = false,
    this.errorMessage,
  });

  const GoogleAuthState.loading()
    : accountEmail = null,
      accountDisplayName = null,
      authorizedConnectors = const {},
      isLoading = true,
      isBusy = false,
      requiresReconnect = false,
      errorMessage = null;

  final String? accountEmail;
  final String? accountDisplayName;
  final Set<String> authorizedConnectors;
  final bool isLoading;
  final bool isBusy;
  final bool requiresReconnect;
  final String? errorMessage;

  bool get isSignedIn => accountEmail?.isNotEmpty ?? false;

  String get accountLabel =>
      accountEmail ?? accountDisplayName ?? 'Not signed in';

  bool isConnectorAuthorized(String connectorKey) =>
      authorizedConnectors.contains(connectorKey);

  GoogleAuthState copyWith({
    String? accountEmail,
    String? accountDisplayName,
    Set<String>? authorizedConnectors,
    bool? isLoading,
    bool? isBusy,
    bool? requiresReconnect,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GoogleAuthState(
      accountEmail: accountEmail ?? this.accountEmail,
      accountDisplayName: accountDisplayName ?? this.accountDisplayName,
      authorizedConnectors: authorizedConnectors ?? this.authorizedConnectors,
      isLoading: isLoading ?? this.isLoading,
      isBusy: isBusy ?? this.isBusy,
      requiresReconnect: requiresReconnect ?? this.requiresReconnect,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class GoogleAuthNotifier extends Notifier<GoogleAuthState> {
  @override
  GoogleAuthState build() => const GoogleAuthState();

  void update(GoogleAuthState next) => state = next;

  void clear() => state = const GoogleAuthState();
}

final googleAuthProvider =
    NotifierProvider<GoogleAuthNotifier, GoogleAuthState>(
      GoogleAuthNotifier.new,
    );
