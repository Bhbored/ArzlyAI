import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/preset_input_field_type.dart';
import 'package:arzlyai_mobile/data/providers/models/openai_models_provider.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/domain/entities/preset/input_schema.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/domain/mappers/preset/input_schema_mapper.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_country_select.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_model_select.dart';
import 'package:arzlyai_mobile/ui/validators/app_validators.dart';

const _currencies = ['USD', 'GBP', 'EUR', 'CAD', 'AUD'];

class DynamicPresetConfigureScreen extends ConsumerStatefulWidget {
  const DynamicPresetConfigureScreen({super.key});

  @override
  ConsumerState<DynamicPresetConfigureScreen> createState() =>
      _DynamicPresetConfigureScreenState();
}

class _DynamicPresetConfigureScreenState
    extends ConsumerState<DynamicPresetConfigureScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _seedDefaults());
  }

  void _seedDefaults() {
    final preset = ref.read(presetDetailsProvider).value;
    if (preset == null) return;
    final current = ref.read(runConfigTempProvider);
    var next = current;
    final schema = preset.inputSchema;
    if (schema != null && current.inputs.isEmpty) {
      final inputs = <String, String>{};
      for (final field in schema.fields) {
        inputs[field.key] = switch (field.type) {
          PresetInputFieldType.country => 'LB',
          PresetInputFieldType.currency => 'USD',
          _ => '',
        };
      }
      next = next.copyWith(inputs: inputs);
    }
    if (current.agentOverrides.isEmpty) {
      final overrides = <String, AgentOverrideDraft>{};
      for (final agent in preset.agents) {
        if (!agent.modelConfiguration.isModelEditable &&
            !agent.modelConfiguration.isTemperatureEditable) {
          continue;
        }
        overrides[agent.key] = AgentOverrideDraft(
          model: agent.modelConfiguration.selectedModel,
          temperature: agent.modelConfiguration.isTemperatureEditable
              ? agent.modelConfiguration.temperature
              : null,
        );
      }
      next = next.copyWith(agentOverrides: overrides);
    }
    if (next != current) {
      ref.read(runConfigTempProvider.notifier).update(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preset = ref.watch(presetDetailsProvider).value;
    final schema = preset?.inputSchema;
    final theme = ShadTheme.of(context);
    if (preset == null || schema == null || schema.fields.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Configure', style: theme.textTheme.h4)),
        body: Center(
          child: Text(
            'Preset input schema is unavailable.',
            style: theme.textTheme.p,
          ),
        ),
      );
    }
    final online = ref.watch(internetConnectionProvider);
    final offlineMode = ref.watch(offlineModeProvider).value ?? false;
    final firstAgent = preset.workflow.nodes
        .where((node) => node.type == 'Agent')
        .firstOrNull;
    final submitLabel = firstAgent?.displayName ?? 'Start run';

    return Scaffold(
      appBar: AppBar(title: Text('Configure', style: theme.textTheme.h4)),
      body: ListView(
        padding: EdgeInsets.all(context.paddingMedium),
        children: [
            ...schema.fields.map((field) => _fieldEditor(field: field)),
            SizedBox(height: context.spaceMedium),
            ...preset.agents.map((agent) => _agentSection(agent: agent)),
            if (_error != null) ...[
              SizedBox(height: context.spaceSmall),
              Text(
                _error!,
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.destructive,
                ),
              ),
            ],
            SizedBox(height: context.spaceLarge),
            AppButton.primary(
              label: submitLabel,
              onPressed: !online || offlineMode
                  ? null
                  : () => _start(preset, schema),
            ),
          ],
        ),
    );
  }

  Widget _fieldEditor({required PresetInputField field}) {
    final theme = ShadTheme.of(context);
    final config = ref.watch(runConfigTempProvider);
    final value = field.type == PresetInputFieldType.candidateList
        ? null
        : config.inputs[field.key] ?? '';

    if (field.type == PresetInputFieldType.candidateList) {
      return _CandidateSeedsEditor(field: field);
    }
    if (field.type == PresetInputFieldType.country) {
      return AppCountrySelect(fieldKey: field.key, label: field.label);
    }
    if (field.type == PresetInputFieldType.currency) {
      return _SelectField(
        label: field.label,
        value: config.inputs[field.key] ?? 'USD',
        options: _currencies,
        onChanged: (next) => _updateInput(field.key, next),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: context.spaceMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field.label, style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall / 2),
          ShadInput(
            initialValue: value,
            maxLines: field.type == PresetInputFieldType.multilineText ? 5 : 1,
            placeholder: Text(field.label),
            onChanged: (next) => _updateInput(field.key, next),
          ),
        ],
      ),
    );
  }

  Widget _agentSection({required Agent agent}) {
    final theme = ShadTheme.of(context);
    final config = ref.watch(runConfigTempProvider);
    final override =
        config.agentOverrides[agent.key] ?? const AgentOverrideDraft();
    final editableModel = agent.modelConfiguration.isModelEditable;
    final editableTemp = agent.modelConfiguration.isTemperatureEditable;
    if (!editableModel && !editableTemp) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: context.spaceMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(agent.name, style: theme.textTheme.h4),
          SizedBox(height: context.spaceSmall / 2),
          AppCard.standard(
            child: Text(
              agent.systemPrompt,
              style: theme.textTheme.muted.copyWith(
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ),
          if (agent.harness.webSearchEnabled) ...[
            SizedBox(height: context.spaceSmall / 2),
            Text('Web search enabled', style: theme.textTheme.muted),
          ],
          if (editableModel) ...[
            SizedBox(height: context.spaceSmall),
            Text('Model', style: theme.textTheme.small),
            SizedBox(height: context.spaceSmall / 2),
            AppModelSelect.forAgent(
              agentKey: agent.key,
              defaultModelId: agent.modelConfiguration.selectedModel,
              requiresWebSearch: agent.harness.webSearchEnabled,
              enabled: true,
              onRetry: () => ref.read(openAiModelsProvider.notifier).refresh(),
            ),
          ],
          if (editableTemp) ...[
            SizedBox(height: context.spaceMedium),
            Text(
              'Temperature ${override.temperature ?? agent.modelConfiguration.temperature}',
              style: theme.textTheme.small,
            ),
            Slider(
              min: agent.modelConfiguration.minimumTemperature,
              max: agent.modelConfiguration.maximumTemperature,
              value: AppValidators.clampTemperature(
                override.temperature ?? agent.modelConfiguration.temperature,
                agent.modelConfiguration.minimumTemperature,
                agent.modelConfiguration.maximumTemperature,
              ),
              onChanged: (value) {
                final current = ref.read(runConfigTempProvider);
                final overrides = Map<String, AgentOverrideDraft>.from(
                  current.agentOverrides,
                );
                overrides[agent.key] = override.copyWith(temperature: value);
                ref
                    .read(runConfigTempProvider.notifier)
                    .update(current.copyWith(agentOverrides: overrides));
              },
            ),
          ],
        ],
      ),
    );
  }

  void _updateInput(String key, String value) {
    final current = ref.read(runConfigTempProvider);
    final inputs = Map<String, String>.from(current.inputs)..[key] = value;
    ref
        .read(runConfigTempProvider.notifier)
        .update(current.copyWith(inputs: inputs));
  }

  void _start(PresetDetails preset, PresetInputSchema schema) {
    setState(() => _error = null);
    final config = ref.read(runConfigTempProvider);
    final inputs = Map<String, String>.from(config.inputs);
    final mapper = const InputSchemaMapper();

    for (final field in schema.fields) {
      if (field.type == PresetInputFieldType.candidateList) {
        final maximum = field.maximumItems ?? 5;
        final seedError = AppValidators.candidateSeeds(
          config.candidateSeeds,
          maximum: maximum,
        );
        if (seedError != null) {
          setState(() => _error = seedError);
          return;
        }
        inputs[field.key] = mapper.encodeCandidateSeeds(config.candidateSeeds);
        continue;
      }
      final value = inputs[field.key]?.trim() ?? '';
      if (field.required && AppValidators.requiredNonEmpty(value) != null) {
        setState(() => _error = '${field.label} is required');
        return;
      }
      if (field.type == PresetInputFieldType.decimal) {
        final decimalError = AppValidators.nonNegativeDecimal(value);
        if (decimalError != null) {
          setState(() => _error = decimalError);
          return;
        }
      }
      inputs[field.key] = value;
    }

    final primaryKey = schema.primaryInputKey();
    final topic = primaryKey == null ? '' : inputs[primaryKey]?.trim() ?? '';
    final agentOverrides = _resolvedAgentOverrides(preset, config);

    ref.read(activeRunProvider.notifier).start(
      config.copyWith(
        topic: topic,
        inputs: inputs,
        agentOverrides: agentOverrides,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Map<String, AgentOverrideDraft> _resolvedAgentOverrides(
    PresetDetails preset,
    RunConfigState config,
  ) {
    final overrides = Map<String, AgentOverrideDraft>.from(
      config.agentOverrides,
    );
    for (final agent in preset.agents) {
      if (!agent.modelConfiguration.isModelEditable &&
          !agent.modelConfiguration.isTemperatureEditable) {
        continue;
      }
      overrides.putIfAbsent(
        agent.key,
        () => AgentOverrideDraft(
          model: agent.modelConfiguration.selectedModel,
          temperature: agent.modelConfiguration.isTemperatureEditable
              ? agent.modelConfiguration.temperature
              : null,
        ),
      );
    }
    return overrides;
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: context.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall / 2),
          ShadSelect<String>(
            initialValue: value,
            onChanged: (next) {
              if (next != null) onChanged(next);
            },
            options: options
                .map((item) => ShadOption(value: item, child: Text(item)))
                .toList(),
            selectedOptionBuilder: (context, item) => Text(item),
            placeholder: Text(label),
          ),
        ],
      ),
    );
  }
}

