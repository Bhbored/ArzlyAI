// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(connectorRepository)
final connectorRepositoryProvider = ConnectorRepositoryProvider._();

final class ConnectorRepositoryProvider
    extends
        $FunctionalProvider<
          ConnectorRepository,
          ConnectorRepository,
          ConnectorRepository
        >
    with $Provider<ConnectorRepository> {
  ConnectorRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'connectorRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectorRepositoryHash();

  @$internal
  @override
  $ProviderElement<ConnectorRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConnectorRepository create(Ref ref) {
    return connectorRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectorRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectorRepository>(value),
    );
  }
}

String _$connectorRepositoryHash() =>
    r'8a38c9b52f800b0b85ecc80f9a845bd6e26502ad';
