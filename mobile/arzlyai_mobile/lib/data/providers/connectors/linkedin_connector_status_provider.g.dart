// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linkedin_connector_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(linkedInConnectorStatus)
final linkedInConnectorStatusProvider = LinkedInConnectorStatusProvider._();

final class LinkedInConnectorStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  LinkedInConnectorStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'linkedInConnectorStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkedInConnectorStatusHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return linkedInConnectorStatus(ref);
  }
}

String _$linkedInConnectorStatusHash() =>
    r'c3735de17fa3157db0fe9dd6e9c30c1ad7f86297';
