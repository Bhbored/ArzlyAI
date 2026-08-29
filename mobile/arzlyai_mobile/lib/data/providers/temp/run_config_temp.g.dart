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
        isAutoDispose: true,
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

String _$runConfigTempHash() => r'367d6177a4c06588eb5dd514301499b1207d21c1';

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
