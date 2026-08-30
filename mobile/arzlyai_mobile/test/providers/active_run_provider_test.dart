import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/network/dto/security/credential_envelope.dart';
import 'package:arzlyai_mobile/core/realtime/workflow_hub_client.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/network/services/workflow/workflow_service.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_service.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/review_draft_temp.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/providers/selection/selected_run_id_provider.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/data/providers/workflow/workflow_transport_provider.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/connector_credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_repository.dart';
import 'package:arzlyai_mobile/data/providers/models/provider_models_provider.dart';
import 'package:arzlyai_mobile/data/providers/settings/ai_settings_provider.dart';
import 'package:arzlyai_mobile/data/repositories/provider/provider_model_repository.dart';
import 'package:arzlyai_mobile/domain/mappers/provider/provider_model_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';
import '../helpers/fakes.dart';

ProviderContainer _container({
  required FakeWorkflowService workflows,
  required FakeHub hub,
  required MemoryCredentialStore store,
  required FakeEnvelopeService envelopes,
  required AppDatabase db,
  required ProviderModelRepository providerModelRepo,
  bool online = true,
  bool offlineMode = false,
}) {
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      workflowServiceProvider.overrideWithValue(workflows),
      workflowHubClientProvider.overrideWithValue(hub),
      credentialStoreProvider.overrideWithValue(store),
      credentialEnvelopeServiceProvider.overrideWithValue(envelopes),
      providerModelRepositoryProvider.overrideWithValue(providerModelRepo),
      availableProviderModelsProvider.overrideWith(
        () => SeededAvailableProviderModels(fixtureProviderModels()),
      ),
      defaultAiModelProvider.overrideWith((ref) async => null),
      internetConnectionProvider.overrideWithValue(online),
      offlineModeProvider.overrideWith(
        offlineMode ? ForcedOfflineMode.new : OnlineMode.new,
      ),
      presetDetailsProvider.overrideWith(() => SeededDetails(fixtureDetails())),
    ],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late MemoryCredentialStore store;
  late FakeEnvelopeService envelopes;
  late FakeHub hub;
  late ProviderModelRepository providerModelRepo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = MemoryCredentialStore();
    store.values[providerCredentialEnvelopeKey('openai')] = 'sk-test';
    await seedLinkedInConnector(db);
    envelopes = FakeEnvelopeService();
    hub = FakeHub();
    providerModelRepo = ProviderModelRepository(
      db,
      FakeProviderModelService()
        ..modelsResult = fixtureProviderModelResponses(),
      CredentialRepository(store, ConnectorCredentialRepository(db)),
      envelopes,
      const ProviderModelMapper(),
    );
    await providerModelRepo.listModelsForProvider('openai');
  });

  tearDown(() async {
    await db.close();
  });

  test('start rejects empty topic', () async {
    final workflows = FakeWorkflowService();
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      providerModelRepo: providerModelRepo,
    );
    addTearDown(container.dispose);
    await container.read(activeRunProvider.future);
    await container
        .read(activeRunProvider.notifier)
        .start(const RunConfigState());
    expect(workflows.startCount, 0);
  });

  test('start is gated offline', () async {
    final workflows = FakeWorkflowService();
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      providerModelRepo: providerModelRepo,
      online: false,
    );
    addTearDown(container.dispose);
    container
        .read(runConfigTempProvider.notifier)
        .update(const RunConfigState(topic: 'AI agents'));
    await container.read(activeRunProvider.future);
    await container
        .read(activeRunProvider.notifier)
        .start(container.read(runConfigTempProvider));
    expect(container.read(activeRunProvider).error, isA<StateError>());
    expect(workflows.startCount, 0);
  });

  test('double tap starts the workflow once', () async {
    final workflows = FakeWorkflowService()
      ..startDelay = const Duration(milliseconds: 40);
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      providerModelRepo: providerModelRepo,
    );
    addTearDown(container.dispose);
    container
        .read(runConfigTempProvider.notifier)
        .update(const RunConfigState(topic: 'AI agents'));
    await container.read(activeRunProvider.future);
    await Future.wait([
      container
          .read(activeRunProvider.notifier)
          .start(container.read(runConfigTempProvider)),
      container
          .read(activeRunProvider.notifier)
          .start(container.read(runConfigTempProvider)),
    ]);
    expect(workflows.startCount, 1);
    expect(hub.subscribeCount, 1);
    expect(
      envelopes.lastCredentials,
      contains(providerCredentialEnvelopeKey('openai')),
    );
  });

  test('429 from start is surfaced with retry after', () async {
    final workflows = FakeWorkflowService(startError: tooManyRequests());
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      providerModelRepo: providerModelRepo,
    );
    addTearDown(container.dispose);
    container
        .read(runConfigTempProvider.notifier)
        .update(const RunConfigState(topic: 'AI agents'));
    await container.read(activeRunProvider.future);
    await container
        .read(activeRunProvider.notifier)
        .start(container.read(runConfigTempProvider));
    final error = container.read(activeRunProvider).error;
    expect(error, isA<ApiException>());
    expect((error! as ApiException).statusCode, 429);
    expect((error as ApiException).retryAfter, const Duration(seconds: 2));
  });

  test(
    'recover reconnects then marks 404 expired while keeping history',
    () async {
      final workflows = FakeWorkflowService(getError: notFound());
      final container = _container(
        workflows: workflows,
        hub: hub,
        store: store,
        envelopes: envelopes,
        db: db,
        providerModelRepo: providerModelRepo,
      );
      addTearDown(container.dispose);
      container
          .read(runConfigTempProvider.notifier)
          .update(const RunConfigState(topic: 'AI agents'));
      await container.read(activeRunProvider.future);
      await container
          .read(activeRunProvider.notifier)
          .start(container.read(runConfigTempProvider));
      final runId = container.read(activeRunProvider).value!.runId;
      workflows.getError = notFound();
      await container.read(activeRunProvider.notifier).recover();
      expect(hub.reconnectCount, 1);
      final recovered = container.read(activeRunProvider).value;
      expect(recovered?.status, WorkflowRunStatus.expired);
      expect(recovered?.runId, runId);
      expect(recovered?.nodes, isNotEmpty);
    },
  );

  test('edit approval sends openai envelope and returns waiting', () async {
    final workflows = FakeWorkflowService();
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      providerModelRepo: providerModelRepo,
    );
    addTearDown(container.dispose);
    container
        .read(runConfigTempProvider.notifier)
        .update(const RunConfigState(topic: 'AI agents'));
    await container.read(activeRunProvider.future);
    await container
        .read(activeRunProvider.notifier)
        .start(container.read(runConfigTempProvider));
    container
        .read(reviewDraftTempProvider.notifier)
        .update('Use a stronger opening');
    await container
        .read(activeRunProvider.notifier)
        .submitApproval(
          ApprovalDecision.edit,
          editedContent: 'Use a stronger opening',
        );
    expect(workflows.lastApproval?.decision, ApprovalDecision.edit);
    expect(workflows.lastApproval?.editedContent, 'Use a stronger opening');
    expect(workflows.lastApproval?.credentials, isA<CredentialEnvelope>());
    expect(
      envelopes.lastCredentials,
      contains(providerCredentialEnvelopeKey('openai')),
    );
    expect(
      envelopes.lastCredentials,
      isNot(
        contains(integrationFieldEnvelopeKey('linkedin.posts', 'accessToken')),
      ),
    );
    final run = container.read(activeRunProvider).value;
    expect(run?.status, WorkflowRunStatus.waitingForApproval);
    expect(run?.finalResponse, isNull);
    expect(run?.approval?.originalContent, contains('stronger opening'));
  });

  test('accept approval sends linkedin envelope and completes', () async {
    final workflows = FakeWorkflowService();
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      providerModelRepo: providerModelRepo,
    );
    addTearDown(container.dispose);
    container
        .read(runConfigTempProvider.notifier)
        .update(const RunConfigState(topic: 'AI agents'));
    await container.read(activeRunProvider.future);
    await container
        .read(activeRunProvider.notifier)
        .start(container.read(runConfigTempProvider));
    await container
        .read(activeRunProvider.notifier)
        .submitApproval(ApprovalDecision.accept);
    expect(workflows.lastApproval?.decision, ApprovalDecision.accept);
    expect(workflows.lastApproval?.editedContent, isNull);
    expect(
      envelopes.lastCredentials,
      contains(integrationFieldEnvelopeKey('linkedin.posts', 'accessToken')),
    );
    expect(
      container.read(activeRunProvider).value?.finalResponse,
      'urn:li:share:123',
    );
  });

  test('repeated edit approval cycles stay waiting', () async {
    final workflows = FakeWorkflowService();
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      providerModelRepo: providerModelRepo,
    );
    addTearDown(container.dispose);
    container
        .read(runConfigTempProvider.notifier)
        .update(const RunConfigState(topic: 'AI agents'));
    await container.read(activeRunProvider.future);
    await container
        .read(activeRunProvider.notifier)
        .start(container.read(runConfigTempProvider));
    for (final feedback in ['Shorter', 'Even shorter']) {
      await container
          .read(activeRunProvider.notifier)
          .submitApproval(ApprovalDecision.edit, editedContent: feedback);
      expect(
        container.read(activeRunProvider).value?.status,
        WorkflowRunStatus.waitingForApproval,
      );
    }
    expect(workflows.lastApproval?.decision, ApprovalDecision.edit);
  });

  test('reject approval omits credentials', () async {
    final workflows = FakeWorkflowService(
      approvalResult: waitingRunDto().copyWith(
        status: 'Cancelled',
        approval: waitingRunDto().approval,
      ),
    );
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      providerModelRepo: providerModelRepo,
    );
    addTearDown(container.dispose);
    container
        .read(runConfigTempProvider.notifier)
        .update(const RunConfigState(topic: 'AI agents'));
    await container.read(activeRunProvider.future);
    await container
        .read(activeRunProvider.notifier)
        .start(container.read(runConfigTempProvider));
    await container
        .read(activeRunProvider.notifier)
        .submitApproval(ApprovalDecision.reject);
    expect(workflows.lastApproval?.decision, ApprovalDecision.reject);
    expect(workflows.lastApproval?.credentials, isNull);
  });

  test('start omits temperature for non-supporting model', () async {
    final workflows = FakeWorkflowService();
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      providerModelRepo: providerModelRepo,
    );
    addTearDown(container.dispose);
    container
        .read(runConfigTempProvider.notifier)
        .update(
          const RunConfigState(
            topic: 'AI agents',
            model: 'gpt-5-mini',
            temperature: 0.7,
          ),
        );
    await container.read(activeRunProvider.future);
    await container
        .read(activeRunProvider.notifier)
        .start(container.read(runConfigTempProvider));
    final override = workflows.lastStart!.agentOverrides.single;
    expect(override.model, 'gpt-5-mini');
    expect(override.temperature, isNull);
    expect(envelopes.lastCredentials?['openai.apiKey'], 'sk-test');
    expect(workflows.lastStart!.credentials, dummyEnvelope);
  });

  test('start includes model and temperature for supporting model', () async {
    final workflows = FakeWorkflowService();
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      providerModelRepo: providerModelRepo,
    );
    addTearDown(container.dispose);
    container
        .read(runConfigTempProvider.notifier)
        .update(
          const RunConfigState(
            topic: 'AI agents',
            model: 'gpt-4.1-mini',
            temperature: 0.4,
          ),
        );
    await container.read(activeRunProvider.future);
    await container
        .read(activeRunProvider.notifier)
        .start(container.read(runConfigTempProvider));
    final override = workflows.lastStart!.agentOverrides.single;
    expect(override.model, 'gpt-4.1-mini');
    expect(override.temperature, 0.4);
  });

  test('SubmitApproval_WhenReceiveTimeout_KeepsRunProcessing', () async {
    final workflows = FakeWorkflowService()..approvalError = receiveTimeout();
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      providerModelRepo: providerModelRepo,
    );
    addTearDown(container.dispose);
    container
        .read(runConfigTempProvider.notifier)
        .update(const RunConfigState(topic: 'AI agents'));
    await container.read(activeRunProvider.future);
    await container
        .read(activeRunProvider.notifier)
        .start(container.read(runConfigTempProvider));
    final runId = container.read(selectedRunIdProvider);
    await container
        .read(activeRunProvider.notifier)
        .submitApproval(ApprovalDecision.accept);
    expect(container.read(activeRunProvider).hasError, isFalse);
    expect(container.read(workflowTransportProvider).isProcessing, isTrue);
    expect(runId, isNotNull);
  });

  test('SignalRReconnect_WhenRunAlreadyCompleted_UsesSnapshot', () async {
    final workflows = FakeWorkflowService(getResult: completedRunDto());
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      providerModelRepo: providerModelRepo,
    );
    addTearDown(container.dispose);
    container
        .read(runConfigTempProvider.notifier)
        .update(const RunConfigState(topic: 'AI agents'));
    await container.read(activeRunProvider.future);
    await container
        .read(activeRunProvider.notifier)
        .start(container.read(runConfigTempProvider));
    await container.read(activeRunProvider.notifier).recover();
    expect(hub.reconnectCount, 1);
    expect(
      container.read(activeRunProvider).value?.status,
      WorkflowRunStatus.completed,
    );
  });
}
