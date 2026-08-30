import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/data/providers/models/provider_models_provider.dart';
import 'package:arzlyai_mobile/data/providers/models/providers_catalog_provider.dart';
import 'package:arzlyai_mobile/data/providers/settings/ai_settings_provider.dart';
import 'package:arzlyai_mobile/data/providers/settings/settings_provider.dart';
import 'package:arzlyai_mobile/data/repositories/provider/provider_model_repository.dart';
import 'package:arzlyai_mobile/data/repositories/settings/ai_settings_repository.dart';
import 'package:arzlyai_mobile/domain/entities/provider/provider_model.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_connector_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_credential_field.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsControllerProvider);
    final providersAsync = ref.watch(providersCatalogProvider);
    final modelsAsync = ref.watch(availableProviderModelsProvider);
    final defaultModelAsync = ref.watch(defaultAiModelProvider);
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: theme.textTheme.h4)),
      body: ListView(
        padding: EdgeInsets.all(context.paddingMedium),
        children: [
          Text('Connectors', style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall),
          AppConnectorCard.linkedin(),
          SizedBox(height: context.spaceMedium),
          Text('AI providers', style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall),
          providersAsync.when(
            data: (providers) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: providers
                  .map(
                    (provider) => Padding(
                      padding: EdgeInsets.only(bottom: context.spaceSmall),
                      child: AppCredentialField(
                        envelopeKey: providerCredentialEnvelopeKey(provider.key),
                        label: '${provider.displayName} API key',
                        obscureText: true,
                      ),
                    ),
                  )
                  .toList(),
            ),
            loading: () => const AppScreenLoader(),
            error: (error, _) => Text(
              '$error',
              style: theme.textTheme.p.copyWith(
                color: theme.colorScheme.destructive,
              ),
            ),
          ),
          SizedBox(height: context.spaceMedium),
          Text('Default model', style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall),
          modelsAsync.when(
            loading: () => const AppScreenLoader(),
            error: (error, _) => Text(
              '$error',
              style: theme.textTheme.p.copyWith(
                color: theme.colorScheme.destructive,
              ),
            ),
            data: (models) => _DefaultModelSection(
              models: models,
              selected: defaultModelAsync.value,
            ),
          ),
          SizedBox(height: context.spaceLarge),
          AppButton.primary(
            label: 'Save',
            onPressed: () async {
              await ref.read(settingsControllerProvider.notifier).save();
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _DefaultModelSection extends ConsumerWidget {
  const _DefaultModelSection({
    required this.models,
    required this.selected,
  });

  final List<ProviderModel> models;
  final DefaultAiModel? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    if (models.isEmpty) {
      return Text(
        'Save an API key above to load models.',
        style: theme.textTheme.muted.copyWith(
          color: theme.colorScheme.mutedForeground,
        ),
      );
    }
    final selectedId = selected?.modelId;
    final selectedModel = selectedId == null
        ? null
        : ref
            .read(providerModelRepositoryProvider)
            .findModel(models, selectedId);
    final grouped = <String, List<ProviderModel>>{};
    for (final model in models) {
      grouped.putIfAbsent(model.provider, () => []).add(model);
    }
    final options = grouped.entries
        .expand(
          (entry) => entry.value.map(
            (model) => ShadOption(
              value: model.id,
              child: Text(
                '${model.displayName} (${model.provider})',
                style: theme.textTheme.p,
              ),
            ),
          ),
        )
        .toList();
    final initial = selectedId != null && models.any((m) => m.id == selectedId)
        ? selectedId
        : models.first.id;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShadSelect<String>(
          key: ValueKey(initial),
          initialValue: initial,
          placeholder: const Text('Select a default model'),
          selectedOptionBuilder: (context, value) {
            final model = ref
                .read(providerModelRepositoryProvider)
                .findModel(models, value);
            return Text(
              model == null ? value : '${model.displayName} (${model.provider})',
              style: theme.textTheme.p,
            );
          },
          onChanged: (value) async {
            if (value == null) return;
            final model = ref
                .read(providerModelRepositoryProvider)
                .findModel(models, value);
            if (model == null) return;
            await ref
                .read(defaultAiModelControllerProvider.notifier)
                .save(provider: model.provider, modelId: model.id);
          },
          options: options,
        ),
        if (selectedModel != null) ...[
          SizedBox(height: context.spaceSmall),
          Wrap(
            spacing: context.spaceSmall,
            runSpacing: context.spaceSmall / 2,
            children: [
              if (selectedModel.supportsTemperature)
                ShadBadge.outline(child: Text('Temperature', style: theme.textTheme.small)),
              if (selectedModel.supportsWebSearch)
                ShadBadge.outline(child: Text('Web search', style: theme.textTheme.small)),
            ],
          ),
        ],
      ],
    );
  }
}
