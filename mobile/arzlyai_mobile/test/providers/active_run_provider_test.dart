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
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/data/repositories/credential_repository.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';
import '../helpers/fakes.dart';

ProviderContainer _container({
  required FakeWorkflowService workflows,
  required FakeHub hub,
  required MemoryCredentialStore store,
  required FakeEnvelopeService envelopes,
  required AppDatabase db,
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

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = MemoryCredentialStore();
    store.values[providerCredentialEnvelopeKey('openai')] = 'sk-test';
    store.values[integrationFieldEnvelopeKey('linkedin.posts', 'accessToken')] = 'li-token';
    store.values[integrationFieldEnvelopeKey('linkedin.posts', 'authorUrn')] =
        'urn:li:person:1';
    envelopes = FakeEnvelopeService();
    hub = FakeHub();
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
    );
    addTearDown(container.dispose);
    await container.read(activeRunProvider.future);
    await container.read(activeRunProvider.notifier).start(const RunConfigState());
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
      online: false,
    );
    addTearDown(container.dispose);
    container.read(runConfigTempProvider.notifier).update(
      const RunConfigState(topic: 'AI agents'),
    );
    await container.read(activeRunProvider.future);
    await container.read(activeRunProvider.notifier).start(
      container.read(runConfigTempProvider),
    );
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
    );
    addTearDown(container.dispose);
    container.read(runConfigTempProvider.notifier).update(
      const RunConfigState(topic: 'AI agents'),
    );
    await container.read(activeRunProvider.future);
    await Future.wait([
      container.read(activeRunProvider.notifier).start(
        container.read(runConfigTempProvider),
      ),
      container.read(activeRunProvider.notifier).start(
        container.read(runConfigTempProvider),
      ),
    ]);
    expect(workflows.startCount, 1);
    expect(hub.subscribeCount, 1);
    expect(envelopes.lastCredentials, contains(providerCredentialEnvelopeKey('openai')));
  });

  test('429 from start is surfaced with retry after', () async {
    final workflows = FakeWorkflowService(startError: tooManyRequests());
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
    );
    addTearDown(container.dispose);
    container.read(runConfigTempProvider.notifier).update(
      const RunConfigState(topic: 'AI agents'),
    );
    await container.read(activeRunProvider.future);
    await container.read(activeRunProvider.notifier).start(
      container.read(runConfigTempProvider),
    );
    final error = container.read(activeRunProvider).error;
    expect(error, isA<ApiException>());
    expect((error! as ApiException).statusCode, 429);
    expect((error as ApiException).retryAfter, const Duration(seconds: 2));
  });

  test('recover reconnects then marks 404 expired while keeping history', () async {
    final workflows = FakeWorkflowService(getError: notFound());
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
    );
    addTearDown(container.dispose);
    container.read(runConfigTempProvider.notifier).update(
      const RunConfigState(topic: 'AI agents'),
    );
    await container.read(activeRunProvider.future);
    await container.read(activeRunProvider.notifier).start(
      container.read(runConfigTempProvider),
    );
    final runId = container.read(activeRunProvider).value!.runId;
    workflows.getError = notFound();
    await container.read(activeRunProvider.notifier).recover();
    expect(hub.reconnectCount, 1);
    final recovered = container.read(activeRunProvider).value;
    expect(recovered?.status, WorkflowRunStatus.expired);
    expect(recovered?.runId, runId);
    expect(recovered?.nodes, isNotEmpty);
  });

  test('edit approval sends numeric decision and linkedin envelope', () async {
    final workflows = FakeWorkflowService();
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
    );
    addTearDown(container.dispose);
    container.read(runConfigTempProvider.notifier).update(
      const RunConfigState(topic: 'AI agents'),
    );
    await container.read(activeRunProvider.future);
    await container.read(activeRunProvider.notifier).start(
      container.read(runConfigTempProvider),
    );
    container.read(reviewDraftTempProvider.notifier).update('edited post');
    await container.read(activeRunProvider.notifier).submitApproval(
      ApprovalDecision.edit,
      editedContent: 'edited post',
    );
    expect(workflows.lastApproval?.decision, ApprovalDecision.edit);
    expect(workflows.lastApproval?.editedContent, 'edited post');
    expect(workflows.lastApproval?.credentials, isA<CredentialEnvelope>());
    expect(
      envelopes.lastCredentials,
      contains(integrationFieldEnvelopeKey('linkedin.posts', 'accessToken')),
    );
    expect(container.read(activeRunProvider).value?.finalResponse, 'urn:li:share:123');
  });

  test('reject approval omits credentials', () async {
    final workflows = FakeWorkflowService(
      approvalResult: waitingRunDto().copyWith(status: 'Cancelled', approval: waitingRunDto().approval),
    );
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
    );
    addTearDown(container.dispose);
    container.read(runConfigTempProvider.notifier).update(
      const RunConfigState(topic: 'AI agents'),
    );
    await container.read(activeRunProvider.future);
    await container.read(activeRunProvider.notifier).start(
      container.read(runConfigTempProvider),
    );
    await container.read(activeRunProvider.notifier).submitApproval(
      ApprovalDecision.reject,
    );
    expect(workflows.lastApproval?.decision, ApprovalDecision.reject);
    expect(workflows.lastApproval?.credentials, isNull);
  });
}
