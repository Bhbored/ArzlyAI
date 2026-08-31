import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/brain_dump_to_action/brain_dump_run_config.dart';
import 'package:arzlyai_mobile/data/providers/models/provider_models_provider.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/settings/ai_settings_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/domain/entities/provider/provider_model.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/brain_dump_to_action/preset_key.dart';
import 'package:arzlyai_mobile/ui/features/presets/preset_run_router.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_brain_dump_schedule_section.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_model_select.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_status.dart';

class BrainDumpConfigureRunScreen extends ConsumerStatefulWidget {
  const BrainDumpConfigureRunScreen({super.key});

  @override
  ConsumerState<BrainDumpConfigureRunScreen> createState() =>
      _BrainDumpConfigureRunScreenState();
}

class _BrainDumpConfigureRunScreenState
    extends ConsumerState<BrainDumpConfigureRunScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _seedDefaults());
    ref.listenManual(availableProviderModelsProvider, (prev, next) {
      final details = ref.read(presetDetailsProvider).value;
      final planner = details?.configurableWorkflowAgent();
      if (planner == null) return;
      next.whenData((models) => _syncModelSelection(models, planner));
    }, fireImmediately: true);
  }

  void _seedDefaults() {
    final current = ref.read(runConfigTempProvider);
    if (current.inputs.isNotEmpty) return;
    final today = DateTime.now();
    final date =
        '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';
    ref.read(runConfigTempProvider.notifier).update(
      current.copyWith(
        topic: 'Brain dump plan',
        inputs: {
          'brainDump': '',
          'asOfDate': date,
          'workingHoursStart': '09:00',
          'workingHoursEnd': '17:00',
          'energyPreference': 'morning',
          'syncTasks': 'false',
          'syncCalendar': 'false',
          'sendEmail': 'false',
          'recipientEmail': '',
          'taskListTitle': 'ArzlyAI',
          'calendarId': 'primary',
        },
      ),
    );
  }

  void _syncModelSelection(List<ProviderModel> models, Agent planner) {
    if (models.isEmpty) return;
    final current = ref.read(runConfigTempProvider);
    final existing = current.agentOverrides[planner.key];
    if (existing?.model != null &&
        models.any(
          (model) =>
              model.id == existing!.model &&
              (existing.provider == null ||
                  model.provider == existing.provider),
        )) {
      return;
    }
    final defaultModel = ref.read(defaultAiModelProvider).value;
    ProviderModel? selected;
    if (defaultModel != null) {
      selected = models
          .where(
            (model) =>
                model.id == defaultModel.modelId &&
                model.provider == defaultModel.provider,
          )
          .firstOrNull;
    }
    selected ??= models
        .where(
          (model) =>
              model.id == planner.modelConfiguration.selectedModel &&
              model.provider == planner.modelConfiguration.provider,
        )
        .firstOrNull;
    selected ??= models.first;
    final overrides = Map<String, AgentOverrideDraft>.from(
      current.agentOverrides,
    );
    overrides[planner.key] = AgentOverrideDraft(
      provider: selected.provider,
      model: selected.id,
      temperature:
          selected.supportsTemperature &&
              planner.modelConfiguration.isTemperatureEditable
          ? planner.modelConfiguration.temperature
          : null,
    );
    ref
        .read(runConfigTempProvider.notifier)
        .update(current.copyWith(agentOverrides: overrides));
  }

  void _updateInput(String key, String value) {
    final current = ref.read(runConfigTempProvider);
    final inputs = Map<String, String>.from(current.inputs)..[key] = value;
    ref
        .read(runConfigTempProvider.notifier)
        .update(current.copyWith(inputs: inputs));
  }

  void _toggleInput(String key, bool value) {
    _updateInput(key, value.toString());
  }

  Future<void> _start(PresetDetails details, RunConfigState config) async {
    setState(() => _error = null);
    final prepared = prepareBrainDumpRunConfig(config: config, details: details);
    if (prepared.error != null) {
      setState(() => _error = prepared.error);
      return;
    }
    await ref.read(activeRunProvider.notifier).start(prepared.config!);
    if (!mounted) return;
    final runState = ref.read(activeRunProvider);
    if (runState.hasError) {
      setState(() => _error = '${runState.error}');
      return;
    }
    final execution = executionScreenForPreset(BrainDumpToActionPreset.key);
    if (execution == null) {
      Navigator.of(context).pop();
      return;
    }
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => execution));
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(presetDetailsProvider);
    final config = ref.watch(runConfigTempProvider);
    final theme = ShadTheme.of(context);
    final online = ref.watch(internetConnectionProvider);
    final offlineMode = ref.watch(offlineModeProvider).value ?? false;
    final planner = details.value?.configurableWorkflowAgent();

    return details.when(
      data: (value) {
        if (value == null) {
          return const AppStatus.error(message: 'Preset unavailable.');
        }
        final inputs = config.inputs;
        return ListView(
          padding: EdgeInsets.all(context.paddingMedium),
          children: [
            AppCard.standard(
              title: 'What is on your mind?',
              child: ShadInput(
                initialValue: inputs['brainDump'] ?? '',
                placeholder: const Text('Type everything you need to get done…'),
                maxLines: 8,
                onChanged: (value) => _updateInput('brainDump', value),
              ),
            ),
            SizedBox(height: context.spaceMedium),
            AppCard.standard(
              title: 'Planning window',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Plan date', style: theme.textTheme.small),
                  SizedBox(height: context.spaceSmall / 2),
                  ShadInput(
                    initialValue: inputs['asOfDate'] ?? '',
                    placeholder: const Text('2026-08-31'),
                    onChanged: (value) => _updateInput('asOfDate', value),
                  ),
                  SizedBox(height: context.spaceMedium),
                  Text('Working hours', style: theme.textTheme.small),
                  SizedBox(height: context.spaceSmall / 2),
                  Row(
                    children: [
                      Expanded(
                        child: ShadInput(
                          initialValue: inputs['workingHoursStart'] ?? '',
                          placeholder: const Text('09:00'),
                          onChanged: (value) =>
                              _updateInput('workingHoursStart', value),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spaceSmall,
                        ),
                        child: Text('to', style: theme.textTheme.muted),
                      ),
                      Expanded(
                        child: ShadInput(
                          initialValue: inputs['workingHoursEnd'] ?? '',
                          placeholder: const Text('17:00'),
                          onChanged: (value) =>
                              _updateInput('workingHoursEnd', value),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.spaceMedium),
                  Text('Energy preference', style: theme.textTheme.small),
                  SizedBox(height: context.spaceSmall / 2),
                  ShadInput(
                    initialValue: inputs['energyPreference'] ?? '',
                    placeholder: const Text('morning / afternoon / evening'),
                    onChanged: (value) =>
                        _updateInput('energyPreference', value),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.spaceMedium),
            if (planner != null && planner.modelConfiguration.isModelEditable)
              AppCard.standard(
                title: 'Planner model',
                child: AppModelSelect.forAgent(
                  agentKey: planner.key,
                  defaultModelId: planner.modelConfiguration.selectedModel,
                  requiresWebSearch: planner.harness.webSearchEnabled,
                  enabled: true,
                  onRetry: () => ref
                      .read(availableProviderModelsProvider.notifier)
                      .refresh(),
                ),
              ),
            SizedBox(height: context.spaceMedium),
            AppCard.standard(
              title: 'After approval (saved for schedules)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ShadCheckbox(
                    value: inputs['syncTasks'] == 'true',
                    onChanged: (value) =>
                        _toggleInput('syncTasks', value),
                    label: const Text('Sync Google Tasks'),
                  ),
                  ShadCheckbox(
                    value: inputs['syncCalendar'] == 'true',
                    onChanged: (value) =>
                        _toggleInput('syncCalendar', value),
                    label: const Text('Create Google Calendar events'),
                  ),
                  ShadCheckbox(
                    value: inputs['sendEmail'] == 'true',
                    onChanged: (value) => _toggleInput('sendEmail', value),
                    label: const Text('Email the plan with Gmail'),
                  ),
                  SizedBox(height: context.spaceSmall),
                  ShadInput(
                    initialValue: inputs['recipientEmail'] ?? '',
                    placeholder: const Text('name@example.com'),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => _updateInput('recipientEmail', value),
                  ),
                  SizedBox(height: context.spaceSmall),
                  Text(
                    'Run now is preview only. Sync settings apply when you '
                    'approve during a scheduled run.',
                    style: theme.textTheme.muted,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.spaceMedium),
            const AppBrainDumpScheduleSection(),
            if (_error != null) ...[
              SizedBox(height: context.spaceMedium),
              Text(_error!, style: theme.textTheme.muted),
            ],
            SizedBox(height: context.spaceMedium),
            AppButton.primary(
              label: 'Generate plan',
              onPressed: !online || offlineMode
                  ? null
                  : () => _start(value, config),
            ),
          ],
        );
      },
      loading: () => const AppStatus.loading(),
      error: (error, _) => AppStatus.error(message: '$error'),
    );
  }
}

