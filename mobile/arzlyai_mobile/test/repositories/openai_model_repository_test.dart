import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/data/repositories/credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/openai_model_repository.dart';
import 'package:arzlyai_mobile/domain/mappers/provider/openai_model_mapper.dart';
import '../helpers/fakes.dart';

void main() {
  late MemoryCredentialStore store;
  late FakeEnvelopeService envelopes;
  late FakeOpenAiModelService service;
  late OpenAiModelRepository repository;

  setUp(() {
    store = MemoryCredentialStore();
    store.values[providerCredentialEnvelopeKey('openai')] = 'sk-test';
    envelopes = FakeEnvelopeService();
    service = FakeOpenAiModelService();
    repository = OpenAiModelRepository(
      service,
      CredentialRepository(store),
      envelopes,
      const OpenAiModelMapper(),
    );
  });

  test('listModels encrypts key and maps online catalog', () async {
    service.result = fixtureOpenAiModelResponses();
    final models = await repository.listModels();
    expect(models.length, 2);
    expect(models.first.id, 'gpt-5-mini');
    expect(service.lastRequest?.credentials, dummyEnvelope);
    expect(envelopes.lastCredentials, contains(providerCredentialEnvelopeKey('openai')));
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
