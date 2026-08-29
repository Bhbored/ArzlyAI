// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(credentialStore)
final credentialStoreProvider = CredentialStoreProvider._();

final class CredentialStoreProvider
    extends
        $FunctionalProvider<CredentialStore, CredentialStore, CredentialStore>
    with $Provider<CredentialStore> {
  CredentialStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'credentialStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$credentialStoreHash();

  @$internal
  @override
  $ProviderElement<CredentialStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CredentialStore create(Ref ref) {
    return credentialStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CredentialStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CredentialStore>(value),
    );
  }
}

String _$credentialStoreHash() => r'd7fda4b93decceb156674cb2757a026fd289ff99';

@ProviderFor(credentialRepository)
final credentialRepositoryProvider = CredentialRepositoryProvider._();

final class CredentialRepositoryProvider
    extends
        $FunctionalProvider<
          CredentialRepository,
          CredentialRepository,
          CredentialRepository
        >
    with $Provider<CredentialRepository> {
  CredentialRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'credentialRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$credentialRepositoryHash();

  @$internal
  @override
  $ProviderElement<CredentialRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CredentialRepository create(Ref ref) {
    return credentialRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CredentialRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CredentialRepository>(value),
    );
  }
}

String _$credentialRepositoryHash() =>
    r'20057befec89915a48abb564590a60226313f3c6';
