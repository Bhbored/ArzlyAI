import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/credentials/credential_schema.dart';
import 'package:arzlyai_mobile/core/enums/approval_decision.dart';
import 'package:arzlyai_mobile/core/workflow/brain_dump_preset_privacy.dart';
import 'package:arzlyai_mobile/domain/entities/credentials/credential_requirement.dart';
import 'package:arzlyai_mobile/domain/entities/preset/input_schema.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run_support.dart';

extension PresetDetailsSupport on PresetDetails {
  Agent? agentForNode(WorkflowNode node) {
    return agents.where((agent) => agent.key == node.key).firstOrNull;
  }

  Agent? primaryWorkflowAgent() {
    final ordered = [...workflow.nodes]
      ..sort((a, b) => a.position.compareTo(b.position));
    for (final node in ordered) {
      if (node.type != 'Agent') continue;
      final agent = agentForNode(node);
      if (agent != null) return agent;
    }
    return null;
  }

  WorkflowNode? entryWorkflowNode() {
    final ordered = [...workflow.nodes]
      ..sort((a, b) => a.position.compareTo(b.position));
    return ordered.firstOrNull;
  }

  Agent? configurableWorkflowAgent() {
    final ordered = [...workflow.nodes]
      ..sort((a, b) => a.position.compareTo(b.position));
    for (final node in ordered) {
      if (node.type != 'Agent') continue;
      final agent = agentForNode(node);
      if (agent == null) continue;
      if (agent.modelConfiguration.isModelEditable ||
          agent.modelConfiguration.isTemperatureEditable) {
        return agent;
      }
    }
    return primaryWorkflowAgent();
  }

  List<Agent> startupModelAgents() {
    final ordered = [...workflow.nodes]
      ..sort((a, b) => a.position.compareTo(b.position));
    final agents = <Agent>[];
    for (final node in ordered) {
      if (node.type == 'HumanApproval') break;
      if (node.type != 'Agent') continue;
      final agent = agentForNode(node);
      if (agent != null) agents.add(agent);
    }
    return agents;
  }

  List<CredentialRequirement> credentialRequirements() {
    final requirements = <CredentialRequirement>[];
    final seen = <String>{};

    for (final agent in agents) {
      if (!agent.modelConfiguration.isModelEditable) continue;
      final provider = agent.modelConfiguration.provider;
      final envelopeKey = providerCredentialEnvelopeKey(provider);
      if (seen.add(envelopeKey)) {
        requirements.add(
          CredentialRequirement(
            envelopeKey: envelopeKey,
            label: 'API key',
            groupKey: provider,
            groupLabel: humanizePresetToken(provider),
            obscure: true,
          ),
        );
      }
    }

    for (final integration in integrations) {
      final schemaFields = envelopeKeysForIntegration(
        integration.key,
        integration.credentialSchemaJson,
      );
      for (final field in CredentialSchema.parse(
        integration.credentialSchemaJson,
      ).fields) {
        final envelopeKey = integrationFieldEnvelopeKey(integration.key, field);
        if (!seen.add(envelopeKey)) continue;
        requirements.add(
          CredentialRequirement(
            envelopeKey: envelopeKey,
            label: humanizePresetToken(field),
            groupKey: integration.key,
            groupLabel: integration.name,
            obscure: credentialFieldShouldObscure(field),
          ),
        );
      }
      if (schemaFields.isEmpty && seen.add(integration.key)) {
        requirements.add(
          CredentialRequirement(
            envelopeKey: integration.key,
            label: humanizePresetToken(integration.key),
            groupKey: integration.key,
            groupLabel: integration.name,
            obscure: true,
          ),
        );
      }
    }

    return requirements;
  }

