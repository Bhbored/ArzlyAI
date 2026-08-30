// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(defaultAiModel)
final defaultAiModelProvider = DefaultAiModelProvider._();

final class DefaultAiModelProvider
    extends
        $FunctionalProvider<
          AsyncValue<DefaultAiModel?>,
          DefaultAiModel?,
          FutureOr<DefaultAiModel?>
        >
    with $FutureModifier<DefaultAiModel?>, $FutureProvider<DefaultAiModel?> {
  DefaultAiModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'defaultAiModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultAiModelHash();

  @$internal
  @override
  $FutureProviderElement<DefaultAiModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DefaultAiModel?> create(Ref ref) {
    return defaultAiModel(ref);
  }
}

String _$defaultAiModelHash() => r'8425fb48b27b39d3004810f668c2d7aa4b9f4470';

@ProviderFor(DefaultAiModelController)
final defaultAiModelControllerProvider = DefaultAiModelControllerProvider._();

final class DefaultAiModelControllerProvider
    extends $AsyncNotifierProvider<DefaultAiModelController, DefaultAiModel?> {
  DefaultAiModelControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'defaultAiModelControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultAiModelControllerHash();

  @$internal
  @override
  DefaultAiModelController create() => DefaultAiModelController();
}

String _$defaultAiModelControllerHash() =>
    r'72ab168c83783d12ef70e670cecdc3d2f76afa92';

abstract class _$DefaultAiModelController
    extends $AsyncNotifier<DefaultAiModel?> {
  FutureOr<DefaultAiModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DefaultAiModel?>, DefaultAiModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DefaultAiModel?>, DefaultAiModel?>,
              AsyncValue<DefaultAiModel?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
