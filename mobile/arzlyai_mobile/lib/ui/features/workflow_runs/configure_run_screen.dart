import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/ui/features/workflow_runs/execution_screen.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_text_field.dart';
import 'package:arzlyai_mobile/ui/validators/app_validators.dart';

class ConfigureRunScreen extends ConsumerWidget {
  const ConfigureRunScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(presetDetailsProvider).value;
    final config = ref.watch(runConfigTempProvider);
    final run = ref.watch(activeRunProvider);
    final theme = ShadTheme.of(context);
    final writer = details?.configurableWorkflowAgent();
    final topicError = AppValidators.requiredNonEmpty(config.topic);
    final online = ref.watch(internetConnectionProvider);
    final offlineMode = ref.watch(offlineModeProvider).value ?? false;
    final busy = run.isLoading;
    final blocked = busy || topicError != null || !online || offlineMode;
    return Scaffold(
      appBar: AppBar(title: Text('Configure', style: theme.textTheme.h4)),
      body: ListView(
        padding: EdgeInsets.all(context.paddingMedium),
        children: [
          AppTextField.topic(),
          if (writer != null && writer.modelConfiguration.isModelEditable) ...[
            SizedBox(height: context.spaceMedium),
            Text('Model', style: theme.textTheme.small),
            ShadRadioGroup<String>(
              initialValue: config.model ?? writer.modelConfiguration.selectedModel,
              enabled: !busy,
              onChanged: (value) {
                if (value == null) return;
                final current = ref.read(runConfigTempProvider);
                final selected =
                    current.model ?? writer.modelConfiguration.selectedModel;
                if (value == selected) return;
                ref.read(runConfigTempProvider.notifier).update(
                  current.copyWith(model: value),
                );
              },
              items: writer.modelConfiguration.availableModels.map(
                (option) => ShadRadio<String>(
                  value: option.model,
                  label: Text(option.displayName, style: theme.textTheme.p),
                ),
              ),
            ),
          ],
          if (writer != null && writer.modelConfiguration.isTemperatureEditable) ...[
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
              onChanged: busy
                  ? null
                  : (value) {
                      final current = ref.read(runConfigTempProvider);
                      ref.read(runConfigTempProvider.notifier).update(
                        current.copyWith(temperature: value),
                      );
                    },
            ),
          ],
          SizedBox(height: context.spaceLarge),
          AppButton.primary(
            label: 'Generate',
            onPressed: blocked
                ? null
                : () async {
                    await ref.read(activeRunProvider.notifier).start(
                      ref.read(runConfigTempProvider),
                    );
                    if (!context.mounted) return;
                    final result = ref.read(activeRunProvider);
                    if (result.hasError || result.value == null) return;
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ExecutionScreen(),
                      ),
                    );
                  },
          ),
        ],
      ),
    );
  }
}
