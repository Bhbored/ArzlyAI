import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/data/providers/models/provider_models_provider.dart';
import 'package:arzlyai_mobile/data/providers/settings/ai_settings_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/repositories/provider/provider_model_repository.dart';
import 'package:arzlyai_mobile/data/repositories/settings/ai_settings_repository.dart';
import 'package:arzlyai_mobile/domain/entities/provider/provider_model.dart';
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
    final modelsAsync = ref.watch(availableProviderModelsProvider);
    final config = ref.watch(runConfigTempProvider);
    final defaultModel = ref.watch(defaultAiModelProvider).value;
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
        final filtered = models
            .where(
              (model) => !requiresWebSearch || model.supportsWebSearch,
            )
            .toList();
        if (filtered.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                requiresWebSearch
                    ? 'No models with web search. Add another provider key in Settings.'
                    : 'No models available.',
                style: theme.textTheme.muted,
              ),
              ShadButton.ghost(onPressed: onRetry, child: const Text('Retry')),
            ],
          );
        }
        final selectedId = _selectedId(
          config,
          filtered,
          defaultModel,
        );
        final labelFor = {
          for (final model in filtered)
            model.id: '${model.displayName} (${model.provider})',
        };
        final selectedModel = ref
            .read(providerModelRepositoryProvider)
            .findModel(filtered, selectedId);
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
                _applyModel(ref, value, filtered);
              },
              options: filtered
                  .map(
                    (model) => ShadOption(
                      value: model.id,
                      child: Text(
                        labelFor[model.id] ?? model.displayName,
                        style: theme.textTheme.p,
                      ),
                    ),
                  )
                  .toList(),
            ),
            if (selectedModel != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (selectedModel.supportsTemperature)
                    ShadBadge.outline(
                      child: Text('Temperature', style: theme.textTheme.small),
                    ),
                  if (requiresWebSearch && selectedModel.supportsWebSearch)
                    ShadBadge.outline(
                      child: Text('Web search', style: theme.textTheme.small),
                    ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  String _selectedId(
    RunConfigState config,
    List<ProviderModel> models,
    DefaultAiModel? defaultModel,
  ) {
    final configured = agentKey == null
        ? config.model
        : config.agentOverrides[agentKey!]?.model;
    final configuredProvider = agentKey == null
        ? config.provider
        : config.agentOverrides[agentKey!]?.provider;
    if (configured != null &&
        models.any(
          (model) =>
              model.id == configured &&
              (configuredProvider == null || model.provider == configuredProvider),
        )) {
      return configured;
    }
    if (defaultModel != null &&
        models.any(
          (model) =>
              model.id == defaultModel.modelId &&
              model.provider == defaultModel.provider &&
              (!requiresWebSearch || model.supportsWebSearch),
        )) {
      return defaultModel.modelId;
    }
    final fallback = defaultModelId;
    if (fallback != null && models.any((model) => model.id == fallback)) {
      return fallback;
    }
    return models.first.id;
  }

  void _applyModel(WidgetRef ref, String modelId, List<ProviderModel> models) {
    final model = ref.read(providerModelRepositoryProvider).findModel(
          models,
          modelId,
        );
    if (model == null) return;
    if (requiresWebSearch && !model.supportsWebSearch) return;
    final current = ref.read(runConfigTempProvider);
    if (agentKey == null) {
      if (modelId == current.model && model.provider == current.provider) {
        return;
      }
      ref.read(runConfigTempProvider.notifier).update(
        current.copyWith(
          provider: model.provider,
          model: modelId,
          temperature: model.supportsTemperature ? current.temperature : null,
        ),
      );
      return;
    }
    final existing = current.agentOverrides[agentKey!];
    if (existing?.model == modelId && existing?.provider == model.provider) {
      return;
    }
    final overrides = Map<String, AgentOverrideDraft>.from(
      current.agentOverrides,
    );
    overrides[agentKey!] = (existing ?? const AgentOverrideDraft()).copyWith(
      provider: model.provider,
      model: modelId,
      temperature: model.supportsTemperature ? existing?.temperature : null,
    );
    ref.read(runConfigTempProvider.notifier).update(
      current.copyWith(agentOverrides: overrides),
    );
  }
}
