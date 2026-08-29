import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/credentials/credential_schema.dart';
import 'package:arzlyai_mobile/domain/entities/credentials/credential_requirement.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';

extension PresetDetailsSupport on PresetDetails {
  Agent? agentForNode(WorkflowNode node) {
    return agents.where((agent) => agent.key == node.key).firstOrNull;
  }

  Agent? primaryWorkflowAgent() {
    final ordered = [...workflow.nodes]..sort((a, b) => a.position.compareTo(b.position));
    for (final node in ordered) {
      if (node.type != 'Agent') continue;
      final agent = agentForNode(node);
      if (agent != null) return agent;
    }
    return null;
  }

  Agent? configurableWorkflowAgent() {
    final ordered = [...workflow.nodes]..sort((a, b) => a.position.compareTo(b.position));
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

  List<CredentialRequirement> credentialRequirements() {
    final requirements = <CredentialRequirement>[];
    final seen = <String>{};

    for (final agent in agents) {
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
      final schemaFields =
          envelopeKeysForIntegration(integration.key, integration.credentialSchemaJson);
      for (final field in CredentialSchema.parse(integration.credentialSchemaJson).fields) {
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
            .map(
              (agent) => providerCredentialEnvelopeKey(agent.modelConfiguration.provider),
            )
            .toSet()
            .toList(growable: false);
      case CredentialPhase.editRequest:
        final writer = primaryWorkflowAgent();
        if (writer == null) return [];
        return [
          providerCredentialEnvelopeKey(writer.modelConfiguration.provider),
        ];
      case CredentialPhase.approval:
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
}

String humanizePresetToken(String value) {
  if (value.isEmpty) return value;
  final spaced = value
      .replaceAllMapped(RegExp('([a-z])([A-Z])'), (match) => '${match[1]} ${match[2]}')
      .replaceAll('_', ' ')
      .replaceAll('.', ' ')
      .toLowerCase();
  return spaced.isEmpty ? spaced : '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}
