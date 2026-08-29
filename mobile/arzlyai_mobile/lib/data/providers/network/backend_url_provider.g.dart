// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend_url_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BackendUrl)
final backendUrlProvider = BackendUrlProvider._();

final class BackendUrlProvider
    extends $AsyncNotifierProvider<BackendUrl, String> {
  BackendUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'backendUrlProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backendUrlHash();

  @$internal
  @override
  BackendUrl create() => BackendUrl();
}

String _$backendUrlHash() => r'e0c9f1270b56bd7d8ef29a7f9865c11e72221c5d';

abstract class _$BackendUrl extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
