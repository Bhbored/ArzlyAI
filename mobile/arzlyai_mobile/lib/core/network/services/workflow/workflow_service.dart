import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';import 'package:arzlyai_mobile/core/network/configs/api_config.dart';
import 'package:arzlyai_mobile/core/network/client/dio_client.dart';
import 'package:arzlyai_mobile/core/network/configs/http_methods.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/start_workflow_request.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/submit_approval_request.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_run_response.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/network/request/api_request.dart';

part 'workflow_service.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
WorkflowService workflowService(Ref ref) {
  final dioClient = ref.read(dioClientProvider(null, endpoint: ''));
  final apiExecutor = ref.read(apiExecutorProvider(dioClient.dio));
  return WorkflowService(apiExecutor);
}

class WorkflowService {
  WorkflowService(this._apiExecutor);

  final ApiExecutor _apiExecutor;
  final _logger = Logger();

  Future<WorkflowRunResponse> start(StartWorkflowRequest request) async {
    final response = await _apiExecutor.execute(
      ApiRequest(
        path: 'workflows/runs',
        method: HttpMethod.post,
        data: request.toJson(),
        options: ApiConfig.workflowOptions(),
      ),
    );
    return response.when(
      success: (data, statusCode, meta) {
        _logger.i('Workflow started');
        return WorkflowRunResponse.fromJson(data as Map<String, dynamic>);
      },
      failure: (error, statusCode) {
        _logger.e('Failed to start workflow');
        throw error;
      },
    );
  }

  Future<WorkflowRunResponse> getRun(String runId) async {
    final response = await _apiExecutor.execute(
      ApiRequest(path: 'workflows/runs/$runId', method: HttpMethod.get),
    );
    return response.when(
      success: (data, statusCode, meta) {
        _logger.i('Workflow run retrieved');
        return WorkflowRunResponse.fromJson(data as Map<String, dynamic>);
      },
      failure: (error, statusCode) {
        _logger.e('Failed to retrieve workflow run');
        throw error;
      },
    );
  }

  Future<WorkflowRunResponse> submitApproval(
    String runId,
    SubmitApprovalRequest request,
  ) async {
    final response = await _apiExecutor.execute(
      ApiRequest(
        path: 'workflows/runs/$runId/approval',
        method: HttpMethod.post,
        data: request.toJson(),
        options: ApiConfig.workflowOptions(),
      ),
    );
    return response.when(
      success: (data, statusCode, meta) {
        _logger.i('Approval submitted');
        return WorkflowRunResponse.fromJson(data as Map<String, dynamic>);
      },
      failure: (error, statusCode) {
        _logger.e('Failed to submit approval');
        throw error;
      },
    );
  }
}
