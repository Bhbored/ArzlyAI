// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countries_catalog_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(countriesCatalogService)
final countriesCatalogServiceProvider = CountriesCatalogServiceProvider._();

final class CountriesCatalogServiceProvider
    extends
        $FunctionalProvider<
          CountriesCatalogService,
          CountriesCatalogService,
          CountriesCatalogService
        >
    with $Provider<CountriesCatalogService> {
  CountriesCatalogServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'countriesCatalogServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countriesCatalogServiceHash();

  @$internal
  @override
  $ProviderElement<CountriesCatalogService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CountriesCatalogService create(Ref ref) {
    return countriesCatalogService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CountriesCatalogService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CountriesCatalogService>(value),
    );
  }
}

String _$countriesCatalogServiceHash() =>
    r'c1318842e22873263f3cbc760010a31ecc8457e6';
