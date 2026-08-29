// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferencesHandler)
final sharedPreferencesHandlerProvider = SharedPreferencesHandlerProvider._();

final class SharedPreferencesHandlerProvider
    extends
        $FunctionalProvider<
          SharedPreferencesHandler,
          SharedPreferencesHandler,
          SharedPreferencesHandler
        >
    with $Provider<SharedPreferencesHandler> {
  SharedPreferencesHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'sharedPreferencesHandlerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHandlerHash();

  @$internal
  @override
  $ProviderElement<SharedPreferencesHandler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferencesHandler create(Ref ref) {
    return sharedPreferencesHandler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferencesHandler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferencesHandler>(value),
    );
  }
}

String _$sharedPreferencesHandlerHash() =>
    r'4a3c4a33db35f1340edfa1d0485567aefa176c23';
