// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'internet_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(internetConnectionHelper)
final internetConnectionHelperProvider = InternetConnectionHelperProvider._();

final class InternetConnectionHelperProvider
    extends
        $FunctionalProvider<
          InternetConnectionHelper,
          InternetConnectionHelper,
          InternetConnectionHelper
        >
    with $Provider<InternetConnectionHelper> {
  InternetConnectionHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'internetConnectionHelperProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$internetConnectionHelperHash();

  @$internal
  @override
  $ProviderElement<InternetConnectionHelper> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InternetConnectionHelper create(Ref ref) {
    return internetConnectionHelper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InternetConnectionHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InternetConnectionHelper>(value),
    );
  }
}

String _$internetConnectionHelperHash() =>
    r'e719f22c19fcefe361643cac62ab1190a2d9f436';

@ProviderFor(InternetConnectionNotifier)
final internetConnectionProvider = InternetConnectionNotifierProvider._();

final class InternetConnectionNotifierProvider
    extends $NotifierProvider<InternetConnectionNotifier, bool> {
  InternetConnectionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'internetConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$internetConnectionNotifierHash();

  @$internal
  @override
  InternetConnectionNotifier create() => InternetConnectionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$internetConnectionNotifierHash() =>
    r'f3e9a8ee04737f7914334beca6abc35205422671';

abstract class _$InternetConnectionNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
