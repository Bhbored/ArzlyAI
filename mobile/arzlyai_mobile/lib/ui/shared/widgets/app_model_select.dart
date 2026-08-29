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
    super.key,
  });

  final bool enabled;
  final VoidCallback onRetry;

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
        final selectedId = _selectedId(config.model, models);
        final labelFor = {
          for (final model in models) model.id: model.displayName,
        };
        return ShadSelect<String>(
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
              .map(
                (model) => ShadOption(
                  value: model.id,
                  child: Text(model.displayName, style: theme.textTheme.p),
                ),
              )
              .toList(),
        );
      },
    );
  }

  String _selectedId(String? configModel, List<OpenAiModel> models) {
    if (configModel != null && models.any((model) => model.id == configModel)) {
      return configModel;
    }
    return models.first.id;
  }

  void _applyModel(WidgetRef ref, String modelId, List<OpenAiModel> models) {
    final current = ref.read(runConfigTempProvider);
    if (modelId == current.model) return;
    final supports =
        models.where((model) => model.id == modelId).firstOrNull?.supportsTemperature ??
        false;
    ref.read(runConfigTempProvider.notifier).update(
      current.copyWith(
        model: modelId,
        temperature: supports ? current.temperature : null,
      ),
    );
  }
}
