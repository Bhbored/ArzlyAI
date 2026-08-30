// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(countryRepository)
final countryRepositoryProvider = CountryRepositoryProvider._();

final class CountryRepositoryProvider
    extends
        $FunctionalProvider<
          CountryRepository,
          CountryRepository,
          CountryRepository
        >
    with $Provider<CountryRepository> {
  CountryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'countryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CountryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CountryRepository create(Ref ref) {
    return countryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CountryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CountryRepository>(value),
    );
  }
}

String _$countryRepositoryHash() => r'10aefbd048f6667569a8eef0915809428d1611f0';
