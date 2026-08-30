import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_builder.dart';
import 'package:arzlyai_mobile/core/network/configs/api_config.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_service.dart';
import 'package:arzlyai_mobile/core/constants/api_errors.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/start_workflow_request.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/submit_approval_request.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_run_response.dart';
import 'package:arzlyai_mobile/core/network/dto/security/credential_envelope.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/network/services/security/security_service.dart';
import 'package:arzlyai_mobile/core/network/services/workflow/workflow_service.dart';
import 'package:arzlyai_mobile/core/realtime/workflow_hub_client.dart';
import 'package:arzlyai_mobile/core/storage/secure_storage/secure_storage_android.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_catalog_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_store.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/mappers/preset/preset_mapper.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_details_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_summary_response.dart';
import 'package:arzlyai_mobile/core/network/dto/request/models/list_openai_models_request.dart';
import 'package:arzlyai_mobile/core/network/dto/response/models/openai_model_response.dart';
import 'package:arzlyai_mobile/core/network/services/models/openai_model_service.dart';
import 'package:arzlyai_mobile/data/providers/models/openai_models_provider.dart';
import 'package:arzlyai_mobile/domain/entities/provider/openai_model.dart';
import 'package:arzlyai_mobile/domain/mappers/provider/openai_model_mapper.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/connector_credential_repository.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

Map<String, dynamic> fixtureJson(String name) {
  return jsonDecode(
        File(
          'test/presets/daily_linkedin_ai_post/fixtures/$name',
        ).readAsStringSync(),
      )
      as Map<String, dynamic>;
}

PresetDetails fixtureDetails() {
  return const PresetMapper().detailsFromDto(
    PresetDetailsResponse.fromJson(fixtureJson('preset_details.json')),
  );
}

PresetSummary fixtureSummary() {
  return const PresetMapper().summaryFromDto(
    PresetSummaryResponse.fromJson(fixtureJson('preset_summary.json')),
  );
}

WorkflowRunResponse waitingRunDto() {
  return WorkflowRunResponse.fromJson(fixtureJson('workflow_run_waiting.json'));
}

WorkflowRunResponse completedRunDto() {
  return WorkflowRunResponse.fromJson(
    fixtureJson('workflow_run_completed.json'),
  );
}

WorkflowRunResponse regeneratedWaitingRunDto() {
  return WorkflowRunResponse.fromJson(
    fixtureJson('workflow_run_waiting_regenerated.json'),
  );
}

