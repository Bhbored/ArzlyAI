import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/connector_credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/provider/openai_model_repository.dart';
import 'package:arzlyai_mobile/domain/mappers/provider/openai_model_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';
import '../helpers/fakes.dart';

void main() {
  late AppDatabase db;
  late MemoryCredentialStore store;
  late FakeEnvelopeService envelopes;
  late FakeOpenAiModelService service;
  late OpenAiModelRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = MemoryCredentialStore();
    store.values[providerCredentialEnvelopeKey('openai')] = 'sk-test';
    envelopes = FakeEnvelopeService();
    service = FakeOpenAiModelService();
    repository = OpenAiModelRepository(
      service,
      CredentialRepository(store, ConnectorCredentialRepository(db)),
      envelopes,
      const OpenAiModelMapper(),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('listModels encrypts key and maps online catalog', () async {
    service.result = fixtureOpenAiModelResponses();
    final models = await repository.listModels();
    expect(models.length, 2);
    expect(models.first.id, 'gpt-5-mini');
    expect(service.lastRequest?.credentials, dummyEnvelope);
    expect(
      envelopes.lastCredentials,
      contains(providerCredentialEnvelopeKey('openai')),
    );
    expect(envelopes.lastCredentials?['openai.apiKey'], 'sk-test');
  });

  test('listModels uses in-memory cache until force refresh', () async {
    service.result = fixtureOpenAiModelResponses();
    await repository.listModels();
    await repository.listModels();
    expect(service.callCount, 1);
    await repository.listModels(forceRefresh: true);
    expect(service.callCount, 2);
  });

  test('listModels surfaces 401 from service', () async {
    service.error = const ApiException(
      userMessage: 'Unauthorized',
      error: 'invalid key',
      statusCode: 401,
      originalError: 'x',
    );
    await expectLater(repository.listModels(), throwsA(isA<ApiException>()));
  });

  test('listModels rejects missing openai key before network', () async {
    store.values.clear();
    await expectLater(repository.listModels(), throwsA(isA<StateError>()));
    expect(service.callCount, 0);
  });

  test('listModels returns empty list without error', () async {
    service.result = [];
    final models = await repository.listModels();
    expect(models, isEmpty);
  });
}
