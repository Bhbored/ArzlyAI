import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/connector_credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/provider/provider_model_repository.dart';
import 'package:arzlyai_mobile/domain/entities/provider/provider_model.dart';
import 'package:arzlyai_mobile/domain/mappers/provider/provider_model_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';
import '../helpers/fakes.dart';

final _deepseekChat = ProviderModel(
  id: 'deepseek-chat',
  displayName: 'DeepSeek Chat',
  provider: 'deepseek',
  ownedBy: 'deepseek',
  createdAtUtc: DateTime.utc(2025, 1, 1),
  supportsTemperature: true,
  supportsWebSearch: true,
);

void main() {
  late AppDatabase db;
  late MemoryCredentialStore store;
  late FakeEnvelopeService envelopes;
  late FakeProviderModelService service;
  late ProviderModelRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = MemoryCredentialStore();
    store.values[providerCredentialEnvelopeKey('openai')] = 'sk-test';
    envelopes = FakeEnvelopeService();
    service = FakeProviderModelService();
    repository = ProviderModelRepository(
      db,
      service,
      CredentialRepository(
        store,
        ConnectorCredentialRepository(store, legacyDatabase: db),
      ),
      envelopes,
      const ProviderModelMapper(),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('listModelsForProvider encrypts key and maps online catalog', () async {
    service.modelsResult = fixtureProviderModelResponses();
    final models = await repository.listModelsForProvider('openai');
    expect(models.length, 2);
    expect(models.first.id, 'gpt-5-mini');
    expect(service.lastRequest?.credentials, dummyEnvelope);
    expect(
      envelopes.lastCredentials,
      contains(providerCredentialEnvelopeKey('openai')),
    );
    expect(envelopes.lastCredentials?['openai.apiKey'], 'sk-test');
  });

  test('listModelsForProvider uses sqlite cache until force refresh', () async {
    service.modelsResult = fixtureProviderModelResponses();
    await repository.listModelsForProvider('openai');
    await repository.listModelsForProvider('openai');
    expect(service.callCount, 1);
    await repository.listModelsForProvider('openai', forceRefresh: true);
    expect(service.callCount, 2);
  });

  test('listModelsForProvider surfaces 401 from service', () async {
    service.error = const ApiException(
      userMessage: 'Unauthorized',
      error: 'invalid key',
      statusCode: 401,
      originalError: 'x',
    );
    await expectLater(
      repository.listModelsForProvider('openai'),
      throwsA(isA<ApiException>()),
    );
  });

  test(
    'listModelsForProvider rejects missing openai key before network',
    () async {
      store.values.clear();
      await expectLater(
        repository.listModelsForProvider('openai'),
        throwsA(isA<StateError>()),
      );
      expect(service.callCount, 0);
    },
  );

  test('listModelsForProvider returns empty list without error', () async {
    service.modelsResult = [];
    final models = await repository.listModelsForProvider('openai');
    expect(models, isEmpty);
  });

  test('resolveProviderForModel uses catalog when provider is omitted', () {
    final models = [...fixtureProviderModels(), _deepseekChat];
    final provider = repository.resolveProviderForModel(
      models,
      'deepseek-chat',
      fallbackProvider: 'openai',
    );
    expect(provider, 'deepseek');
  });

  test('resolveProviderForModel prefers explicit provider when valid', () {
    final models = [...fixtureProviderModels(), _deepseekChat];
    final provider = repository.resolveProviderForModel(
      models,
      'deepseek-chat',
      configuredProvider: 'deepseek',
      fallbackProvider: 'openai',
    );
    expect(provider, 'deepseek');
  });
}
