// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countries_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Countries)
final countriesProvider = CountriesProvider._();

final class CountriesProvider
    extends $AsyncNotifierProvider<Countries, List<Country>> {
  CountriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'countriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countriesHash();

  @$internal
  @override
  Countries create() => Countries();
}

String _$countriesHash() => r'0a460848d8037d05d171b08831a5aac2ad605e3d';

abstract class _$Countries extends $AsyncNotifier<List<Country>> {
  FutureOr<List<Country>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Country>>, List<Country>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Country>>, List<Country>>,
              AsyncValue<List<Country>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
