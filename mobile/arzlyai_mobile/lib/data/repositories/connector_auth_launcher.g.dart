// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_auth_launcher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(connectorAuthLauncher)
final connectorAuthLauncherProvider = ConnectorAuthLauncherProvider._();

final class ConnectorAuthLauncherProvider
    extends
        $FunctionalProvider<
          ConnectorAuthLauncher,
          ConnectorAuthLauncher,
          ConnectorAuthLauncher
        >
    with $Provider<ConnectorAuthLauncher> {
  ConnectorAuthLauncherProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'connectorAuthLauncherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectorAuthLauncherHash();

  @$internal
  @override
  $ProviderElement<ConnectorAuthLauncher> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConnectorAuthLauncher create(Ref ref) {
    return connectorAuthLauncher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectorAuthLauncher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectorAuthLauncher>(value),
    );
  }
}

String _$connectorAuthLauncherHash() =>
    r'71ce21c758f9de980238b4686aede63928a3e199';
