// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_storage_android.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(secureStorageAndroid)
final secureStorageAndroidProvider = SecureStorageAndroidProvider._();

final class SecureStorageAndroidProvider
    extends
        $FunctionalProvider<
          SecureStorageAndroid,
          SecureStorageAndroid,
          SecureStorageAndroid
        >
    with $Provider<SecureStorageAndroid> {
  SecureStorageAndroidProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageAndroidProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageAndroidHash();

  @$internal
  @override
  $ProviderElement<SecureStorageAndroid> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SecureStorageAndroid create(Ref ref) {
    return secureStorageAndroid(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureStorageAndroid value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureStorageAndroid>(value),
    );
  }
}

String _$secureStorageAndroidHash() =>
    r'548b3c9e4b99b8d1cd78a87bddb5e32812a1ff24';
