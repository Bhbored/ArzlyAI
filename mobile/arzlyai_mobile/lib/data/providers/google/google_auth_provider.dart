import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_native_auth_adapter.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_native_auth_repository.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_sign_in_auth_adapter.dart';

final googleNativeAuthAdapterProvider = Provider<GoogleNativeAuthAdapter>(
  (ref) => GoogleSignInAuthAdapter(),
);

final googleNativeAuthRepositoryProvider = Provider<GoogleNativeAuthRepository>(
  (ref) => GoogleNativeAuthRepository(ref.watch(googleNativeAuthAdapterProvider)),
);

class GoogleAuthState {
  const GoogleAuthState({
    this.account,
    this.authorizedConnectors = const {},
    this.isLoading = false,
    this.isBusy = false,
    this.errorMessage,
  });

  const GoogleAuthState.loading()
      : account = null,
        authorizedConnectors = const {},
        isLoading = true,
        isBusy = false,
        errorMessage = null;

  final GoogleSignInAccount? account;
  final Set<String> authorizedConnectors;
  final bool isLoading;
  final bool isBusy;
  final String? errorMessage;

  bool get isSignedIn => account != null;

  bool isConnectorAuthorized(String connectorKey) =>
      authorizedConnectors.contains(connectorKey);

  GoogleAuthState copyWith({
    GoogleSignInAccount? account,
    Set<String>? authorizedConnectors,
    bool? isLoading,
    bool? isBusy,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GoogleAuthState(
      account: account ?? this.account,
      authorizedConnectors: authorizedConnectors ?? this.authorizedConnectors,
      isLoading: isLoading ?? this.isLoading,
      isBusy: isBusy ?? this.isBusy,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class GoogleAuthNotifier extends Notifier<GoogleAuthState> {
  @override
  GoogleAuthState build() {
    Future<void>.microtask(refresh);
    return const GoogleAuthState.loading();
  }

  GoogleNativeAuthRepository get _repository =>
      ref.read(googleNativeAuthRepositoryProvider);

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.restoreSilently();
      final account = _repository.currentAccount;
      final authorized = <String>{};
      for (final connectorKey in ConnectorKeys.googleConnectors) {
        if (await _repository.isAuthorized(connectorKey)) {
          authorized.add(connectorKey);
        }
      }
      state = GoogleAuthState(
        account: account,
        authorizedConnectors: authorized,
      );
    } catch (error) {
      state = GoogleAuthState(errorMessage: _messageFor(error));
    }
  }

  Future<void> signIn() async {
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      await _repository.ensureSignedIn();
      await refresh();
    } catch (error) {
      state = state.copyWith(isBusy: false, errorMessage: _messageFor(error));
    }
  }

  Future<void> authorizeService(String connectorKey) async {
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      await _repository.authorizeConnector(connectorKey);
      await refresh();
    } catch (error) {
      state = state.copyWith(isBusy: false, errorMessage: _messageFor(error));
    }
  }

  Future<void> disconnect() async {
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      await _repository.disconnect();
      state = const GoogleAuthState();
    } catch (error) {
      state = state.copyWith(isBusy: false, errorMessage: _messageFor(error));
    }
  }

  String _messageFor(Object error) {
    if (error is GoogleSignInException) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return 'Google authorization was cancelled.';
      }
      return error.description ?? 'Google authorization failed.';
    }
    return error.toString();
  }
}

final googleAuthProvider =
    NotifierProvider<GoogleAuthNotifier, GoogleAuthState>(GoogleAuthNotifier.new);
