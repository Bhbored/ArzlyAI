// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openai_models_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OpenAiModels)
final openAiModelsProvider = OpenAiModelsProvider._();

final class OpenAiModelsProvider
    extends $AsyncNotifierProvider<OpenAiModels, List<OpenAiModel>> {
  OpenAiModelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'openAiModelsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openAiModelsHash();

  @$internal
  @override
  OpenAiModels create() => OpenAiModels();
}

String _$openAiModelsHash() => r'21ebe52328fdd5169f15c50abdfed86a0b6d54b0';

abstract class _$OpenAiModels extends $AsyncNotifier<List<OpenAiModel>> {
  FutureOr<List<OpenAiModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<OpenAiModel>>, List<OpenAiModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<OpenAiModel>>, List<OpenAiModel>>,
              AsyncValue<List<OpenAiModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
