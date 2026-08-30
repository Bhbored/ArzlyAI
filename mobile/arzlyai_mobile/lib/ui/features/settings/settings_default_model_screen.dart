import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/data/providers/models/provider_models_provider.dart';
import 'package:arzlyai_mobile/data/providers/settings/ai_settings_provider.dart';
import 'package:arzlyai_mobile/data/repositories/provider/provider_model_repository.dart';
import 'package:arzlyai_mobile/data/repositories/settings/ai_settings_repository.dart';
import 'package:arzlyai_mobile/domain/entities/provider/provider_model.dart';
import 'package:arzlyai_mobile/ui/features/settings/widgets/ai_provider_brand.dart';
import 'package:arzlyai_mobile/ui/features/settings/widgets/settings_grouped_list.dart';
import 'package:arzlyai_mobile/ui/features/settings/widgets/settings_model_tile.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';

class SettingsDefaultModelScreen extends ConsumerWidget {
  const SettingsDefaultModelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modelsAsync = ref.watch(availableProviderModelsProvider);
    final defaultModelAsync = ref.watch(defaultAiModelControllerProvider);
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Default model', style: theme.textTheme.h4),
      ),
      body: modelsAsync.when(
        loading: () => const AppScreenLoader(),
        error: (error, _) => Center(
          child: Padding(
            padding: EdgeInsets.all(context.paddingMedium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$error',
                  style: theme.textTheme.p.copyWith(
                    color: theme.colorScheme.destructive,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.spaceSmall),
                ShadButton.ghost(
                  onPressed: () => ref
                      .read(availableProviderModelsProvider.notifier)
                      .refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (models) => _DefaultModelBody(
          models: models,
          selected: defaultModelAsync.value,
        ),
      ),
    );
  }
}

class _DefaultModelBody extends ConsumerWidget {
  const _DefaultModelBody({
    required this.models,
    required this.selected,
  });

  final List<ProviderModel> models;
  final DefaultAiModel? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    if (models.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(context.paddingMedium),
          child: Text(
            'Add an API key first, then return here to pick a default model for presets.',
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final grouped = <String, List<ProviderModel>>{};
    for (final model in models) {
      grouped.putIfAbsent(model.provider, () => []).add(model);
    }

    final selectedId = selected?.modelId;
    final selectedModel = selectedId == null
        ? null
        : ref.read(providerModelRepositoryProvider).findModel(models, selectedId);

    return ListView(
      padding: EdgeInsets.all(context.paddingMedium),
      children: [
        Text(
          'Presets seed from this model when you configure a run.',
          style: theme.textTheme.muted.copyWith(
            color: theme.colorScheme.mutedForeground,
          ),
        ),
        if (selectedModel != null) ...[
          SizedBox(height: context.spaceMedium),
          _SelectedModelCard(model: selectedModel),
        ],
        SizedBox(height: context.spaceMedium),
        ...grouped.entries.map(
          (entry) => _ProviderModelGroup(
            providerKey: entry.key,
            models: entry.value,
            selectedId: selectedId,
            onSelect: (model) async {
              await ref
                  .read(defaultAiModelControllerProvider.notifier)
                  .save(provider: model.provider, modelId: model.id);
            },
          ),
        ),
      ],
    );
  }
}

class _SelectedModelCard extends StatelessWidget {
  const _SelectedModelCard({required this.model});

  final ProviderModel model;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Container(
      padding: EdgeInsets.all(context.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(context.borderRadiusLarge),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          AiProviderBrand(providerKey: model.provider),
          SizedBox(width: context.spaceSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current default',
                  style: theme.textTheme.small.copyWith(
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
                Text(
                  model.displayName,
                  style: theme.textTheme.p.copyWith(
                    color: theme.colorScheme.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderModelGroup extends StatelessWidget {
  const _ProviderModelGroup({
    required this.providerKey,
    required this.models,
    required this.selectedId,
    required this.onSelect,
  });

  final String providerKey;
  final List<ProviderModel> models;
  final String? selectedId;
  final ValueChanged<ProviderModel> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: context.spaceMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AiProviderBrand(providerKey: providerKey, size: 32),
              SizedBox(width: context.spaceSmall / 2),
              Text(
                AiProviderBrand.displayName(providerKey),
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            ],
          ),
          SizedBox(height: context.spaceSmall / 2),
          SettingsGroupedList(
            children: models
                .map(
                  (model) => SettingsModelTile(
                    model: model,
                    selected: model.id == selectedId,
                    onSelect: () => onSelect(model),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}
