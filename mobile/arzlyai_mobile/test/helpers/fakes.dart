import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_builder.dart';
import 'package:arzlyai_mobile/core/network/configs/api_config.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_service.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/start_workflow_request.dart';
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
import 'package:arzlyai_mobile/data/repositories/credential_store.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/mappers/preset/preset_mapper.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_details_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_summary_response.dart';

Map<String, dynamic> fixtureJson(String name) {
  return jsonDecode(File('test/fixtures/$name').readAsStringSync())
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
  return WorkflowRunResponse.fromJson(fixtureJson('workflow_run_completed.json'));
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

  @override
  Future<CredentialEnvelope> encrypt(Map<String, String> credentials) async {
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
    this.startError,
    this.getError,
    this.approvalError,
  }) : startResult = startResult ?? waitingRunDto(),
       getResult = getResult ?? waitingRunDto(),
       approvalResult = approvalResult ?? completedRunDto(),
       super(ApiExecutor(Dio()));

  WorkflowRunResponse startResult;
  WorkflowRunResponse getResult;
  WorkflowRunResponse approvalResult;
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
    return approvalResult;
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

class OnlineMode extends OfflineMode {
  @override
  Future<bool> build() async => false;
}

class ForcedOfflineMode extends OfflineMode {
  @override
  Future<bool> build() async => true;
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
