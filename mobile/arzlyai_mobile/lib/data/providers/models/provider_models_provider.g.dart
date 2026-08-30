// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_models_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AvailableProviderModels)
final availableProviderModelsProvider = AvailableProviderModelsProvider._();

final class AvailableProviderModelsProvider
    extends
        $AsyncNotifierProvider<AvailableProviderModels, List<ProviderModel>> {
  AvailableProviderModelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'availableProviderModelsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableProviderModelsHash();

  @$internal
  @override
  AvailableProviderModels create() => AvailableProviderModels();
}

String _$availableProviderModelsHash() =>
    r'cf4828cd9782fd37120a8b0b181925d703decc75';

abstract class _$AvailableProviderModels
    extends $AsyncNotifier<List<ProviderModel>> {
  FutureOr<List<ProviderModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ProviderModel>>, List<ProviderModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ProviderModel>>, List<ProviderModel>>,
              AsyncValue<List<ProviderModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
