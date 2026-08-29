import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/agent_override_request.dart';
import 'package:arzlyai_mobile/core/network/dto/security/credential_envelope.dart';

part 'start_workflow_request.freezed.dart';
part 'start_workflow_request.g.dart';

@freezed
sealed class StartWorkflowRequest with _$StartWorkflowRequest {
  const factory StartWorkflowRequest({
    required String presetKey,
    required Map<String, String> inputs,
    required List<AgentOverrideRequest> agentOverrides,
    required CredentialEnvelope credentials,
  }) = _StartWorkflowRequest;

  factory StartWorkflowRequest.fromJson(Map<String, dynamic> json) =>
      _$StartWorkflowRequestFromJson(json);
}
