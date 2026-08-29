import 'package:freezed_annotation/freezed_annotation.dart';

part 'agent_harness_response.freezed.dart';
part 'agent_harness_response.g.dart';

@freezed
sealed class AgentHarnessResponse with _$AgentHarnessResponse {
  const factory AgentHarnessResponse({
    required bool planningEnabled,
    required bool todoTrackingEnabled,
    required bool contextCompactionEnabled,
    required bool requiresToolApproval,
    required int maximumIterations,
  }) = _AgentHarnessResponse;

  factory AgentHarnessResponse.fromJson(Map<String, dynamic> json) =>
      _$AgentHarnessResponseFromJson(json);
}
