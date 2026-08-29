import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:arzlyai_mobile/core/storage/secure_storage/secure_storage_android.dart';

part 'device_id_store.g.dart';

abstract final class DeviceIdStorageKeys {
  static const deviceId = 'arzlyai.deviceId';
}

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
DeviceIdStore deviceIdStore(Ref ref) {
  return DeviceIdStore(ref.read(secureStorageAndroidProvider));
}

class DeviceIdStore {
  DeviceIdStore(this._storage);

  final SecureStorageAndroid _storage;
  final _uuid = const Uuid();

  Future<String> getOrCreate() async {
    final existing = await _storage.getValue(DeviceIdStorageKeys.deviceId);
    if (existing != null && existing.trim().isNotEmpty) {
      return existing.trim();
    }
    final next = _uuid.v4();
    await _storage.setValue(DeviceIdStorageKeys.deviceId, next);
    return next;
  }
}
