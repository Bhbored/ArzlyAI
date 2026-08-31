import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/ai_providers.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/agent_override_request.dart';
import 'package:arzlyai_mobile/core/workflow/brain_dump_preset_privacy.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/scheduling/schedule_providers.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/schedule_repository.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/workflow_repository.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/brain_dump_to_action/brain_dump_run_config.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';

class AppBrainDumpScheduleSection extends ConsumerStatefulWidget {
  const AppBrainDumpScheduleSection({super.key});

  @override
  ConsumerState<AppBrainDumpScheduleSection> createState() =>
      _AppBrainDumpScheduleSectionState();
}

class _AppBrainDumpScheduleSectionState
    extends ConsumerState<AppBrainDumpScheduleSection> {
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  String? _localWorkflowId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSchedule());
  }

  Future<void> _loadSchedule() async {
    final details = ref.read(presetDetailsProvider).value;
    if (details == null || !isBrainDumpWorkflowKey(details.key)) return;
    final workflowId = await ref.read(
      scheduledWorkflowIdForPresetProvider(details.key).future,
    );
    if (workflowId == null) return;
    final schedule = await ref
        .read(scheduleRepositoryProvider)
        .getByWorkflowId(workflowId);
    if (schedule == null) return;
    final parts = schedule.localTime.split(':');
    setState(() {
      _localWorkflowId = workflowId;
      _time = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<String> _ensureWorkflowInstance(PresetDetails details) async {
    final config = ref.read(runConfigTempProvider);
    final overridesJson = buildBrainDumpScheduleModelOverridesJson(details, config);

    if (_localWorkflowId != null) {
      await ref.read(workflowRepositoryProvider).updateInstance(
        id: _localWorkflowId!,
        topic: config.topic.trim().isEmpty ? 'Brain dump plan' : config.topic.trim(),
        modelOverridesJson: overridesJson,
      );
      return _localWorkflowId!;
    }

    final instance = await ref.read(workflowRepositoryProvider).createInstance(
      presetKey: details.key,
      presetVersion: details.version,
      name: details.name,
      topic: config.topic.trim().isEmpty ? 'Brain dump plan' : config.topic.trim(),
      modelOverridesJson: overridesJson,
    );
    _localWorkflowId = instance.id;
    return instance.id;
  }

  Future<void> _toggleSchedule(bool enabled, PresetDetails details) async {
    final prepared = prepareBrainDumpRunConfig(
      config: ref.read(runConfigTempProvider),
      details: details,
      previewOnly: false,
    );
    if (prepared.error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(prepared.error!)),
      );
      return;
    }

    if (enabled) {
      final notifications = await ref.read(localNotificationServiceProvider.future);
      await notifications.requestPermission();
    }

    final workflowId = await _ensureWorkflowInstance(details);
    final timeZoneId = (await FlutterTimezone.getLocalTimezone()).identifier;
    final controller = ref.read(scheduleControllerProvider(workflowId).notifier);

    if (enabled) {
      await controller.enable(
        localTime: _formatTime(_time),
        timeZoneId: timeZoneId,
        workflowInputs: buildScheduledBrainDumpInputs(
          ref.read(runConfigTempProvider),
          details: details,
        ),
        presetName: details.name,
      );
    } else {
      await controller.disable();
    }
    await _loadSchedule();
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(presetDetailsProvider).value;
    if (details == null || !isBrainDumpWorkflowKey(details.key)) {
      return const SizedBox.shrink();
    }

    final workflowId = _localWorkflowId;
    final enabled = workflowId != null
        ? ref.watch(workflowScheduleEnabledProvider(workflowId)).value ?? false
        : false;
    final theme = ShadTheme.of(context);

    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Daily schedule',
            style: theme.textTheme.small.copyWith(
              color: theme.colorScheme.cardForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.spaceSmall / 2),
          Text(
            'Runs on your device at the chosen local time. Generation stops for '
            'your review; Google sync runs only after you approve. Background '
            'timing is best-effort on Android and iOS.',
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          SizedBox(height: context.spaceSmall),
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatTime(_time),
                  style: theme.textTheme.p.copyWith(
                    color: theme.colorScheme.foreground,
                  ),
                ),
              ),
              AppButton.ghost(label: 'Change time', onPressed: _pickTime),
            ],
          ),
          SizedBox(height: context.spaceSmall),
          if (!enabled)
            AppButton.primary(
              label: 'Enable daily schedule',
              onPressed: () => _toggleSchedule(true, details),
            )
          else
            AppButton.ghost(
              label: 'Disable schedule',
              onPressed: () => _toggleSchedule(false, details),
            ),
        ],
      ),
    );
  }
}

@visibleForTesting
String? buildBrainDumpScheduleModelOverridesJson(
  PresetDetails details,
  RunConfigState config,
) {
  final planner = details.configurableWorkflowAgent();
  if (planner == null || !planner.modelConfiguration.isModelEditable) return null;
  final override = config.agentOverrides[planner.key];
  final model = override?.model ?? planner.modelConfiguration.selectedModel;
  final overrides = [
    AgentOverrideRequest(
      agentKey: planner.key,
      provider:
          override?.provider ??
          inferAiProviderFromModel(model) ??
          planner.modelConfiguration.provider,
      model: model,
      temperature: planner.modelConfiguration.isTemperatureEditable
          ? override?.temperature ?? planner.modelConfiguration.temperature
          : null,
    ),
  ];
  return jsonEncode(overrides.map((override) => override.toJson()).toList());
}
