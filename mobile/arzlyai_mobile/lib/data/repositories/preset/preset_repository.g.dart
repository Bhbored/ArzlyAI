// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(presetRepository)
final presetRepositoryProvider = PresetRepositoryProvider._();

final class PresetRepositoryProvider
    extends
        $FunctionalProvider<
          PresetRepository,
          PresetRepository,
          PresetRepository
        >
    with $Provider<PresetRepository> {
  PresetRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'presetRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$presetRepositoryHash();

  @$internal
  @override
  $ProviderElement<PresetRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PresetRepository create(Ref ref) {
    return presetRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PresetRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PresetRepository>(value),
    );
  }
}

String _$presetRepositoryHash() => r'b94f4c1762938316d9680a2e4fe7c72b3912c324';
