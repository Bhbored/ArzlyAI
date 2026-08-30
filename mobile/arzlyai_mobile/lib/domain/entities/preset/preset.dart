import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/domain/entities/preset/approval_configuration.dart';
import 'package:arzlyai_mobile/domain/entities/preset/input_schema.dart';

part 'preset.freezed.dart';

@freezed
sealed class PresetSummary with _$PresetSummary {
  const factory PresetSummary({
    required String id,
    required String key,
    required String name,
    required String description,
    required int version,
  }) = _PresetSummary;
}

@freezed
sealed class ModelOption with _$ModelOption {
  const factory ModelOption({
    required String provider,
    required String model,
    required String displayName,
  }) = _ModelOption;
}

@freezed
sealed class AgentModelConfiguration with _$AgentModelConfiguration {
  const factory AgentModelConfiguration({
    required String provider,
    required String selectedModel,
    required List<ModelOption> availableModels,
    required bool isModelEditable,
    required double temperature,
    required double minimumTemperature,
    required double maximumTemperature,
    required bool isTemperatureEditable,
    required bool supportsWebSearch,
  }) = _AgentModelConfiguration;
}

@freezed
sealed class AgentHarness with _$AgentHarness {
  const factory AgentHarness({
    required bool planningEnabled,
    required bool todoTrackingEnabled,
    required bool contextCompactionEnabled,
    required bool requiresToolApproval,
    required int maximumIterations,
    required bool webSearchEnabled,
  }) = _AgentHarness;
}

@freezed
sealed class Agent with _$Agent {
  const factory Agent({
    required String key,
    required String name,
    required String systemPrompt,
    required bool isSystemPromptEditable,
    required AgentModelConfiguration modelConfiguration,
    required AgentHarness harness,
  }) = _Agent;
}

@freezed
sealed class WorkflowNode with _$WorkflowNode {
  const factory WorkflowNode({
    required String id,
    required String key,
    required String displayName,
    required String type,
    required int position,
    required bool requiresHumanApproval,
    String? configurationJson,
    ApprovalNodeConfiguration? approvalConfiguration,
    ResultContract? resultContract,
  }) = _WorkflowNode;
}

@freezed
sealed class WorkflowConnection with _$WorkflowConnection {
  const factory WorkflowConnection({
    required String id,
    required String sourceNodeId,
    required String targetNodeId,
  }) = _WorkflowConnection;
}

@freezed
sealed class WorkflowGraph with _$WorkflowGraph {
  const factory WorkflowGraph({
    required String key,
    required List<WorkflowNode> nodes,
    required List<WorkflowConnection> connections,
  }) = _WorkflowGraph;
}

@freezed
sealed class IntegrationRequirement with _$IntegrationRequirement {
  const factory IntegrationRequirement({
    required String key,
    required String name,
    required String description,
    required String credentialSchemaJson,
  }) = _IntegrationRequirement;
}

@freezed
sealed class ResultContract with _$ResultContract {
  const factory ResultContract({required String key, required int version}) =
      _ResultContract;
}

@freezed
sealed class PresetDetails with _$PresetDetails {
  const factory PresetDetails({
    required String id,
    required String key,
    required String name,
    required String description,
    required int version,
    required List<Agent> agents,
    required WorkflowGraph workflow,
    required List<IntegrationRequirement> integrations,
    PresetInputSchema? inputSchema,
    ResultContract? resultContract,
  }) = _PresetDetails;
}
