// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(presetService)
final presetServiceProvider = PresetServiceProvider._();

final class PresetServiceProvider
    extends $FunctionalProvider<PresetService, PresetService, PresetService>
    with $Provider<PresetService> {
  PresetServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'presetServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$presetServiceHash();

  @$internal
  @override
  $ProviderElement<PresetService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PresetService create(Ref ref) {
    return presetService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PresetService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PresetService>(value),
    );
  }
}

String _$presetServiceHash() => r'891e1a4e8586e91664a2a7db55b71c500c1bf27a';
