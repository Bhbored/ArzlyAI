import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_auth_cache.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_auth_state_store.dart';

import '../helpers/fakes.dart';

void main() {
  late MemoryCredentialStore credentials;
  late GoogleAuthStateStore store;

  setUp(() {
    credentials = MemoryCredentialStore();
    store = GoogleAuthStateStore(credentials);
  });

  test('save_WhenStateProvided_PersistsSafeAccountMetadata', () async {
    await store.save(
      const GoogleAuthCache(
        accountEmail: 'person@example.com',
        accountDisplayName: 'Person',
        authorizedConnectors: {ConnectorKeys.googleTasks, ConnectorKeys.gmail},
      ),
    );

    final restored = await store.read();

    expect(restored?.accountEmail, 'person@example.com');
    expect(restored?.accountDisplayName, 'Person');
    expect(restored?.authorizedConnectors, {
      ConnectorKeys.googleTasks,
      ConnectorKeys.gmail,
    });
    expect(credentials.values.values, isNot(contains('token')));
  });

  test('clear_WhenStateExists_RemovesPersistedState', () async {
    await store.save(const GoogleAuthCache(accountEmail: 'person@example.com'));

    await store.clear();

    expect(await store.read(), isNull);
  });
}
