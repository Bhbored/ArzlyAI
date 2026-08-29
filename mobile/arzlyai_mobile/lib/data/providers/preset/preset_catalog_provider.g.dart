// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_catalog_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PresetCatalog)
final presetCatalogProvider = PresetCatalogProvider._();

final class PresetCatalogProvider
    extends $AsyncNotifierProvider<PresetCatalog, List<PresetSummary>> {
  PresetCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'presetCatalogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$presetCatalogHash();

  @$internal
  @override
  PresetCatalog create() => PresetCatalog();
}

String _$presetCatalogHash() => r'25f14b427b62e9407979177867c8cc2c5be7b3a7';

abstract class _$PresetCatalog extends $AsyncNotifier<List<PresetSummary>> {
  FutureOr<List<PresetSummary>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<PresetSummary>>, List<PresetSummary>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PresetSummary>>, List<PresetSummary>>,
              AsyncValue<List<PresetSummary>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
