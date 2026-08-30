import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/data/providers/models/provider_models_provider.dart';
import 'package:arzlyai_mobile/data/providers/settings/ai_settings_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/domain/entities/provider/provider_model.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_model_select.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_schedule_section.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_text_field.dart';
import 'package:arzlyai_mobile/ui/validators/app_validators.dart';

class ConfigureRunScreen extends ConsumerStatefulWidget {
  const ConfigureRunScreen({super.key});

  @override
  ConsumerState<ConfigureRunScreen> createState() => _ConfigureRunScreenState();
}

class _ConfigureRunScreenState extends ConsumerState<ConfigureRunScreen> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(availableProviderModelsProvider, (prev, next) {
      final details = ref.read(presetDetailsProvider).value;
      final writer = details?.configurableWorkflowAgent();
      if (writer == null) return;
      next.whenData((models) => _syncModelSelection(models, writer));
    }, fireImmediately: true);
  }

  void _syncModelSelection(List<ProviderModel> models, Agent writer) {
    if (models.isEmpty) return;
    final current = ref.read(runConfigTempProvider);
    final defaultModel = ref.read(defaultAiModelProvider).value;
    final presetDefault = writer.modelConfiguration.selectedModel;
    final modelIds = models.map((model) => model.id).toSet();
    if (current.model != null && modelIds.contains(current.model)) return;
    ProviderModel? chosenModel;
    if (defaultModel != null) {
      chosenModel = models
          .where(
            (model) =>
                model.id == defaultModel.modelId &&
                model.provider == defaultModel.provider,
          )
          .firstOrNull;
    }
    chosenModel ??= models
        .where((model) => model.id == presetDefault)
        .firstOrNull;
    chosenModel ??= models.first;
    ref.read(runConfigTempProvider.notifier).update(
      current.copyWith(
        provider: chosenModel.provider,
        model: chosenModel.id,
        temperature: chosenModel.supportsTemperature ? current.temperature : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(presetDetailsProvider).value;
    final config = ref.watch(runConfigTempProvider);
    final modelsAsync = ref.watch(availableProviderModelsProvider);
    final theme = ShadTheme.of(context);
    final writer = details?.configurableWorkflowAgent();
    final topicError = AppValidators.requiredNonEmpty(config.topic);
    final online = ref.watch(internetConnectionProvider);
    final offlineMode = ref.watch(offlineModeProvider).value ?? false;
    final modelsReady =
        writer == null ||
        !writer.modelConfiguration.isModelEditable ||
        modelsAsync.hasValue && modelsAsync.value!.isNotEmpty;
    final blocked =
        topicError != null || !online || offlineMode || !modelsReady;
    final selectedModelId =
        config.model ?? writer?.modelConfiguration.selectedModel;
    final selectedOnlineModel = modelsAsync.value
        ?.where((model) => model.id == selectedModelId)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(title: Text('Configure', style: theme.textTheme.h4)),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(availableProviderModelsProvider.notifier).refresh(),
        child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(context.paddingMedium),
            children: [
              AppTextField.topic(),
              if (writer != null &&
                  writer.modelConfiguration.isModelEditable) ...[
                SizedBox(height: context.spaceMedium),
                Text('Model', style: theme.textTheme.small),
                SizedBox(height: context.spaceSmall / 2),
                AppModelSelect(
                  enabled: true,
                  onRetry: () => ref
                      .read(availableProviderModelsProvider.notifier)
                      .refresh(),
                ),
              ],
              if (writer != null &&
                  selectedOnlineModel?.supportsTemperature == true) ...[
                SizedBox(height: context.spaceMedium),
                Text(
                  'Temperature ${config.temperature ?? writer.modelConfiguration.temperature}',
                  style: theme.textTheme.small,
                ),
                Slider(
                  min: writer.modelConfiguration.minimumTemperature,
                  max: writer.modelConfiguration.maximumTemperature,
                  value: AppValidators.clampTemperature(
                    config.temperature ?? writer.modelConfiguration.temperature,
                    writer.modelConfiguration.minimumTemperature,
                    writer.modelConfiguration.maximumTemperature,
                  ),
                  onChanged: (value) {
                    final current = ref.read(runConfigTempProvider);
                    ref
                        .read(runConfigTempProvider.notifier)
                        .update(current.copyWith(temperature: value));
                  },
                ),
              ],
              SizedBox(height: context.spaceMedium),
              const AppScheduleSection(),
              SizedBox(height: context.spaceLarge),
              AppButton.primary(
                label: 'Generate',
                onPressed: blocked
                    ? null
                    : () {
                        ref
                            .read(activeRunProvider.notifier)
                            .start(ref.read(runConfigTempProvider));
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
              ),
            ],
          ),
        ),
    );
  }
}
