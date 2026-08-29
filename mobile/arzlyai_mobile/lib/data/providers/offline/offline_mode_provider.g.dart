// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_mode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OfflineMode)
final offlineModeProvider = OfflineModeProvider._();

final class OfflineModeProvider
    extends $AsyncNotifierProvider<OfflineMode, bool> {
  OfflineModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'offlineModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineModeHash();

  @$internal
  @override
  OfflineMode create() => OfflineMode();
}

String _$offlineModeHash() => r'fa4ae988b0222276f08221c5ac222658178101d7';

abstract class _$OfflineMode extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
