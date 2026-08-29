import 'package:arzlyai_mobile/core/network/dto/response/preset/agent_harness_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/agent_model_configuration_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/agent_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/integration_requirement_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/model_option_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_details_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_summary_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/workflow_connection_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/workflow_graph_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/workflow_node_response.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';

class PresetMapper {
  const PresetMapper();

  PresetSummary summaryFromDto(PresetSummaryResponse dto) {
    return PresetSummary(
      id: dto.id,
      key: dto.key,
      name: dto.name,
      description: dto.description,
      version: dto.version,
    );
  }

  PresetDetails detailsFromDto(PresetDetailsResponse dto) {
    return PresetDetails(
      id: dto.id,
      key: dto.key,
      name: dto.name,
      description: dto.description,
      version: dto.version,
      agents: dto.agents.map(_agent).toList(),
      workflow: _graph(dto.workflow),
      integrations: dto.integrations.map(_integration).toList(),
    );
  }

  Agent _agent(AgentResponse dto) {
    return Agent(
      key: dto.key,
      name: dto.name,
      systemPrompt: dto.systemPrompt,
      isSystemPromptEditable: dto.isSystemPromptEditable,
      modelConfiguration: _model(dto.modelConfiguration),
      harness: _harness(dto.harness),
    );
  }

  AgentModelConfiguration _model(AgentModelConfigurationResponse dto) {
    return AgentModelConfiguration(
      provider: dto.provider,
      selectedModel: dto.selectedModel,
      availableModels: dto.availableModels.map(_option).toList(),
      isModelEditable: dto.isModelEditable,
      temperature: dto.temperature,
      minimumTemperature: dto.minimumTemperature,
      maximumTemperature: dto.maximumTemperature,
      isTemperatureEditable: dto.isTemperatureEditable,
    );
  }

  ModelOption _option(ModelOptionResponse dto) {
    return ModelOption(
      provider: dto.provider,
      model: dto.model,
      displayName: dto.displayName,
    );
  }

  AgentHarness _harness(AgentHarnessResponse dto) {
    return AgentHarness(
      planningEnabled: dto.planningEnabled,
      todoTrackingEnabled: dto.todoTrackingEnabled,
      contextCompactionEnabled: dto.contextCompactionEnabled,
      requiresToolApproval: dto.requiresToolApproval,
      maximumIterations: dto.maximumIterations,
    );
  }

  WorkflowGraph _graph(WorkflowGraphResponse dto) {
    final nodes = [...dto.nodes]..sort((a, b) => a.position.compareTo(b.position));
    return WorkflowGraph(
      key: dto.key,
      nodes: nodes.map(_node).toList(),
      connections: dto.connections.map(_connection).toList(),
    );
  }

  WorkflowNode _node(WorkflowNodeResponse dto) {
    return WorkflowNode(
      id: dto.id,
      key: dto.key,
      displayName: dto.displayName,
      type: dto.type,
      position: dto.position,
      requiresHumanApproval: dto.requiresHumanApproval,
    );
  }

  WorkflowConnection _connection(WorkflowConnectionResponse dto) {
    return WorkflowConnection(
      id: dto.id,
      sourceNodeId: dto.sourceNodeId,
      targetNodeId: dto.targetNodeId,
    );
  }

  IntegrationRequirement _integration(IntegrationRequirementResponse dto) {
    return IntegrationRequirement(
      key: dto.key,
      name: dto.name,
      description: dto.description,
      credentialSchemaJson: dto.credentialSchemaJson,
    );
  }
}
