import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'secure_storage_android.g.dart';

@Riverpod(keepAlive: true)
SecureStorageAndroid secureStorageAndroid(Ref ref) {
  return SecureStorageAndroid();
}

class SecureStorageAndroid {
  final log = Logger();

  final storage = FlutterSecureStorage(aOptions: AndroidOptions());

  Future<void> setValue(String key, String value) async {
    try {
      await storage.write(key: key, value: value);
      log.i('Secure value stored for $key');
    } on Exception catch (e) {
      log.e('Failed to set value: $e');
    }
  }

  Future<String?> getValue(String key) async {
    try {
      final value = await storage.read(key: key);
      if (value == null) {
        log.w('Value does not exist: $key');
        return null;
      }
      log.i('Secure value loaded for $key');
      return value;
    } on Exception catch (e) {
      log.e('Failed to get value: $e');
      return null;
    }
  }

  Future<void> deleteValue(String key) async {
    try {
      if (await verifyValue(key)) {
        await storage.delete(key: key);
        log.i('Value deleted: $key');
      } else {
        log.e('Failed to delete value: Value does not exist');
      }
    } on Exception catch (e) {
      log.e('Failed to delete value: $e');
    }
  }

  Future<void> clear() async {
    try {
      await storage.deleteAll();
      log.i('All values deleted');
    } on Exception catch (e) {
      log.e('Failed to clear storage: $e');
    }
  }

  Future<bool> verifyValue(String key) async {
    try {
      return await storage.containsKey(key: key);
    } on Exception catch (e) {
      log.e('Failed to verify value: $e');
      return false;
    }
  }
}