  List<String> envelopeKeysForPhase(CredentialPhase phase) {
    switch (phase) {
      case CredentialPhase.workflowStart:
        return agents
            .where((agent) => agent.modelConfiguration.isModelEditable)
            .map(
              (agent) => providerCredentialEnvelopeKey(
                agent.modelConfiguration.provider,
              ),
            )
            .toSet()
            .toList(growable: false);
      case CredentialPhase.editRequest:
        final writer = primaryWorkflowAgent();
        if (writer == null || !writer.modelConfiguration.isModelEditable) {
          return [];
        }
        return [
          providerCredentialEnvelopeKey(writer.modelConfiguration.provider),
        ];
      case CredentialPhase.approval:
        if (integrations.isEmpty) {
          return agents
              .where((agent) => agent.modelConfiguration.isModelEditable)
              .map(
                (agent) => providerCredentialEnvelopeKey(
                  agent.modelConfiguration.provider,
                ),
              )
              .toSet()
              .toList(growable: false);
        }
        return integrations
            .expand(
              (integration) => envelopeKeysForIntegration(
                integration.key,
                integration.credentialSchemaJson,
              ),
            )
            .toList(growable: false);
    }
  }

  List<String> workflowStartCredentialKeys({
    Iterable<String> overrideProviders = const [],
  }) {
    final keys = overrideProviders
        .where((provider) => provider.isNotEmpty)
        .map(providerCredentialEnvelopeKey)
        .toSet();
    if (keys.isEmpty) {
      keys.addAll(envelopeKeysForPhase(CredentialPhase.workflowStart));
    }
    keys.addAll(_startupIntegrationCredentialKeys());
    return keys.toList(growable: false);
  }

  List<String> _startupIntegrationCredentialKeys() {
    final ordered = [...workflow.nodes]
      ..sort((a, b) => a.position.compareTo(b.position));
    final keys = <String>{};
    for (final node in ordered) {
      if (node.type == 'HumanApproval') break;
      if (node.type != 'Integration') continue;
      final integration = integrations
          .where((item) => item.key == node.key)
          .firstOrNull;
      if (integration == null) continue;
      keys.addAll(
        envelopeKeysForIntegration(
          integration.key,
          integration.credentialSchemaJson,
        ),
      );
    }
    return keys.toList(growable: false);
  }

  List<String> approvalCredentialKeys({
    required WorkflowRun run,
    required ApprovalDecision decision,
    Map<String, String> overrideProvidersByAgent = const {},
    Map<String, String> workflowInputs = const {},
  }) {
    switch (decision) {
      case ApprovalDecision.reject:
        return [];
      case ApprovalDecision.edit:
        final approvalIndex = run.waitingApprovalIndex();
        if (approvalIndex == null) return [];
        final agentIndex = run.agentIndexBeforeApproval(approvalIndex);
        if (agentIndex == null) return [];
        return _modelCredentialKeysForAgents(
          [run.nodes[agentIndex].nodeKey],
          run,
          overrideProvidersByAgent,
        );
      case ApprovalDecision.accept:
        final approvalIndex = run.waitingApprovalIndex();
        if (approvalIndex == null) return [];
        if (!run.hasRemainingWorkAfterApproval(approvalIndex)) return [];
        if (isBrainDumpWorkflowKey(key)) {
          return _brainDumpAcceptCredentialKeys(workflowInputs);
        }
        if (run.hasRemainingIntegrationAfterApproval(approvalIndex)) {
          return envelopeKeysForPhase(CredentialPhase.approval);
        }
        if (overrideProvidersByAgent.isNotEmpty) {
          return workflowStartCredentialKeys(
            overrideProviders: overrideProvidersByAgent.values,
          );
        }
        final nextAgentIndex = run.nextAgentIndexAfterApproval(approvalIndex);
        if (nextAgentIndex == null) return [];
        return _modelCredentialKeysForAgents(
          [run.nodes[nextAgentIndex].nodeKey],
          run,
          overrideProvidersByAgent,
        );
    }
  }

