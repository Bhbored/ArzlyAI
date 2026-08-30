import 'package:freezed_annotation/freezed_annotation.dart';

part 'agent_override_request.freezed.dart';
part 'agent_override_request.g.dart';

@freezed
sealed class AgentOverrideRequest with _$AgentOverrideRequest {
  const factory AgentOverrideRequest({
    required String agentKey,
    String? provider,
    String? model,
    double? temperature,
  }) = _AgentOverrideRequest;

  factory AgentOverrideRequest.fromJson(Map<String, dynamic> json) =>
      _$AgentOverrideRequestFromJson(json);
}
