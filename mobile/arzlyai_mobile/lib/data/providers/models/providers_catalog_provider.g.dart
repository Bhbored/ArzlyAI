// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_catalog_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(providersCatalog)
final providersCatalogProvider = ProvidersCatalogProvider._();

final class ProvidersCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProviderResponse>>,
          List<ProviderResponse>,
          FutureOr<List<ProviderResponse>>
        >
    with
        $FutureModifier<List<ProviderResponse>>,
        $FutureProvider<List<ProviderResponse>> {
  ProvidersCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'providersCatalogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$providersCatalogHash();

  @$internal
  @override
  $FutureProviderElement<List<ProviderResponse>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProviderResponse>> create(Ref ref) {
    return providersCatalog(ref);
  }
}

String _$providersCatalogHash() => r'591d52df29199b8255f28601dd3933e1259da64d';
