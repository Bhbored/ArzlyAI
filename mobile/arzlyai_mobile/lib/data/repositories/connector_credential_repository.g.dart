// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_credential_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(connectorCredentialRepository)
final connectorCredentialRepositoryProvider =
    ConnectorCredentialRepositoryProvider._();

final class ConnectorCredentialRepositoryProvider
    extends
        $FunctionalProvider<
          ConnectorCredentialRepository,
          ConnectorCredentialRepository,
          ConnectorCredentialRepository
        >
    with $Provider<ConnectorCredentialRepository> {
  ConnectorCredentialRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'connectorCredentialRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectorCredentialRepositoryHash();

  @$internal
  @override
  $ProviderElement<ConnectorCredentialRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConnectorCredentialRepository create(Ref ref) {
    return connectorCredentialRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectorCredentialRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectorCredentialRepository>(
        value,
      ),
    );
  }
}

String _$connectorCredentialRepositoryHash() =>
    r'a62fc7b23cf6f70daba8ddaecfc4a4726ca02d31';
