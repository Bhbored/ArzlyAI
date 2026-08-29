// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(connectorRemoteStatus)
final connectorRemoteStatusProvider = ConnectorRemoteStatusFamily._();

final class ConnectorRemoteStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<ConnectorStatus>,
          ConnectorStatus,
          FutureOr<ConnectorStatus>
        >
    with $FutureModifier<ConnectorStatus>, $FutureProvider<ConnectorStatus> {
  ConnectorRemoteStatusProvider._({
    required ConnectorRemoteStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: retry,
         name: r'connectorRemoteStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$connectorRemoteStatusHash();

  @override
  String toString() {
    return r'connectorRemoteStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ConnectorStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ConnectorStatus> create(Ref ref) {
    final argument = this.argument as String;
    return connectorRemoteStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ConnectorRemoteStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$connectorRemoteStatusHash() =>
    r'df1aadd30759d4274fc6713d2ccf2e97c5b49338';

final class ConnectorRemoteStatusFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ConnectorStatus>, String> {
  ConnectorRemoteStatusFamily._()
    : super(
        retry: retry,
        name: r'connectorRemoteStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ConnectorRemoteStatusProvider call(String connectorKey) =>
      ConnectorRemoteStatusProvider._(argument: connectorKey, from: this);

  @override
  String toString() => r'connectorRemoteStatusProvider';
}

@ProviderFor(connectorLocalStatus)
final connectorLocalStatusProvider = ConnectorLocalStatusFamily._();

final class ConnectorLocalStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  ConnectorLocalStatusProvider._({
    required ConnectorLocalStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: retry,
         name: r'connectorLocalStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$connectorLocalStatusHash();

  @override
  String toString() {
    return r'connectorLocalStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return connectorLocalStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ConnectorLocalStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$connectorLocalStatusHash() =>
    r'389b549d2b3da5a7fd753c7f4a16ac55db66858c';

final class ConnectorLocalStatusFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  ConnectorLocalStatusFamily._()
    : super(
        retry: retry,
        name: r'connectorLocalStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ConnectorLocalStatusProvider call(String connectorKey) =>
      ConnectorLocalStatusProvider._(argument: connectorKey, from: this);

  @override
  String toString() => r'connectorLocalStatusProvider';
}
