const supportedAiProviders = ['openai', 'anthropic', 'gemini', 'deepseek'];

String aiProviderDisplayName(String providerKey) => switch (providerKey) {
  'openai' => 'OpenAI',
  'anthropic' => 'Anthropic',
  'gemini' => 'Gemini',
  'deepseek' => 'DeepSeek',
  _ => providerKey,
};
