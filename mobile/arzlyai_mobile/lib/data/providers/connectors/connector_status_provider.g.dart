// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    r'da552094a89c9578f99b144cc19429597034d5a4';

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
