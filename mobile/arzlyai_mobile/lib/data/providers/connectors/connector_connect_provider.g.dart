// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_connect_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConnectorConnect)
final connectorConnectProvider = ConnectorConnectFamily._();

final class ConnectorConnectProvider
    extends $AsyncNotifierProvider<ConnectorConnect, void> {
  ConnectorConnectProvider._({
    required ConnectorConnectFamily super.from,
    required String super.argument,
  }) : super(
         retry: retry,
         name: r'connectorConnectProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$connectorConnectHash();

  @override
  String toString() {
    return r'connectorConnectProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ConnectorConnect create() => ConnectorConnect();

  @override
  bool operator ==(Object other) {
    return other is ConnectorConnectProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$connectorConnectHash() => r'00fd609f8e549f0a15a617feb2971a1977217f55';

final class ConnectorConnectFamily extends $Family
    with
        $ClassFamilyOverride<
          ConnectorConnect,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          String
        > {
  ConnectorConnectFamily._()
    : super(
        retry: retry,
        name: r'connectorConnectProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ConnectorConnectProvider call(String connectorKey) =>
      ConnectorConnectProvider._(argument: connectorKey, from: this);

  @override
  String toString() => r'connectorConnectProvider';
}

abstract class _$ConnectorConnect extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as String;
  String get connectorKey => _$args;

  FutureOr<void> build(String connectorKey);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
