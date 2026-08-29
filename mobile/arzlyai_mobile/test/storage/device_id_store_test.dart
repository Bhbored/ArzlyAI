import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/storage/device/device_id_store.dart';
import 'package:arzlyai_mobile/core/storage/secure_storage/secure_storage_android.dart';

class MemorySecureStorage extends SecureStorageAndroid {
  final values = <String, String>{};

  @override
  Future<void> setValue(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<String?> getValue(String key) async => values[key];

  @override
  Future<void> deleteValue(String key) async {
    values.remove(key);
  }
}

void main() {
  late MemorySecureStorage storage;
  late DeviceIdStore store;

  setUp(() {
    storage = MemorySecureStorage();
    store = DeviceIdStore(storage);
  });

  test('getOrCreate generates once and reuses', () async {
    final first = await store.getOrCreate();
    final second = await store.getOrCreate();
    expect(first, second);
    expect(storage.values[DeviceIdStorageKeys.deviceId], first);
    expect(first.isNotEmpty, isTrue);
  });
}
