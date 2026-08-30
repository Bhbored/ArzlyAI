// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_model_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(providerModelService)
final providerModelServiceProvider = ProviderModelServiceProvider._();

final class ProviderModelServiceProvider
    extends
        $FunctionalProvider<
          ProviderModelService,
          ProviderModelService,
          ProviderModelService
        >
    with $Provider<ProviderModelService> {
  ProviderModelServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'providerModelServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$providerModelServiceHash();

  @$internal
  @override
  $ProviderElement<ProviderModelService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProviderModelService create(Ref ref) {
    return providerModelService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProviderModelService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProviderModelService>(value),
    );
  }
}

String _$providerModelServiceHash() =>
    r'fa43218a54994994ff9b4501a604d0d19e1aedb9';
