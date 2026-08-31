import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/preset_input_field_type.dart';
import 'package:arzlyai_mobile/core/geo/country_currency.dart';
import 'package:arzlyai_mobile/data/providers/connectors/google_resource_providers.dart';
import 'package:arzlyai_mobile/data/providers/models/provider_models_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/settings/ai_settings_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/google_sheet_selection_temp.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_sheet_headers.dart';
import 'package:arzlyai_mobile/domain/entities/preset/input_schema.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/domain/entities/provider/provider_model.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/preset_key.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/receipt_workflow_metadata.dart';
import 'package:arzlyai_mobile/ui/features/presets/preset_run_router.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_model_select.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_status.dart';
import 'package:arzlyai_mobile/ui/validators/app_validators.dart';

class ReceiptConfigureRunScreen extends ConsumerStatefulWidget {
  const ReceiptConfigureRunScreen({super.key});

  @override
  ConsumerState<ReceiptConfigureRunScreen> createState() =>
      _ReceiptConfigureRunScreenState();
}

class _ReceiptConfigureRunScreenState
    extends ConsumerState<ReceiptConfigureRunScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _seedDefaults());
    ref.listenManual(availableProviderModelsProvider, (previous, next) {
      final details = ref.read(presetDetailsProvider).value;
      final agent = details?.configurableWorkflowAgent();
      if (agent == null) return;
      next.whenData((models) => _syncModelSelection(models, agent));
    }, fireImmediately: true);
  }

  void _seedDefaults() {
    final details = ref.read(presetDetailsProvider).value;
    final schema = details?.inputSchema;
    if (schema == null) return;

    ref.read(googleSheetSelectionTempProvider.notifier).clear();
    final current = ref.read(runConfigTempProvider);
    if (current.inputs.containsKey('analysisMode')) return;

    final country =
        PlatformDispatcher.instance.locale.countryCode?.toUpperCase() ?? 'US';
    final today = DateTime.now();
    final date =
        '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';

    final inputs = <String, String>{'range': 'A:Z', 'asOfDate': date};
    for (final field in schema.fields) {
      if (field.key == 'spreadsheetId' ||
          field.key == 'sourceRange' ||
          field.key == 'columnMappingJson') {
        continue;
      }
      final defaultValue = field.defaultValue?.trim();
      if (defaultValue != null && defaultValue.isNotEmpty) {
        inputs[field.key] = defaultValue;
      } else if (field.type == PresetInputFieldType.currency) {
        inputs[field.key] = currencyCodeForCountry(country);
      }
    }

    ref
        .read(runConfigTempProvider.notifier)
        .update(current.copyWith(inputs: inputs));
  }

  void _syncModelSelection(List<ProviderModel> models, Agent agent) {
    if (models.isEmpty) return;
    final current = ref.read(runConfigTempProvider);
    final existing = current.agentOverrides[agent.key];
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
              model.id == agent.modelConfiguration.selectedModel &&
              model.provider == agent.modelConfiguration.provider,
        )
        .firstOrNull;
    selected ??= models.first;
    final overrides = Map<String, AgentOverrideDraft>.from(
      current.agentOverrides,
    );
    overrides[agent.key] = AgentOverrideDraft(
      provider: selected.provider,
      model: selected.id,
      temperature:
          selected.supportsTemperature &&
              agent.modelConfiguration.isTemperatureEditable
          ? agent.modelConfiguration.temperature
          : null,
    );
    ref
        .read(runConfigTempProvider.notifier)
        .update(current.copyWith(agentOverrides: overrides));
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(presetDetailsProvider).value;
    final schema = details?.inputSchema;
    final theme = ShadTheme.of(context);
    if (details == null || schema == null || schema.analysisModeField == null) {
      return const Scaffold(
        body: AppStatus.error(message: 'Receipt preset is unavailable.'),
      );
    }
    final config = ref.watch(runConfigTempProvider);
    final agent = details.configurableWorkflowAgent();

    return Scaffold(
      appBar: AppBar(title: Text(details.name, style: theme.textTheme.h4)),
      body: ListView(
        padding: EdgeInsets.all(context.paddingMedium),
        children: [
          Text(details.description, style: theme.textTheme.p),
          SizedBox(height: context.spaceMedium),
          _analysisGoalCard(schema, config),
          SizedBox(height: context.spaceMedium),
          _sourceCard(),
          SizedBox(height: context.spaceMedium),
          _modeSpecificCard(schema, config),
          SizedBox(height: context.spaceMedium),
          _reportDateCard(config),
          SizedBox(height: context.spaceMedium),
          _deliveryCard(schema, config),
          if (agent != null && agent.modelConfiguration.isModelEditable) ...[
            SizedBox(height: context.spaceMedium),
            AppCard.standard(
              title: 'AI model',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Choose any model available from your configured providers.',
                    style: theme.textTheme.muted,
                  ),
                  SizedBox(height: context.spaceSmall),
                  AppModelSelect.forAgent(
                    agentKey: agent.key,
                    defaultModelId: agent.modelConfiguration.selectedModel,
                    requiresWebSearch: false,
                    enabled: !ref.watch(activeRunProvider).isLoading,
                    onRetry: () => ref
                        .read(availableProviderModelsProvider.notifier)
                        .refresh(),
                  ),
                ],
              ),
            ),
          ],
          if (_error != null) ...[
            SizedBox(height: context.spaceMedium),
            Text(
              _error!,
              style: theme.textTheme.small.copyWith(
                color: theme.colorScheme.destructive,
              ),
            ),
          ],
          SizedBox(height: context.spaceLarge),
          AppButton.primary(
            label: ref.watch(activeRunProvider).isLoading
                ? 'Running…'
                : 'Run',
            onPressed: ref.watch(activeRunProvider).isLoading
                ? null
                : () => _start(details, schema, config),
          ),
        ],
      ),
    );
  }

  Widget _analysisGoalCard(PresetInputSchema schema, RunConfigState config) {
    final field = schema.analysisModeField!;
    final selected = config.inputs['analysisMode']?.trim() ?? '';
    return AppCard.standard(
      title: field.label,
      child: Column(
        children: [
          for (final option in field.options)
            Padding(
              padding: EdgeInsets.only(bottom: context.spaceSmall),
              child: _AnalysisModeCard(
                option: option,
                selected: selected == option.value,
                onSelected: () => _updateInput('analysisMode', option.value),
              ),
            ),
        ],
      ),
    );
  }

  Widget _modeSpecificCard(PresetInputSchema schema, RunConfigState config) {
    final fields = schema.fields.where(
      (field) =>
          field.key != 'analysisMode' &&
          field.key != 'spreadsheetId' &&
          field.key != 'sourceRange' &&
          field.key != 'columnMappingJson' &&
          field.key != 'asOfDate' &&
          field.key != 'currencyCode' &&
          field.key != 'deliveryMode' &&
          field.key != 'reportTabTitle' &&
          field.key != 'recipientEmail' &&
          schema.isFieldVisible(field, config.inputs),
    );
    if (fields.isEmpty) return const SizedBox.shrink();

    return AnimatedSwitcher(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 180),
      child: AppCard.standard(
        key: ValueKey(config.inputs['analysisMode'] ?? ''),
        title: 'Analysis details',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final field in fields) _schemaField(field, config),
          ],
        ),
      ),
    );
  }

  Widget _reportDateCard(RunConfigState config) {
    final theme = ShadTheme.of(context);
    final selectedDate = DateTime.tryParse(config.inputs['asOfDate'] ?? '');
    return AppCard.standard(
      title: 'Report date and currency',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Report date', style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall / 2),
          ShadDatePicker(
            selected: selectedDate,
            onChanged: (date) {
              if (date == null) return;
              _updateInput(
                'asOfDate',
                '${date.year.toString().padLeft(4, '0')}-'
                    '${date.month.toString().padLeft(2, '0')}-'
                    '${date.day.toString().padLeft(2, '0')}',
              );
            },
          ),
          SizedBox(height: context.spaceMedium),
          Text('Currency code', style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall / 2),
          ShadInput(
            initialValue: config.inputs['currencyCode'] ?? 'USD',
            placeholder: const Text('USD'),
            onChanged: (value) =>
                _updateInput('currencyCode', value.toUpperCase()),
          ),
        ],
      ),
    );
  }

  Widget _deliveryCard(PresetInputSchema schema, RunConfigState config) {
    final deliveryField = schema.fieldForKey('deliveryMode');
    if (deliveryField == null) return const SizedBox.shrink();
    final theme = ShadTheme.of(context);
    final deliveryMode = config.inputs['deliveryMode']?.trim() ?? 'preview';

    return AppCard.standard(
      title: deliveryField.label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShadSelect<String>(
            key: ValueKey(deliveryMode),
            initialValue: deliveryMode,
            placeholder: const Text('Preview only'),
            selectedOptionBuilder: (context, value) {
              final option = deliveryField.options
                  .where((item) => item.value == value)
                  .firstOrNull;
              return Text(option?.label ?? value);
            },
            onChanged: (value) {
              if (value == null) return;
              _updateInput('deliveryMode', value);
            },
            options: deliveryField.options
                .map(
                  (option) => ShadOption(
                    value: option.value,
                    child: Text(option.label),
                  ),
                )
                .toList(),
          ),
          if (schema.fieldForKey('reportTabTitle') case final reportTabField?
              when schema.isFieldVisible(reportTabField, config.inputs)) ...[
            SizedBox(height: context.spaceMedium),
            Text('Report tab', style: theme.textTheme.small),
            SizedBox(height: context.spaceSmall / 2),
            ShadInput(
              initialValue: config.inputs['reportTabTitle'] ?? 'Receipt Report',
              placeholder: const Text('Receipt Report'),
              onChanged: (value) => _updateInput('reportTabTitle', value),
            ),
          ],
          if (schema.fieldForKey('recipientEmail') case final recipientField?
              when schema.isFieldVisible(recipientField, config.inputs)) ...[
            SizedBox(height: context.spaceMedium),
            Text('Recipient email', style: theme.textTheme.small),
            SizedBox(height: context.spaceSmall / 2),
            ShadInput(
              initialValue: config.inputs['recipientEmail'] ?? '',
              keyboardType: TextInputType.emailAddress,
              placeholder: const Text('name@example.com'),
              onChanged: (value) => _updateInput('recipientEmail', value),
            ),
          ],
        ],
      ),
    );
  }

  Widget _schemaField(PresetInputField field, RunConfigState config) {
    final theme = ShadTheme.of(context);
    final value = config.inputs[field.key] ?? '';
    return Padding(
      padding: EdgeInsets.only(bottom: context.spaceMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(field.label, style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall / 2),
          ShadInput(
            key: ValueKey('${field.key}:$value'),
            initialValue: value,
            keyboardType: field.type == PresetInputFieldType.decimal
                ? const TextInputType.numberWithOptions(decimal: true)
                : null,
            placeholder: Text(field.label),
            onChanged: (next) => _updateInput(field.key, next),
          ),
        ],
      ),
    );
  }

  Widget _sourceCard() {
    final theme = ShadTheme.of(context);
    final selection = ref.watch(googleSheetSelectionTempProvider);
    final spreadsheets = ref.watch(googleSpreadsheetsProvider);
    final config = ref.watch(runConfigTempProvider);

    return AppCard.standard(
      title: 'Google Sheets source',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Spreadsheet', style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall / 2),
          spreadsheets.when(
            loading: () => const AppStatus.loading(),
            error: (error, _) => AppStatus.error(message: '$error'),
            data: (items) => ShadSelect<String>(
              key: ValueKey(selection.spreadsheetId),
              initialValue: selection.spreadsheetId,
              placeholder: const Text('Select a spreadsheet'),
              selectedOptionBuilder: (context, value) => Text(
                items.where((item) => item.id == value).firstOrNull?.name ??
                    value,
              ),
              onChanged: (value) {
                if (value == null) return;
                ref
                    .read(googleSheetSelectionTempProvider.notifier)
                    .update(
                      selection.copyWith(
                        spreadsheetId: value,
                        clearTab: true,
                        clearHeaders: true,
                      ),
                    );
              },
              options: items
                  .map(
                    (item) =>
                        ShadOption(value: item.id, child: Text(item.name)),
                  )
                  .toList(),
            ),
          ),
          if (selection.spreadsheetId case final spreadsheetId?) ...[
            SizedBox(height: context.spaceMedium),
            Text('Sheet tab', style: theme.textTheme.small),
            SizedBox(height: context.spaceSmall / 2),
            ref
                .watch(googleSheetTabsProvider(spreadsheetId))
                .when(
                  loading: () => const AppStatus.loading(),
                  error: (error, _) => AppStatus.error(message: '$error'),
                  data: (tabs) => ShadSelect<String>(
                    key: ValueKey(selection.tabTitle),
                    initialValue: selection.tabTitle,
                    placeholder: const Text('Select a tab'),
                    selectedOptionBuilder: (context, value) => Text(value),
                    onChanged: (value) {
                      if (value == null) return;
                      ref
                          .read(googleSheetSelectionTempProvider.notifier)
                          .update(
                            selection.copyWith(
                              tabTitle: value,
                              clearHeaders: true,
                            ),
                          );
                    },
                    options: tabs
                        .map(
                          (tab) => ShadOption(
                            value: tab.title,
                            child: Text(tab.title),
                          ),
                        )
                        .toList(),
                  ),
                ),
          ],
          SizedBox(height: context.spaceMedium),
          Text('Range', style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall / 2),
          ShadInput(
            key: const ValueKey('receipt-range'),
            initialValue: config.inputs['range'] ?? 'A:Z',
            placeholder: const Text('A:Z'),
            onChanged: (value) => _updateInput('range', value),
          ),
          if (selection.spreadsheetId case final spreadsheetId?) ...[
            if (selection.tabTitle case final tabTitle?) ...[
              SizedBox(height: context.spaceMedium),
              ref
                  .watch(
                    googleSheetHeadersProvider((
                      spreadsheetId: spreadsheetId,
                      tabTitle: tabTitle,
                    )),
                  )
                  .when(
                    loading: () => const AppStatus.loading(),
                    error: (error, _) => AppStatus.error(message: '$error'),
                    data: (headers) => _headerMapping(headers),
                  ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _headerMapping(GoogleSheetHeaders headers) {
    final theme = ShadTheme.of(context);
    final selection = ref.watch(googleSheetSelectionTempProvider);
    if (selection.headerMapping.isEmpty && headers.values.length >= 4) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final current = ref.read(googleSheetSelectionTempProvider);
        if (current.headerMapping.isNotEmpty) return;
        final inferred = <String, String>{};
        for (final field in const ['date', 'amount', 'category', 'merchant']) {
          final match = headers.values
              .where((header) => header.toLowerCase().contains(field))
              .firstOrNull;
          if (match != null) inferred[field] = match;
        }
        ref
            .read(googleSheetSelectionTempProvider.notifier)
            .update(current.copyWith(headerMapping: inferred));
      });
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Map header columns', style: theme.textTheme.small),
        SizedBox(height: context.spaceSmall / 2),
        Text(
          'Choose four distinct columns. Dates must use yyyy-MM-dd.',
          style: theme.textTheme.muted,
        ),
        SizedBox(height: context.spaceSmall),
        for (final field in const ['date', 'merchant', 'category', 'amount'])
          Padding(
            padding: EdgeInsets.only(bottom: context.spaceSmall),
            child: ShadSelect<String>(
              key: ValueKey('$field:${selection.headerMapping[field] ?? ''}'),
              initialValue: selection.headerMapping[field],
              placeholder: Text(_fieldLabel(field)),
              selectedOptionBuilder: (context, value) => Text(value),
              onChanged: (value) {
                if (value == null) return;
                final mapping = Map<String, String>.from(
                  ref.read(googleSheetSelectionTempProvider).headerMapping,
                )..[field] = value;
                final current = ref.read(googleSheetSelectionTempProvider);
                ref
                    .read(googleSheetSelectionTempProvider.notifier)
                    .update(current.copyWith(headerMapping: mapping));
              },
              options: headers.values
                  .map(
                    (header) => ShadOption(value: header, child: Text(header)),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  void _updateInput(String key, String value) {
    final current = ref.read(runConfigTempProvider);
    final inputs = Map<String, String>.from(current.inputs)..[key] = value;
    ref
        .read(runConfigTempProvider.notifier)
        .update(current.copyWith(inputs: inputs));
  }

  Future<void> _start(
    PresetDetails details,
    PresetInputSchema schema,
    RunConfigState config,
  ) async {
    setState(() => _error = null);
    final prepared = prepareReceiptRunConfig(
      config: config,
      selection: ref.read(googleSheetSelectionTempProvider),
      schema: schema,
      details: details,
    );
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
    final execution = executionScreenForPreset(ReceiptIntelligencePreset.key);
    if (execution == null) {
      Navigator.of(context).pop();
      return;
    }
    unawaited(
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => execution)),
    );
  }

  String _fieldLabel(String field) {
    return '${field[0].toUpperCase()}${field.substring(1)} column';
  }
}

class _AnalysisModeCard extends StatelessWidget {
  const _AnalysisModeCard({
    required this.option,
    required this.selected,
    required this.onSelected,
  });

  final PresetInputFieldOption option;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Semantics(
      selected: selected,
      button: true,
      label: option.label,
      child: Material(
        color: selected
            ? theme.colorScheme.primary.withValues(alpha: 0.12)
            : theme.colorScheme.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.borderRadiusMedium),
          side: BorderSide(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: onSelected,
          borderRadius: BorderRadius.circular(context.borderRadiusMedium),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: EdgeInsets.all(context.paddingMedium),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    receiptAnalysisModeIcon(option.iconKey),
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.mutedForeground,
                  ),
                  SizedBox(width: context.spaceSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.label,
                          style: theme.textTheme.p.copyWith(
                            color: theme.colorScheme.cardForeground,
                          ),
                        ),
                        if (option.description case final description?)
                          Text(
                            description,
                            style: theme.textTheme.muted.copyWith(
                              color: theme.colorScheme.mutedForeground,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    selected ? LucideIcons.circleCheck : LucideIcons.circle,
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.mutedForeground,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class ReceiptConfigPreparation {
  const ReceiptConfigPreparation.success(this.config) : error = null;
  const ReceiptConfigPreparation.failure(this.error) : config = null;

  final RunConfigState? config;
  final String? error;
}

@visibleForTesting
ReceiptConfigPreparation prepareReceiptRunConfig({
  required RunConfigState config,
  required GoogleSheetSelectionState selection,
  required PresetInputSchema schema,
  required PresetDetails details,
}) {
  final analysisMode = config.inputs['analysisMode']?.trim() ?? '';
  if (analysisMode.isEmpty) {
    return const ReceiptConfigPreparation.failure('Choose an analysis goal');
  }
  final modeOption = schema.analysisModeOption(analysisMode);
  if (modeOption == null) {
    return const ReceiptConfigPreparation.failure('Choose a valid analysis goal');
  }

  final spreadsheetId = selection.spreadsheetId?.trim() ?? '';
  if (spreadsheetId.isEmpty) {
    return const ReceiptConfigPreparation.failure('Select a spreadsheet');
  }
  final tabTitle = selection.tabTitle?.trim() ?? '';
  if (tabTitle.isEmpty) {
    return const ReceiptConfigPreparation.failure('Select a sheet tab');
  }
  final range = config.inputs['range']?.trim() ?? '';
  if (range.isEmpty) {
    return const ReceiptConfigPreparation.failure('Enter a sheet range');
  }
  final mapping = selection.headerMapping;
  const requiredColumns = {'date', 'merchant', 'category', 'amount'};
  if (!mapping.keys.toSet().containsAll(requiredColumns) ||
      mapping.values.map((value) => value.trim()).toSet().length != 4) {
    return const ReceiptConfigPreparation.failure(
      'Map four distinct receipt columns',
    );
  }
  final asOfDate = config.inputs['asOfDate']?.trim() ?? '';
  if (DateTime.tryParse(asOfDate) == null) {
    return const ReceiptConfigPreparation.failure('Choose a report date');
  }
  final currency = config.inputs['currencyCode']?.trim().toUpperCase() ?? '';
  if (!RegExp(r'^[A-Z]{3}$').hasMatch(currency)) {
    return const ReceiptConfigPreparation.failure(
      'Enter a three-letter currency code',
    );
  }

  for (final fieldKey in modeOption.requiresFields) {
    final field = schema.fieldForKey(fieldKey);
    final label = field?.label ?? humanizePresetToken(fieldKey);
    final value = config.inputs[fieldKey]?.trim() ?? '';
    if (fieldKey == 'budget') {
      final parsed = double.tryParse(value);
      if (parsed == null || parsed <= 0) {
        return ReceiptConfigPreparation.failure(
          'Enter a $label greater than zero',
        );
      }
    } else if (fieldKey == 'taxRate') {
      final parsed = double.tryParse(value);
      if (parsed == null || parsed < 0 || parsed > 1) {
        return const ReceiptConfigPreparation.failure(
          'Enter a tax rate between 0 and 1',
        );
      }
    } else if (AppValidators.requiredNonEmpty(value) != null) {
      return ReceiptConfigPreparation.failure('Enter $label');
    }
  }

  final deliveryMode = config.inputs['deliveryMode']?.trim().isNotEmpty == true
      ? config.inputs['deliveryMode']!.trim()
      : 'preview';
  final recipient = config.inputs['recipientEmail']?.trim() ?? '';
  if (deliveryMode == 'email' || deliveryMode == 'both') {
    if (recipient.isEmpty ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(recipient)) {
      return const ReceiptConfigPreparation.failure(
        'Enter a valid recipient email',
      );
    }
  }

  final inputs = Map<String, String>.from(config.inputs)
    ..remove('range')
    ..['analysisMode'] = analysisMode
    ..['spreadsheetId'] = spreadsheetId
    ..['sourceRange'] = receiptSourceRange(tabTitle, range)
    ..['columnMappingJson'] = receiptColumnMappingJson(mapping)
    ..['asOfDate'] = asOfDate
    ..['currencyCode'] = currency
    ..['deliveryMode'] = deliveryMode;

  for (final inactive
      in receiptInactiveInputKeys(schema: schema, inputs: inputs)) {
    inputs.remove(inactive);
  }

  for (final key in ['budget', 'taxRate', 'category', 'recipientEmail']) {
    final value = inputs[key]?.trim() ?? '';
    if (value.isEmpty) {
      inputs.remove(key);
    } else {
      inputs[key] = value;
    }
  }

  if (schema.fieldForKey('reportTabTitle') case final reportTabField?
      when !schema.isFieldVisible(reportTabField, inputs)) {
    inputs.remove('reportTabTitle');
  }

  final agent = details.configurableWorkflowAgent();
  final overrides = Map<String, AgentOverrideDraft>.from(config.agentOverrides);
  if (agent != null) {
    overrides.putIfAbsent(
      agent.key,
      () => AgentOverrideDraft(
        provider: agent.modelConfiguration.provider,
        model: agent.modelConfiguration.selectedModel,
        temperature: agent.modelConfiguration.isTemperatureEditable
            ? agent.modelConfiguration.temperature
            : null,
      ),
    );
  }

  return ReceiptConfigPreparation.success(
    config.copyWith(
      topic: modeOption.label,
      inputs: inputs,
      agentOverrides: overrides,
    ),
  );
}
