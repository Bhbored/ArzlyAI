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
  test('ModelSelection_WhenShopperDefaults_InitializesMatchingAgentOverride', () {
    final agent = _agent(key: 'shop-and-recommend');
    final overrides = <String, AgentOverrideDraft>{
      agent.key: AgentOverrideDraft(
        model: agent.modelConfiguration.selectedModel,
      ),
    };
    expect(overrides['shop-and-recommend']?.model, 'gpt-5-mini');
  });

  test('StartRequest_WhenShopperConfigured_SendsKeyedOverride', () {
    final overrides = {
      'shop-and-recommend': const AgentOverrideDraft(model: 'gpt-4o-mini'),
    };
    expect(overrides.keys, hasLength(1));
    expect(overrides['shop-and-recommend']?.model, 'gpt-4o-mini');
  });
}
