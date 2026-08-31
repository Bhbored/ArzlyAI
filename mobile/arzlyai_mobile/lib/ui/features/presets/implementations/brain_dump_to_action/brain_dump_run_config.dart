import 'package:flutter/foundation.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/ui/validators/app_validators.dart';

class BrainDumpConfigPreparation {
  const BrainDumpConfigPreparation.success(this.config) : error = null;
  const BrainDumpConfigPreparation.failure(this.error) : config = null;

  final RunConfigState? config;
  final String? error;
}

BrainDumpConfigPreparation prepareBrainDumpRunConfig({
  required RunConfigState config,
  required PresetDetails details,
  bool previewOnly = true,
}) {
  final dump = config.inputs['brainDump']?.trim() ?? '';
  if (AppValidators.requiredNonEmpty(dump) != null) {
    return const BrainDumpConfigPreparation.failure('Enter a brain dump');
  }
  final asOfDate = config.inputs['asOfDate']?.trim() ?? '';
  if (DateTime.tryParse(asOfDate) == null) {
    return const BrainDumpConfigPreparation.failure('Choose a valid plan date');
  }
  final start = config.inputs['workingHoursStart']?.trim() ?? '';
  final end = config.inputs['workingHoursEnd']?.trim() ?? '';
  if (start.isEmpty || end.isEmpty) {
    return const BrainDumpConfigPreparation.failure('Enter working hours');
  }
  final recipient = config.inputs['recipientEmail']?.trim() ?? '';
  if (config.inputs['sendEmail'] == 'true' &&
      !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(recipient)) {
    return const BrainDumpConfigPreparation.failure('Enter a valid Gmail recipient');
  }
  final inputs = Map<String, String>.from(config.inputs)
    ..['brainDump'] = dump
    ..['asOfDate'] = asOfDate
    ..['workingHoursStart'] = start
    ..['workingHoursEnd'] = end;
  if (previewOnly) {
    inputs
      ..['syncTasks'] = 'false'
      ..['syncCalendar'] = 'false'
      ..['sendEmail'] = 'false';
  }
  inputs.removeWhere((key, value) => value.trim().isEmpty);
  final planner = details.configurableWorkflowAgent();
  final overrides = Map<String, AgentOverrideDraft>.from(config.agentOverrides);
  if (planner != null) {
    overrides.putIfAbsent(
      planner.key,
      () => AgentOverrideDraft(
        provider: planner.modelConfiguration.provider,
        model: planner.modelConfiguration.selectedModel,
        temperature: planner.modelConfiguration.isTemperatureEditable
            ? planner.modelConfiguration.temperature
            : null,
      ),
    );
  }
  return BrainDumpConfigPreparation.success(
    config.copyWith(
      topic: 'Brain dump plan',
      inputs: inputs,
      agentOverrides: overrides,
    ),
  );
}

Map<String, String> buildScheduledBrainDumpInputs(
  RunConfigState config, {
  required PresetDetails details,
}) {
  final prepared = prepareBrainDumpRunConfig(
    config: config,
    details: details,
    previewOnly: false,
  );
  final error = prepared.error;
  if (error != null) throw StateError(error);
  return prepared.config!.inputs;
}

@visibleForTesting
BrainDumpConfigPreparation prepareBrainDumpRunConfigForTest({
  required RunConfigState config,
  required PresetDetails details,
  bool previewOnly = true,
}) =>
    prepareBrainDumpRunConfig(
      config: config,
      details: details,
      previewOnly: previewOnly,
    );