List<OpenAiModelResponse> fixtureOpenAiModelResponses() {
  final list =
      jsonDecode(
            File('test/fixtures/network/openai_models.json').readAsStringSync(),
          )
          as List<dynamic>;
  return list
      .map(
        (item) => OpenAiModelResponse.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
      .toList();
}

List<OpenAiModel> fixtureOpenAiModels() {
  const mapper = OpenAiModelMapper();
  return fixtureOpenAiModelResponses()
      .map((dto) => mapper.fromDto(dto))
      .toList(growable: false);
}

class FakeOpenAiModelService extends OpenAiModelService {
  FakeOpenAiModelService() : super(ApiExecutor(Dio()));

  List<OpenAiModelResponse>? result;
  Object? error;
  ListOpenAiModelsRequest? lastRequest;
  var callCount = 0;

  @override
  Future<List<OpenAiModelResponse>> listModels(
    ListOpenAiModelsRequest request,
  ) async {
    callCount++;
    lastRequest = request;
    final failure = error;
    if (failure != null) throw failure;
    return result ?? [];
  }
}

const dummyEnvelope = CredentialEnvelope(
  keyId: 'k',
  requestId: 'r',
  expiresAtUnixSeconds: 1,
  wrappedKey: 'w',
  nonce: 'n',
  ciphertext: 'c',
  tag: 't',
);

class MemoryCredentialStore extends CredentialStore {
  MemoryCredentialStore() : super(SecureStorageAndroid());

  final values = <String, String>{};

  @override
  Future<void> setValue(String envelopeKey, String value) async {
    values[envelopeKey] = value;
  }

  @override
  Future<String?> getValue(String envelopeKey) async => values[envelopeKey];

  @override
  Future<void> deleteValue(String envelopeKey) async {
    values.remove(envelopeKey);
  }
}

class FakeEnvelopeService extends CredentialEnvelopeService {
  FakeEnvelopeService()
    : super(SecurityService(ApiExecutor(Dio())), CredentialEnvelopeBuilder());

  Map<String, String>? lastCredentials;
  var encryptCount = 0;

  @override
  Future<CredentialEnvelope> encrypt(Map<String, String> credentials) async {
    encryptCount++;
    lastCredentials = Map<String, String>.from(credentials);
    return dummyEnvelope;
  }
}

class FakeHub extends WorkflowHubClient {
  FakeHub() : super(() async => ApiConfig.defaultBaseUrl);

  var subscribeCount = 0;
  var reconnectCount = 0;
  String? lastRunId;

  @override
  Future<void> subscribeToRun(String runId) async {
    subscribeCount++;
    lastRunId = runId;
  }

  @override
  Future<void> reconnect() async {
    reconnectCount++;
  }
}

class FakeWorkflowService extends WorkflowService {
  FakeWorkflowService({
    WorkflowRunResponse? startResult,
    WorkflowRunResponse? getResult,
    WorkflowRunResponse? approvalResult,
    WorkflowRunResponse? editApprovalResult,
    WorkflowRunResponse? rejectApprovalResult,
    this.startError,
    this.getError,
    this.approvalError,
  }) : startResult = startResult ?? waitingRunDto(),
       getResult = getResult ?? waitingRunDto(),
       approvalResult = approvalResult ?? completedRunDto(),
       editApprovalResult = editApprovalResult ?? regeneratedWaitingRunDto(),
       rejectApprovalResult =
           rejectApprovalResult ??
           waitingRunDto().copyWith(status: 'Cancelled'),
       super(ApiExecutor(Dio()));

  WorkflowRunResponse startResult;
  WorkflowRunResponse getResult;
  WorkflowRunResponse approvalResult;
  WorkflowRunResponse editApprovalResult;
  WorkflowRunResponse rejectApprovalResult;
  Object? startError;
  Object? getError;
  Object? approvalError;
  var startCount = 0;
  StartWorkflowRequest? lastStart;
  SubmitApprovalRequest? lastApproval;
  Duration startDelay = Duration.zero;

  @override
  Future<WorkflowRunResponse> start(StartWorkflowRequest request) async {
    startCount++;
    lastStart = request;
    if (startDelay > Duration.zero) {
      await Future<void>.delayed(startDelay);
    }
    final error = startError;
    if (error != null) throw error;
    return startResult;
  }

  @override
  Future<WorkflowRunResponse> getRun(String runId) async {
    final error = getError;
    if (error != null) throw error;
    return getResult;
  }

  @override
  Future<WorkflowRunResponse> submitApproval(
    String runId,
    SubmitApprovalRequest request,
  ) async {
    lastApproval = request;
    final error = approvalError;
    if (error != null) throw error;
    switch (request.decision) {
      case ApprovalDecision.edit:
        return editApprovalResult;
      case ApprovalDecision.reject:
        return rejectApprovalResult;
      case ApprovalDecision.accept:
        return approvalResult;
    }
  }
}

class SeededCatalog extends PresetCatalog {
  SeededCatalog(this.items);
  final List<PresetSummary> items;

  @override
  Future<List<PresetSummary>> build() async => items;
}

class FailingCatalog extends PresetCatalog {
  @override
  Future<List<PresetSummary>> build() async {
    throw const ApiException(
      userMessage: 'Catalog unavailable',
      error: 'down',
      correlationId: 'corr-1',
      originalError: 'x',
    );
  }
}

class SeededDetails extends PresetDetailsNotifier {
  SeededDetails(this.details);
  final PresetDetails details;

  @override
  Future<PresetDetails?> build() async => details;
}

class SeededOpenAiModels extends OpenAiModels {
  SeededOpenAiModels(this.models);
  final List<OpenAiModel> models;

  @override
  Future<List<OpenAiModel>> build() async => models;
}

class OnlineMode extends OfflineMode {
  @override
  Future<bool> build() async => false;
}

class ForcedOfflineMode extends OfflineMode {
  @override
  Future<bool> build() async => true;
}

Future<void> seedLinkedInConnector(AppDatabase db) {
  return ConnectorCredentialRepository(db).saveFields(ConnectorKeys.linkedin, {
    LinkedInConnectorFields.accessToken: 'li-token',
    LinkedInConnectorFields.authorUrn: 'urn:li:person:1',
  });
}

ApiException notFound() {
  return const ApiException(
    userMessage: 'Resource not found.',
    error: 'missing',
    statusCode: 404,
    originalError: 'x',
  );
}

ApiException tooManyRequests() {
  return const ApiException(
    userMessage: 'Too many requests.',
    error: 'slow down',
    statusCode: 429,
    retryAfter: Duration(seconds: 2),
    originalError: 'x',
  );
}

ApiException receiveTimeout() {
  return ApiException(
    userMessage: ApiErrors.receiveTimeout,
    error: 'Server took too long to respond.',
    originalError: DioException(
      requestOptions: RequestOptions(path: 'workflows/runs'),
      type: DioExceptionType.receiveTimeout,
    ),
  );
}
