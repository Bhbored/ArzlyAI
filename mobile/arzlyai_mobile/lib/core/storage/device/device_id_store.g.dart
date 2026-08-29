// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_id_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deviceIdStore)
final deviceIdStoreProvider = DeviceIdStoreProvider._();

final class DeviceIdStoreProvider
    extends $FunctionalProvider<DeviceIdStore, DeviceIdStore, DeviceIdStore>
    with $Provider<DeviceIdStore> {
  DeviceIdStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'deviceIdStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceIdStoreHash();

  @$internal
  @override
  $ProviderElement<DeviceIdStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeviceIdStore create(Ref ref) {
    return deviceIdStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceIdStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceIdStore>(value),
    );
  }
}

String _$deviceIdStoreHash() => r'b3671c60d9a8d2ca319a35a0d2c84a2a715b8ee5';
