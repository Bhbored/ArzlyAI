import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/ai_providers.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/network/dto/request/workflow/agent_override_request.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/scheduling/schedule_providers.dart';
import 'package:arzlyai_mobile/data/providers/temp/google_sheet_selection_temp.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/schedule_repository.dart';
import 'package:arzlyai_mobile/data/repositories/workflow/workflow_repository.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/domain/entities/scheduling/schedule_recurrence.dart';
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
  ScheduleRecurrenceType _recurrenceType = ScheduleRecurrenceType.daily;
  DateTime _anchorDate = DateTime.now();
  int _customIntervalDays = 2;
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
    final configuration = await ref
        .read(scheduleRepositoryProvider)
        .getConfiguration(workflowId);
    if (configuration != null && details.key.startsWith('receipt-')) {
      final storedInputs = Map<String, String>.from(configuration.inputs);
      final spreadsheetId = storedInputs.remove('spreadsheetId');
      final sourceRange = storedInputs.remove('sourceRange');
      final mappingJson = storedInputs.remove('columnMappingJson');
      storedInputs.remove('deliveryMode');
      String? tabTitle;
      if (sourceRange != null && sourceRange.contains('!')) {
        final separator = sourceRange.indexOf('!');
        tabTitle = sourceRange
            .substring(0, separator)
            .replaceAll(RegExp(r"^'|'$"), '')
            .replaceAll("''", "'");
        storedInputs['range'] = sourceRange.substring(separator + 1);
      }
      Map<String, String> mapping = const {};
      if (mappingJson != null) {
        final decoded = jsonDecode(mappingJson) as Map<String, dynamic>;
        mapping = decoded.map(
          (key, value) => MapEntry(key, value?.toString() ?? ''),
        );
      }
      final current = ref.read(runConfigTempProvider);
      ref
          .read(runConfigTempProvider.notifier)
          .update(current.copyWith(inputs: storedInputs));
      ref
          .read(googleSheetSelectionTempProvider.notifier)
          .update(
            GoogleSheetSelectionState(
              spreadsheetId: spreadsheetId,
              tabTitle: tabTitle,
              headerMapping: mapping,
            ),
          );
    }
    final parts = schedule.localTime.split(':');
    setState(() {
      _localWorkflowId = workflowId;
      _time = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      if (configuration != null) {
        _recurrenceType = configuration.recurrence.type;
        _anchorDate = configuration.recurrence.anchorDate;
        _customIntervalDays = configuration.recurrence.customIntervalDays;
      }
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

  String _recurrenceLabel(ScheduleRecurrenceType value) {
    switch (value) {
      case ScheduleRecurrenceType.daily:
        return 'Daily';
      case ScheduleRecurrenceType.weekly:
        return 'Weekly';
      case ScheduleRecurrenceType.monthly:
        return 'Monthly';
      case ScheduleRecurrenceType.quarterly:
        return 'Quarterly';
      case ScheduleRecurrenceType.yearly:
        return 'Yearly';
      case ScheduleRecurrenceType.custom:
        return 'Custom interval';
    }
  }

  Future<String> _ensureWorkflowInstance() async {
    final details = ref.read(presetDetailsProvider).value;
    final config = ref.read(runConfigTempProvider);
    if (details == null) throw StateError('Preset details are required.');

    final overridesJson = buildScheduleModelOverridesJson(details, config);

    if (_localWorkflowId != null) {
      await ref
          .read(workflowRepositoryProvider)
          .updateInstance(
            id: _localWorkflowId!,
            topic: config.topic.trim(),
            modelOverridesJson: overridesJson,
          );
      return _localWorkflowId!;
    }

    final instance = await ref
        .read(workflowRepositoryProvider)
        .createInstance(
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
    final details = ref.read(presetDetailsProvider).value;
    if (details == null) return;
    Map<String, String> workflowInputs = const {};
    if (enabled) {
      try {
        workflowInputs = buildScheduledWorkflowInputs(
          details.key,
          ref.read(runConfigTempProvider),
          ref.read(googleSheetSelectionTempProvider),
        );
      } on StateError catch (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
        return;
      }
    }

    if (enabled && !_notificationsGranted) {
      final notifications = await ref.read(
        localNotificationServiceProvider.future,
      );
      _notificationsGranted = await notifications.requestPermission();
    }

    final workflowId = await _ensureWorkflowInstance();
    final timeZoneId = (await FlutterTimezone.getLocalTimezone()).identifier;
    final controller = ref.read(
      scheduleControllerProvider(workflowId).notifier,
    );

    if (enabled) {
      await controller.enable(
        localTime: _formatTime(_time),
        timeZoneId: timeZoneId,
        recurrence: ScheduleRecurrence(
          type: details.key == 'daily-linkedin-ai-post'
              ? ScheduleRecurrenceType.daily
              : _recurrenceType,
          anchorDate: _anchorDate,
          customIntervalDays: _customIntervalDays,
        ),
        workflowInputs: workflowInputs,
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
    final isLinkedIn = details?.key == 'daily-linkedin-ai-post';
    final isReceipt = details?.key.startsWith('receipt-') ?? false;
    if (details == null || (!isLinkedIn && !isReceipt)) {
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
            isLinkedIn ? 'Daily schedule' : 'Report schedule',
            style: theme.textTheme.small.copyWith(
              color: theme.colorScheme.cardForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.spaceSmall / 2),
          Text(
            isLinkedIn
                ? 'Runs on your device at the chosen local time. Generation stops for your review; publishing still requires Accept in the app. Background timing is best-effort on Android and iOS.'
                : 'Runs and delivers the report with your saved Google Sheets, Gmail, and model settings. Background timing is best-effort on Android and iOS.',
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          SizedBox(height: context.spaceSmall),
          if (isReceipt) ...[
            ShadSelect<ScheduleRecurrenceType>(
              key: ValueKey(_recurrenceType),
              initialValue: _recurrenceType,
              selectedOptionBuilder: (context, value) =>
                  Text(_recurrenceLabel(value)),
              onChanged: (value) {
                if (value != null) setState(() => _recurrenceType = value);
              },
              options: ScheduleRecurrenceType.values
                  .map(
                    (value) => ShadOption(
                      value: value,
                      child: Text(_recurrenceLabel(value)),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: context.spaceSmall),
            Text('Starts from', style: theme.textTheme.small),
            SizedBox(height: context.spaceSmall / 2),
            ShadDatePicker(
              selected: _anchorDate,
              onChanged: (value) {
                if (value != null) setState(() => _anchorDate = value);
              },
            ),
            if (_recurrenceType == ScheduleRecurrenceType.custom) ...[
              SizedBox(height: context.spaceSmall),
              ShadInput(
                key: ValueKey(_customIntervalDays),
                initialValue: _customIntervalDays.toString(),
                keyboardType: TextInputType.number,
                placeholder: const Text('Days between runs'),
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null && parsed > 0) {
                    _customIntervalDays = parsed;
                  }
                },
              ),
            ],
            SizedBox(height: context.spaceSmall),
          ],
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
              label: isLinkedIn ? 'Enable daily schedule' : 'Enable schedule',
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

@visibleForTesting
String? buildScheduleModelOverridesJson(
  PresetDetails details,
  RunConfigState config,
) {
  final writer = details.configurableWorkflowAgent();
  if (writer == null || !writer.modelConfiguration.isModelEditable) return null;
  if (config.agentOverrides.isNotEmpty) {
    final overrides = config.agentOverrides.entries.map(
      (entry) => AgentOverrideRequest(
        agentKey: entry.key,
        provider:
            entry.value.provider ??
            inferAiProviderFromModel(entry.value.model ?? ''),
        model: entry.value.model,
        temperature: entry.value.temperature,
      ),
    );
    return jsonEncode(overrides.map((override) => override.toJson()).toList());
  }
  final model = config.model ?? writer.modelConfiguration.selectedModel;
  final overrides = [
    AgentOverrideRequest(
      agentKey: writer.key,
      provider:
          config.provider ??
          inferAiProviderFromModel(model) ??
          writer.modelConfiguration.provider,
      model: model,
      temperature: writer.modelConfiguration.isTemperatureEditable
          ? config.temperature
          : null,
    ),
  ];
  return jsonEncode(overrides.map((override) => override.toJson()).toList());
}

@visibleForTesting
Map<String, String> buildScheduledWorkflowInputs(
  String presetKey,
  RunConfigState config,
  GoogleSheetSelectionState selection,
) {
  if (presetKey == 'daily-linkedin-ai-post') {
    final error = AppValidators.requiredNonEmpty(config.topic);
    if (error != null) throw StateError(error);
    return {'topic': config.topic.trim()};
  }
  if (!presetKey.startsWith('receipt-')) return Map.from(config.inputs);

  final spreadsheetId = selection.spreadsheetId?.trim() ?? '';
  final tabTitle = selection.tabTitle?.trim() ?? '';
  final range = config.inputs['range']?.trim() ?? '';
  if (spreadsheetId.isEmpty) throw StateError('Select a spreadsheet');
  if (tabTitle.isEmpty) throw StateError('Select a sheet tab');
  if (range.isEmpty) throw StateError('Enter a sheet range');
  const requiredColumns = {'date', 'merchant', 'category', 'amount'};
  final mapping = selection.headerMapping;
  if (!mapping.keys.toSet().containsAll(requiredColumns) ||
      mapping.values.map((value) => value.trim()).toSet().length != 4) {
    throw StateError('Map four distinct receipt columns');
  }
  final asOfDate = config.inputs['asOfDate']?.trim() ?? '';
  if (DateTime.tryParse(asOfDate) == null) {
    throw StateError('Choose a report date');
  }
  final currency = config.inputs['currencyCode']?.trim().toUpperCase() ?? '';
  if (!RegExp(r'^[A-Z]{3}$').hasMatch(currency)) {
    throw StateError('Enter a three-letter currency code');
  }
  final requiredInput = switch (presetKey) {
    'receipt-weekly-budget' || 'receipt-savings-tracker' => 'budget',
    'receipt-quarterly-tax' => 'taxRate',
    'receipt-category-dive' => 'category',
    _ => null,
  };
  if (requiredInput != null &&
      (config.inputs[requiredInput]?.trim().isEmpty ?? true)) {
    throw StateError('Complete the required report settings');
  }
  final escapedTab = tabTitle.replaceAll("'", "''");
  final sourceRange = range.contains('!') ? range : "'$escapedTab'!$range";
  final inputs = Map<String, String>.from(config.inputs)
    ..remove('range')
    ..['spreadsheetId'] = spreadsheetId
    ..['sourceRange'] = sourceRange
    ..['columnMappingJson'] = jsonEncode({
      'date': mapping['date']?.trim(),
      'amount': mapping['amount']?.trim(),
      'category': mapping['category']?.trim(),
      'merchant': mapping['merchant']?.trim(),
    })
    ..['asOfDate'] = asOfDate
    ..['currencyCode'] = currency
    ..['deliveryMode'] = 'deliver';
  inputs.removeWhere((key, value) => value.trim().isEmpty);
  return inputs;
}
