// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openai_model_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(openAiModelService)
final openAiModelServiceProvider = OpenAiModelServiceProvider._();

final class OpenAiModelServiceProvider
    extends
        $FunctionalProvider<
          OpenAiModelService,
          OpenAiModelService,
          OpenAiModelService
        >
    with $Provider<OpenAiModelService> {
  OpenAiModelServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'openAiModelServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openAiModelServiceHash();

  @$internal
  @override
  $ProviderElement<OpenAiModelService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OpenAiModelService create(Ref ref) {
    return openAiModelService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenAiModelService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenAiModelService>(value),
    );
  }
}

String _$openAiModelServiceHash() =>
    r'2d9f98216b761ab63a8a0aec2e028c2612d56f43';
