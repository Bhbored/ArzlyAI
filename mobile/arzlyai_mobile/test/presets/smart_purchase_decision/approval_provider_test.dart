import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_details_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_run_response.dart';
import 'package:arzlyai_mobile/core/network/dto/security/credential_envelope.dart';
import 'package:arzlyai_mobile/core/realtime/workflow_hub_client.dart';
import 'package:arzlyai_mobile/core/network/services/workflow/workflow_service.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_service.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/connector_credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/provider/openai_model_repository.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/mappers/preset/preset_mapper.dart';
import 'package:arzlyai_mobile/domain/mappers/provider/openai_model_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';
import '../../helpers/fakes.dart';

WorkflowRunResponse _runFixture(String name) {
  return WorkflowRunResponse.fromJson(
    jsonDecode(
          File('test/presets/smart_purchase_decision/fixtures/$name')
              .readAsStringSync(),
        )
        as Map<String, dynamic>,
  );
}

PresetDetails smartPurchaseDetails() {
  return const PresetMapper().detailsFromDto(
    PresetDetailsResponse.fromJson(
      jsonDecode(
            File(
              'test/presets/smart_purchase_decision/fixtures/preset_details.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>,
    ),
  );
}

ProviderContainer _container({
  required FakeWorkflowService workflows,
  required FakeHub hub,
  required MemoryCredentialStore store,
  required FakeEnvelopeService envelopes,
  required AppDatabase db,
  required OpenAiModelRepository openAiRepo,
}) {
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      workflowServiceProvider.overrideWithValue(workflows),
      workflowHubClientProvider.overrideWithValue(hub),
      credentialStoreProvider.overrideWithValue(store),
      credentialEnvelopeServiceProvider.overrideWithValue(envelopes),
      openAiModelRepositoryProvider.overrideWithValue(openAiRepo),
      internetConnectionProvider.overrideWithValue(true),
      offlineModeProvider.overrideWith(OnlineMode.new),
      presetDetailsProvider.overrideWith(() => SeededDetails(smartPurchaseDetails())),
    ],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late MemoryCredentialStore store;
  late FakeEnvelopeService envelopes;
  late FakeHub hub;
  late OpenAiModelRepository openAiRepo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = MemoryCredentialStore();
    store.values[providerCredentialEnvelopeKey('openai')] = 'sk-test';
    envelopes = FakeEnvelopeService();
    hub = FakeHub();
    openAiRepo = OpenAiModelRepository(
      FakeOpenAiModelService()..result = fixtureOpenAiModelResponses(),
      CredentialRepository(store, ConnectorCredentialRepository(db)),
      envelopes,
      const OpenAiModelMapper(),
    );
    await openAiRepo.listModels();
  });

  tearDown(() async {
    await db.close();
  });

  test('ApprovalRequest_WhenRequirementsEdit_SendsFeedbackAndEnvelope', () async {
    final waiting = _runFixture('workflow_run_requirements_waiting.json');
    final workflows = FakeWorkflowService(
      startResult: waiting,
      approvalResult: waiting,
      editApprovalResult: waiting,
    );
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      openAiRepo: openAiRepo,
    );
    addTearDown(container.dispose);

    container.read(runConfigTempProvider.notifier).update(
      const RunConfigState(
        inputs: {
          'purchaseGoal': 'Laptop for university',
          'countryCode': 'US',
          'currencyCode': 'USD',
        },
      ),
    );
    await container.read(activeRunProvider.future);
    await container
        .read(activeRunProvider.notifier)
        .start(container.read(runConfigTempProvider));
    await container.read(activeRunProvider.notifier).submitApproval(
      ApprovalDecision.edit,
      editedContent: 'Add battery life priority',
    );

    expect(workflows.lastApproval?.decision, ApprovalDecision.edit);
    expect(workflows.lastApproval?.editedContent, 'Add battery life priority');
    expect(workflows.lastApproval?.credentials, isA<CredentialEnvelope>());
    expect(
      envelopes.lastCredentials,
      contains(providerCredentialEnvelopeKey('openai')),
    );
  });

  test('ApprovalRequest_WhenReject_SendsNoCredentials', () async {
    final waiting = _runFixture('workflow_run_requirements_waiting.json');
    final workflows = FakeWorkflowService(
      startResult: waiting,
      rejectApprovalResult: waiting.copyWith(status: 'Cancelled'),
    );
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      openAiRepo: openAiRepo,
    );
    addTearDown(container.dispose);

    container.read(runConfigTempProvider.notifier).update(
      const RunConfigState(
        inputs: {
          'purchaseGoal': 'Laptop for university',
          'countryCode': 'US',
          'currencyCode': 'USD',
        },
      ),
    );
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

  test('final accept omits credentials when no nodes remain', () async {
    final waiting = _runFixture('workflow_run_final_waiting.json');
    final workflows = FakeWorkflowService(
      startResult: waiting,
      approvalResult: waiting.copyWith(status: 'Completed'),
    );
    final container = _container(
      workflows: workflows,
      hub: hub,
      store: store,
      envelopes: envelopes,
      db: db,
      openAiRepo: openAiRepo,
    );
    addTearDown(container.dispose);

    container.read(runConfigTempProvider.notifier).update(
      const RunConfigState(
        inputs: {
          'purchaseGoal': 'Laptop for university',
          'countryCode': 'US',
          'currencyCode': 'USD',
        },
      ),
    );
    await container.read(activeRunProvider.future);
    await container
        .read(activeRunProvider.notifier)
        .start(container.read(runConfigTempProvider));
    await container
        .read(activeRunProvider.notifier)
        .submitApproval(ApprovalDecision.accept);

    expect(workflows.lastApproval?.decision, ApprovalDecision.accept);
    expect(workflows.lastApproval?.credentials, isNull);
  });
}
