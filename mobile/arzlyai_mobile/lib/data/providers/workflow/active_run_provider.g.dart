// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_run_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveRun)
final activeRunProvider = ActiveRunProvider._();

final class ActiveRunProvider
    extends $AsyncNotifierProvider<ActiveRun, WorkflowRun?> {
  ActiveRunProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'activeRunProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeRunHash();

  @$internal
  @override
  ActiveRun create() => ActiveRun();
}

String _$activeRunHash() => r'5a152bfcf688e1bf85f4adb2377113de5e6450c7';

abstract class _$ActiveRun extends $AsyncNotifier<WorkflowRun?> {
  FutureOr<WorkflowRun?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WorkflowRun?>, WorkflowRun?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WorkflowRun?>, WorkflowRun?>,
              AsyncValue<WorkflowRun?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
