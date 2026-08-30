import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';

Agent _agent({
  required String key,
  String selectedModel = 'gpt-5-mini',
}) {
  return Agent(
    key: key,
    name: key,
    systemPrompt: 'prompt',
    isSystemPromptEditable: false,
    modelConfiguration: AgentModelConfiguration(
      provider: 'openai',
      selectedModel: selectedModel,
      availableModels: const [],
      isModelEditable: true,
      temperature: 0.2,
      minimumTemperature: 0,
      maximumTemperature: 1,
      isTemperatureEditable: false,
      supportsWebSearch: false,
    ),
    harness: const AgentHarness(
      planningEnabled: false,
      todoTrackingEnabled: false,
      contextCompactionEnabled: false,
      requiresToolApproval: false,
      maximumIterations: 4,
      webSearchEnabled: false,
    ),
  );
}

void main() {
  test('ModelSelection_WhenDropdownDefaults_InitializesMatchingAgentOverride', () {
    final agent = _agent(key: 'purchase-brief-architect');
    final overrides = <String, AgentOverrideDraft>{
      agent.key: AgentOverrideDraft(
        model: agent.modelConfiguration.selectedModel,
      ),
    };
    expect(overrides['purchase-brief-architect']?.model, 'gpt-5-mini');
  });

  test('StartRequest_WhenAgentsConfigured_SendsAllKeyedOverrides', () {
    final overrides = {
      'purchase-brief-architect': const AgentOverrideDraft(model: 'gpt-4o-mini'),
      'market-researcher': const AgentOverrideDraft(model: 'gpt-5-mini'),
      'report-composer': const AgentOverrideDraft(model: 'gpt-5-mini'),
    };
    expect(overrides.keys, hasLength(3));
    expect(overrides['purchase-brief-architect']?.model, 'gpt-4o-mini');
  });
}
