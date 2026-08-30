// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openai_model_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(openAiModelRepository)
final openAiModelRepositoryProvider = OpenAiModelRepositoryProvider._();

final class OpenAiModelRepositoryProvider
    extends
        $FunctionalProvider<
          OpenAiModelRepository,
          OpenAiModelRepository,
          OpenAiModelRepository
        >
    with $Provider<OpenAiModelRepository> {
  OpenAiModelRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'openAiModelRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openAiModelRepositoryHash();

  @$internal
  @override
  $ProviderElement<OpenAiModelRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OpenAiModelRepository create(Ref ref) {
    return openAiModelRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenAiModelRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenAiModelRepository>(value),
    );
  }
}

String _$openAiModelRepositoryHash() =>
    r'60af5b4395c70abe09fe430e5def1a6b34b04edb';
