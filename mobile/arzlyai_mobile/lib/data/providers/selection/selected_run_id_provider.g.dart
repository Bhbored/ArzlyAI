// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_run_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedRunId)
final selectedRunIdProvider = SelectedRunIdProvider._();

final class SelectedRunIdProvider
    extends $NotifierProvider<SelectedRunId, String?> {
  SelectedRunIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'selectedRunIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedRunIdHash();

  @$internal
  @override
  SelectedRunId create() => SelectedRunId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedRunIdHash() => r'69ab486d05f207daad8bf1acba13aab453012c66';

abstract class _$SelectedRunId extends $Notifier<String?> {
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
