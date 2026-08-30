import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/data/providers/models/openai_models_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/domain/entities/provider/openai_model.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';

class AppModelSelect extends ConsumerWidget {
  const AppModelSelect({
    required this.enabled,
    required this.onRetry,
    this.agentKey,
    this.defaultModelId,
    this.requiresWebSearch = false,
    super.key,
  });

  factory AppModelSelect.forAgent({
    required String agentKey,
    required String defaultModelId,
    required bool requiresWebSearch,
    required bool enabled,
    required VoidCallback onRetry,
  }) =>
      AppModelSelect(
        enabled: enabled,
        onRetry: onRetry,
        agentKey: agentKey,
        defaultModelId: defaultModelId,
        requiresWebSearch: requiresWebSearch,
      );

  final bool enabled;
  final VoidCallback onRetry;
  final String? agentKey;
  final String? defaultModelId;
  final bool requiresWebSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modelsAsync = ref.watch(openAiModelsProvider);
    final config = ref.watch(runConfigTempProvider);
    final theme = ShadTheme.of(context);

    return modelsAsync.when(
      loading: () => const AppScreenLoader(),
      error: (error, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$error', style: theme.textTheme.muted),
          ShadButton.ghost(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
      data: (models) {
        if (models.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('No models available.', style: theme.textTheme.muted),
              ShadButton.ghost(onPressed: onRetry, child: const Text('Retry')),
            ],
          );
        }
        final selectedId = _selectedId(config, models);
        final labelFor = {
          for (final model in models) model.id: model.displayName,
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (requiresWebSearch)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'This agent requires hosted web search.',
                  style: theme.textTheme.muted.copyWith(
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
              ),
            ShadSelect<String>(
              key: ValueKey(selectedId),
              enabled: enabled,
              initialValue: selectedId,
              placeholder: const Text('Select a model'),
              selectedOptionBuilder: (context, value) =>
                  Text(labelFor[value] ?? value, style: theme.textTheme.p),
              onChanged: (value) {
                if (value == null) return;
                _applyModel(ref, value, models);
              },
              options: models
                  .where(
                    (model) =>
                        !requiresWebSearch || model.supportsWebSearch,
                  )
                  .map(
                    (model) => ShadOption(
                      value: model.id,
                      child: Text(model.displayName, style: theme.textTheme.p),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  String _selectedId(RunConfigState config, List<OpenAiModel> models) {
    final configured = agentKey == null
        ? config.model
        : config.agentOverrides[agentKey!]?.model;
    final fallback = defaultModelId ?? configured;
    if (fallback != null && models.any((model) => model.id == fallback)) {
      return fallback;
    }
    if (configured != null && models.any((model) => model.id == configured)) {
      return configured;
    }
    return models.first.id;
  }

  void _applyModel(WidgetRef ref, String modelId, List<OpenAiModel> models) {
    final model = models.where((item) => item.id == modelId).firstOrNull;
    if (model == null) return;
    if (requiresWebSearch && !model.supportsWebSearch) return;
    final current = ref.read(runConfigTempProvider);
    if (agentKey == null) {
      if (modelId == current.model) return;
      ref.read(runConfigTempProvider.notifier).update(
        current.copyWith(
          model: modelId,
          temperature: model.supportsTemperature ? current.temperature : null,
        ),
      );
      return;
    }
    final existing = current.agentOverrides[agentKey!];
    if (existing?.model == modelId) return;
    final overrides = Map<String, AgentOverrideDraft>.from(
      current.agentOverrides,
    );
    overrides[agentKey!] = (existing ?? const AgentOverrideDraft()).copyWith(
      model: modelId,
      temperature: model.supportsTemperature ? existing?.temperature : null,
    );
    ref.read(runConfigTempProvider.notifier).update(
      current.copyWith(agentOverrides: overrides),
    );
  }
}
