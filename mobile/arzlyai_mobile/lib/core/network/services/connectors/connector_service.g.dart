// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(connectorService)
final connectorServiceProvider = ConnectorServiceProvider._();

final class ConnectorServiceProvider
    extends
        $FunctionalProvider<
          ConnectorService,
          ConnectorService,
          ConnectorService
        >
    with $Provider<ConnectorService> {
  ConnectorServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'connectorServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectorServiceHash();

  @$internal
  @override
  $ProviderElement<ConnectorService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ConnectorService create(Ref ref) {
    return connectorService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectorService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectorService>(value),
    );
  }
}

String _$connectorServiceHash() => r'2d625dc07718b71726f7b3584c17f34d0d5edbff';
