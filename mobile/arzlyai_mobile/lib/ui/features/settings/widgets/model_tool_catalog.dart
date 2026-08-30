import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/domain/entities/provider/provider_model.dart';

class ModelToolDescriptor {
  const ModelToolDescriptor({
    required this.id,
    required this.label,
    required this.description,
    required this.supported,
    required this.icon,
  });

  final String id;
  final String label;
  final String description;
  final bool supported;
  final IconData icon;
}

List<ModelToolDescriptor> modelToolDescriptors(ProviderModel model) {
  final id = model.id.toLowerCase();
  return [
    ModelToolDescriptor(
      id: 'chat',
      label: 'Chat',
      description: 'Text generation for workflow agents.',
      supported: true,
      icon: LucideIcons.messagesSquare,
    ),
    ModelToolDescriptor(
      id: 'temperature',
      label: 'Temperature',
      description: 'Adjust creativity and randomness per run.',
      supported: model.supportsTemperature,
      icon: LucideIcons.thermometer,
    ),
    ModelToolDescriptor(
      id: 'web_search',
      label: 'Web search',
      description: 'Hosted browsing for research presets.',
      supported: model.supportsWebSearch,
      icon: LucideIcons.globe,
    ),
    ModelToolDescriptor(
      id: 'vision',
      label: 'Vision',
      description: 'Image understanding in prompts.',
      supported: _supportsVision(id),
      icon: LucideIcons.eye,
    ),
    ModelToolDescriptor(
      id: 'structured_output',
      label: 'Structured output',
      description: 'JSON schema responses for agent nodes.',
      supported: _supportsStructuredOutput(model.provider, id),
      icon: LucideIcons.braces,
    ),
    ModelToolDescriptor(
      id: 'reasoning',
      label: 'Reasoning',
      description: 'Extended thinking for complex tasks.',
      supported: _supportsReasoning(model.provider, id),
      icon: LucideIcons.brain,
    ),
  ];
}

String modelToolSummary(ProviderModel model) {
  final tools = modelToolDescriptors(model);
  final enabled = tools.where((tool) => tool.supported).length;
  return '$enabled of ${tools.length} tools available';
}

bool _supportsVision(String id) =>
    id.contains('vision') ||
    id.contains('multimodal') ||
    id.contains('-vl') ||
    id.contains('gpt-4o') ||
    id.contains('gemini-1.5') ||
    id.contains('gemini-2') ||
    id.contains('claude-3');

bool _supportsStructuredOutput(String provider, String id) {
  if (id.contains('embedding') || id.contains('whisper') || id.contains('tts')) {
    return false;
  }
  return switch (provider) {
    'openai' || 'anthropic' || 'gemini' || 'deepseek' => true,
    _ => false,
  };
}

bool _supportsReasoning(String provider, String id) {
  if (provider == 'openai' &&
      id.length >= 2 &&
      id.startsWith('o') &&
      RegExp(r'^o\d').hasMatch(id)) {
    return true;
  }
  if (provider == 'deepseek' &&
      (id.contains('reasoner') || id.contains('-r1') || id.endsWith('-pro'))) {
    return true;
  }
  return id.contains('claude-opus-4') || id.contains('claude-sonnet-4');
}
