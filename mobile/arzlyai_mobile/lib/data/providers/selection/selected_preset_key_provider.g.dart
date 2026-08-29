// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_preset_key_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedPresetKey)
final selectedPresetKeyProvider = SelectedPresetKeyProvider._();

final class SelectedPresetKeyProvider
    extends $NotifierProvider<SelectedPresetKey, String?> {
  SelectedPresetKeyProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'selectedPresetKeyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedPresetKeyHash();

  @$internal
  @override
  SelectedPresetKey create() => SelectedPresetKey();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedPresetKeyHash() => r'c1e2a932a2c88a9a2659a5ff8bb1786197b44350';

abstract class _$SelectedPresetKey extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
