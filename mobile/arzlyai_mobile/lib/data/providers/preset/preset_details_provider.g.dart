// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PresetDetailsNotifier)
final presetDetailsProvider = PresetDetailsNotifierProvider._();

final class PresetDetailsNotifierProvider
    extends $AsyncNotifierProvider<PresetDetailsNotifier, PresetDetails?> {
  PresetDetailsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'presetDetailsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$presetDetailsNotifierHash();

  @$internal
  @override
  PresetDetailsNotifier create() => PresetDetailsNotifier();
}

String _$presetDetailsNotifierHash() =>
    r'9191a7c5b2f8f3c49b70f9f00d1dd3fb554b2a04';

abstract class _$PresetDetailsNotifier extends $AsyncNotifier<PresetDetails?> {
  FutureOr<PresetDetails?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PresetDetails?>, PresetDetails?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PresetDetails?>, PresetDetails?>,
              AsyncValue<PresetDetails?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
