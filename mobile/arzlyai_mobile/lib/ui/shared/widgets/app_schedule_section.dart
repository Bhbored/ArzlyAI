import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/agent_override_request.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/scheduling/schedule_providers.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/schedule_repository.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/workflow_repository.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/validators/app_validators.dart';

class AppScheduleSection extends ConsumerStatefulWidget {
  const AppScheduleSection({super.key});

  @override
  ConsumerState<AppScheduleSection> createState() => _AppScheduleSectionState();
}

class _AppScheduleSectionState extends ConsumerState<AppScheduleSection> {
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  String? _localWorkflowId;
  bool _notificationsGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSchedule());
  }

  Future<void> _loadSchedule() async {
    final details = ref.read(presetDetailsProvider).value;
    if (details == null) return;
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

  String? _modelOverridesJson(PresetDetails details, RunConfigState config) {
    final writer = details.configurableWorkflowAgent();
    if (writer == null || !writer.modelConfiguration.isModelEditable) {
      return null;
    }
    final overrides = [
      AgentOverrideRequest(
        agentKey: writer.key,
        model: config.model ?? writer.modelConfiguration.selectedModel,
        temperature: config.temperature,
      ),
    ];
    return jsonEncode(overrides.map((e) => e.toJson()).toList());
  }

  Future<String> _ensureWorkflowInstance() async {
    final details = ref.read(presetDetailsProvider).value;
    final config = ref.read(runConfigTempProvider);
    if (details == null) throw StateError('Preset details are required.');

    final overridesJson = _modelOverridesJson(details, config);

    if (_localWorkflowId != null) {
      await ref.read(workflowRepositoryProvider).updateInstance(
        id: _localWorkflowId!,
        topic: config.topic.trim(),
        modelOverridesJson: overridesJson,
      );
      return _localWorkflowId!;
    }

    final instance = await ref.read(workflowRepositoryProvider).createInstance(
      presetKey: details.key,
      presetVersion: details.version,
      name: details.name,
      topic: config.topic.trim(),
      modelOverridesJson: overridesJson,
    );
    _localWorkflowId = instance.id;
    return instance.id;
  }

  Future<void> _toggleSchedule(bool enabled) async {
    final topicError = AppValidators.requiredNonEmpty(
      ref.read(runConfigTempProvider).topic,
    );
    if (topicError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(topicError)),
      );
      return;
    }

    if (enabled && !_notificationsGranted) {
      final notifications = await ref.read(localNotificationServiceProvider.future);
      _notificationsGranted = await notifications.requestPermission();
    }

    final workflowId = await _ensureWorkflowInstance();
    final timeZoneId = (await FlutterTimezone.getLocalTimezone()).identifier;
    final controller = ref.read(scheduleControllerProvider(workflowId).notifier);

    if (enabled) {
      await controller.enable(
        localTime: _formatTime(_time),
        timeZoneId: timeZoneId,
      );
    } else {
      await controller.disable();
    }
    await _loadSchedule();
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(presetDetailsProvider).value;
    if (details == null || details.key != 'daily-linkedin-ai-post') {
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
            'Runs on your device at the chosen local time. Generation stops for your review; publishing still requires Accept in the app. Background timing is best-effort on Android and iOS.',
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
              onPressed: () => _toggleSchedule(true),
            )
          else
            AppButton.ghost(
              label: 'Disable schedule',
              onPressed: () => _toggleSchedule(false),
            ),
        ],
      ),
    );
  }
}
