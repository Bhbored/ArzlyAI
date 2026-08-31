// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_config_temp.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RunConfigTemp)
final runConfigTempProvider = RunConfigTempProvider._();

final class RunConfigTempProvider
    extends $NotifierProvider<RunConfigTemp, RunConfigState> {
  RunConfigTempProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runConfigTempProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runConfigTempHash();

  @$internal
  @override
  RunConfigTemp create() => RunConfigTemp();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RunConfigState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RunConfigState>(value),
    );
  }
}

String _$runConfigTempHash() => r'e75be5d102ca13d6cabf9c0a3b023a63567222b5';

abstract class _$RunConfigTemp extends $Notifier<RunConfigState> {
  RunConfigState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RunConfigState, RunConfigState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RunConfigState, RunConfigState>,
              RunConfigState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
