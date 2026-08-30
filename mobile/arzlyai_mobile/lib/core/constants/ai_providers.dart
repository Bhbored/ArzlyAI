const supportedAiProviders = ['openai', 'anthropic', 'gemini', 'deepseek'];

String? inferAiProviderFromModel(String model) {
  final normalized = model.toLowerCase();
  if (normalized.startsWith('claude')) return 'anthropic';
  if (normalized.startsWith('gemini') ||
      normalized.startsWith('models/gemini')) {
    return 'gemini';
  }
  if (normalized.startsWith('deepseek')) return 'deepseek';
  if (normalized.startsWith('gpt') ||
      normalized.startsWith('chatgpt') ||
      normalized.startsWith('o1') ||
      normalized.startsWith('o3') ||
      normalized.startsWith('o4')) {
    return 'openai';
  }
  return null;
}

String aiProviderDisplayName(String providerKey) => switch (providerKey) {
  'openai' => 'OpenAI',
  'anthropic' => 'Anthropic',
  'gemini' => 'Gemini',
  'deepseek' => 'DeepSeek',
  _ => providerKey,
};