  List<String> _brainDumpAcceptCredentialKeys(Map<String, String> workflowInputs) {
    if (!brainDumpSyncEnabled(workflowInputs)) return [];
    final keys = <String>{};
    for (final integration in integrations) {
      final enabled = switch (integration.key) {
        'google.tasks.create' => workflowInputs['syncTasks'] == 'true',
        'google.calendar.create-events' =>
          workflowInputs['syncCalendar'] == 'true',
        'google.gmail.send-html' => workflowInputs['sendEmail'] == 'true',
        _ => false,
      };
      if (!enabled) continue;
      keys.addAll(
        envelopeKeysForIntegration(
          integration.key,
          integration.credentialSchemaJson,
        ),
      );
    }
    return keys.toList(growable: false);
  }

  List<String> _modelCredentialKeysForAgents(
    Iterable<String> agentKeys,
    WorkflowRun run,
    Map<String, String> overrideProvidersByAgent,
  ) {
    final keys = <String>{};
    for (final agentKey in agentKeys) {
      final provider = resolveProviderForAgent(
        agentKey: agentKey,
        run: run,
        overrideProvidersByAgent: overrideProvidersByAgent,
      );
      if (provider != null && provider.isNotEmpty) {
        keys.add(providerCredentialEnvelopeKey(provider));
      }
    }
    return keys.toList(growable: false);
  }

  String? resolveProviderForAgent({
    required String agentKey,
    required WorkflowRun run,
    Map<String, String> overrideProvidersByAgent = const {},
  }) {
    final overrideProvider = overrideProvidersByAgent[agentKey];
    if (overrideProvider != null && overrideProvider.isNotEmpty) {
      return overrideProvider;
    }
    final node = run.nodes.where((item) => item.nodeKey == agentKey).firstOrNull;
    if (node?.effectiveProvider != null && node!.effectiveProvider!.isNotEmpty) {
      return node.effectiveProvider;
    }
    final configurable = configurableWorkflowAgent();
    if (configurable != null) {
      final configured = overrideProvidersByAgent[configurable.key];
      if (configured != null && configured.isNotEmpty) {
        return configured;
      }
    }
    for (final candidate in run.nodes) {
      if (candidate.type != 'Agent') continue;
      final provider = candidate.effectiveProvider;
      if (provider != null && provider.isNotEmpty) {
        return provider;
      }
    }
    final agent = agents.where((item) => item.key == agentKey).firstOrNull;
    return agent?.modelConfiguration.provider;
  }
}

extension PresetInputSchemaSupport on PresetInputSchema {
  String? primaryInputKey() {
    final primary = presentation?.primaryField?.trim();
    if (primary != null && primary.isNotEmpty) return primary;
    for (final field in fields) {
      if (field.required) return field.key;
    }
    return fields.firstOrNull?.key;
  }

  PresetInputField? fieldForKey(String key) {
    return fields.where((field) => field.key == key).firstOrNull;
  }

  PresetInputField? get analysisModeField => fieldForKey('analysisMode');

  List<PresetInputFieldOption> get analysisModeOptions =>
      analysisModeField?.options ?? const [];

  PresetInputFieldOption? analysisModeOption(String value) {
    return analysisModeOptions
        .where((option) => option.value == value)
        .firstOrNull;
  }

  bool isFieldVisible(PresetInputField field, Map<String, String> inputs) {
    final when = field.visibleWhen;
    if (when == null) return true;
    final current = inputs[when.field]?.trim() ?? '';
    return when.equalsAny.contains(current);
  }

  Set<String> activeRequiresFields(Map<String, String> inputs) {
    final mode = inputs['analysisMode']?.trim() ?? '';
    final option = analysisModeOption(mode);
    if (option == null) return {};
    return option.requiresFields.toSet();
  }
}

String humanizePresetToken(String value) {
  if (value.isEmpty) return value;
  final spaced = value
      .replaceAllMapped(
        RegExp('([a-z])([A-Z])'),
        (match) => '${match[1]} ${match[2]}',
      )
      .replaceAll('_', ' ')
      .replaceAll('.', ' ')
      .toLowerCase();
  return spaced.isEmpty
      ? spaced
      : '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}