class _CandidateSeedsEditor extends ConsumerWidget {
  const _CandidateSeedsEditor({required this.field});

  final PresetInputField field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final seeds = ref.watch(runConfigTempProvider).candidateSeeds;
    final maximum = field.maximumItems ?? 5;
    return Padding(
      padding: EdgeInsets.only(bottom: context.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field.label, style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall / 2),
          Text(
            'Up to $maximum product names or HTTPS URLs',
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          SizedBox(height: context.spaceSmall),
          ...seeds.asMap().entries.map(
            (entry) => _CandidateSeedRow(index: entry.key, seed: entry.value),
          ),
          if (seeds.length < maximum)
            AppButton.ghost(
              label: 'Add candidate',
              onPressed: () {
                final current = ref.read(runConfigTempProvider);
                ref
                    .read(runConfigTempProvider.notifier)
                    .update(
                      current.copyWith(
                        candidateSeeds: [
                          ...current.candidateSeeds,
                          const CandidateSeed(label: ''),
                        ],
                      ),
                    );
              },
            ),
        ],
      ),
    );
  }
}

class _CandidateSeedRow extends ConsumerWidget {
  const _CandidateSeedRow({required this.index, required this.seed});

  final int index;
  final CandidateSeed seed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spaceSmall),
      child: Row(
        children: [
          Expanded(
            child: ShadInput(
              initialValue: seed.label,
              placeholder: const Text('Product name'),
              onChanged: (next) => _update(ref, label: next),
            ),
          ),
          SizedBox(width: context.spaceSmall),
          Expanded(
            child: ShadInput(
              initialValue: seed.url ?? '',
              placeholder: const Text('HTTPS URL (optional)'),
              onChanged: (next) => _update(ref, url: next.trim()),
            ),
          ),
          ShadButton.ghost(
            onPressed: () {
              final current = ref.read(runConfigTempProvider);
              final next = [...current.candidateSeeds]..removeAt(index);
              ref
                  .read(runConfigTempProvider.notifier)
                  .update(current.copyWith(candidateSeeds: next));
            },
            child: const Icon(LucideIcons.trash2, size: 16),
          ),
        ],
      ),
    );
  }

  void _update(WidgetRef ref, {String? label, String? url}) {
    final current = ref.read(runConfigTempProvider);
    final next = [...current.candidateSeeds];
    final existing = next[index];
    next[index] = existing.copyWith(
      label: label ?? existing.label,
      url: url == null
          ? existing.url
          : url.isEmpty
          ? null
          : url,
    );
    ref
        .read(runConfigTempProvider.notifier)
        .update(current.copyWith(candidateSeeds: next));
  }
}
