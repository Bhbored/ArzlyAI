import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_service.dart';
import 'package:arzlyai_mobile/core/network/services/workflow/workflow_service.dart';
import 'package:arzlyai_mobile/core/realtime/workflow_hub_client.dart';
import 'package:arzlyai_mobile/data/providers/models/openai_models_provider.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_catalog_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/review_draft_temp.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/data/repositories/credential_repository.dart';
import 'package:arzlyai_mobile/data/repositories/openai_model_repository.dart';
import 'package:arzlyai_mobile/domain/mappers/provider/openai_model_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';
import 'package:arzlyai_mobile/ui/features/presets/catalog/preset_catalog_screen.dart';
import '../../helpers/fakes.dart';
import '../../helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('catalog to details to generate to edit approval', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final store = MemoryCredentialStore();
    store.values[providerCredentialEnvelopeKey('openai')] = 'sk-test';
    store.values[integrationFieldEnvelopeKey('linkedin.posts', 'accessToken')] = 'li-token';
    store.values[integrationFieldEnvelopeKey('linkedin.posts', 'authorUrn')] =
        'urn:li:person:1';
    final workflows = FakeWorkflowService();
    final hub = FakeHub();
    final envelopes = FakeEnvelopeService();
    final openAiRepo = OpenAiModelRepository(
      FakeOpenAiModelService()..result = fixtureOpenAiModelResponses(),
      CredentialRepository(store),
      envelopes,
      const OpenAiModelMapper(),
    );
    await openAiRepo.listModels();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          presetCatalogProvider.overrideWith(
            () => SeededCatalog([fixtureSummary()]),
          ),
          presetDetailsProvider.overrideWith(() => SeededDetails(fixtureDetails())),
          openAiModelsProvider.overrideWith(
            () => SeededOpenAiModels(fixtureOpenAiModels()),
          ),
          openAiModelRepositoryProvider.overrideWithValue(openAiRepo),
          workflowServiceProvider.overrideWithValue(workflows),
          workflowHubClientProvider.overrideWithValue(hub),
          credentialStoreProvider.overrideWithValue(store),
          credentialEnvelopeServiceProvider.overrideWithValue(envelopes),
          internetConnectionProvider.overrideWithValue(true),
          offlineModeProvider.overrideWith(OnlineMode.new),
        ],
        child: testApp(home: const PresetCatalogScreen()),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Daily LinkedIn AI Post'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('AI Content Writer'), 300);
    await tester.tap(find.text('AI Content Writer'));
    await tester.pumpAndSettle();
    expect(find.text('Generate'), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.text('Generate')),
    );
    container.read(runConfigTempProvider.notifier).update(
      const RunConfigState(topic: 'AI agents'),
    );
    await container.read(activeRunProvider.notifier).start(
      container.read(runConfigTempProvider),
    );
    expect(workflows.startCount, 1);
    expect(workflows.lastStart?.inputs['topic'], 'AI agents');
    container.read(reviewDraftTempProvider.notifier).update('edited post');
    await container.read(activeRunProvider.notifier).submitApproval(
      ApprovalDecision.edit,
      editedContent: 'edited post',
    );
    expect(workflows.lastApproval?.decision, ApprovalDecision.edit);
    expect(
      container.read(activeRunProvider).value?.status,
      WorkflowRunStatus.waitingForApproval,
    );
    expect(container.read(activeRunProvider).value?.finalResponse, isNull);
    expect(
      envelopes.lastCredentials,
      contains(providerCredentialEnvelopeKey('openai')),
    );
  });
}
