import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/geo/country_currency.dart';
import 'package:arzlyai_mobile/data/providers/models/openai_models_provider.dart';
import 'package:arzlyai_mobile/data/providers/network/internet_connection_provider.dart';
import 'package:arzlyai_mobile/data/providers/offline/offline_mode_provider.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/domain/entities/provider/openai_model.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_country_select.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_model_select.dart';
import 'package:arzlyai_mobile/ui/validators/app_validators.dart';

class SmartPurchaseConfigureRunScreen extends ConsumerStatefulWidget {
  const SmartPurchaseConfigureRunScreen({super.key});

  @override
  ConsumerState<SmartPurchaseConfigureRunScreen> createState() =>
      _SmartPurchaseConfigureRunScreenState();
}

class _SmartPurchaseConfigureRunScreenState
    extends ConsumerState<SmartPurchaseConfigureRunScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _seedDefaults());
    ref.listenManual(openAiModelsProvider, (prev, next) {
      final details = ref.read(presetDetailsProvider).value;
      final shopper = details?.configurableWorkflowAgent();
      if (shopper == null) return;
      next.whenData((models) => _syncModelSelection(models, shopper));
    }, fireImmediately: true);
  }

  void _seedDefaults() {
    final current = ref.read(runConfigTempProvider);
    if (current.inputs.isNotEmpty) return;
    final country =
        PlatformDispatcher.instance.locale.countryCode?.toUpperCase() ?? 'US';
    ref
        .read(runConfigTempProvider.notifier)
        .update(
          current.copyWith(
            inputs: {
              'purchaseGoal': '',
              'budget': '',
              'notes': '',
              'countryCode': country,
              'currencyCode': currencyCodeForCountry(country),
            },
          ),
        );
  }

  void _syncModelSelection(List<OpenAiModel> models, Agent shopper) {
    if (models.isEmpty) return;
    final current = ref.read(runConfigTempProvider);
    final presetDefault = shopper.modelConfiguration.selectedModel;
    final modelIds = models.map((model) => model.id).toSet();
    final existing = current.agentOverrides[shopper.key]?.model;
    if (existing != null && modelIds.contains(existing)) return;
    final chosen = modelIds.contains(presetDefault)
        ? presetDefault
        : models.first.id;
    final supports = models
        .firstWhere((model) => model.id == chosen)
        .supportsTemperature;
    final overrides = Map<String, AgentOverrideDraft>.from(
      current.agentOverrides,
    );
    overrides[shopper.key] = AgentOverrideDraft(
      model: chosen,
      temperature: supports ? shopper.modelConfiguration.temperature : null,
    );
    ref
        .read(runConfigTempProvider.notifier)
        .update(current.copyWith(agentOverrides: overrides));
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(runConfigTempProvider);
    final details = ref.watch(presetDetailsProvider).value;
    final theme = ShadTheme.of(context);
    final shopper = details?.configurableWorkflowAgent();
    final modelsAsync = ref.watch(openAiModelsProvider);
    final online = ref.watch(internetConnectionProvider);
    final offlineMode = ref.watch(offlineModeProvider).value ?? false;
    final goal = config.inputs['purchaseGoal']?.trim() ?? '';
    final country = config.inputs['countryCode']?.trim() ?? '';
    final modelsReady =
        shopper == null ||
        !shopper.modelConfiguration.isModelEditable ||
        modelsAsync.hasValue && modelsAsync.value!.isNotEmpty;
    final blocked =
        AppValidators.requiredNonEmpty(goal) != null ||
        AppValidators.requiredNonEmpty(country) != null ||
        !online ||
        offlineMode ||
        !modelsReady;
    final shopperOverride = shopper == null
        ? null
        : config.agentOverrides[shopper.key];
    final selectedModelId =
        shopperOverride?.model ?? shopper?.modelConfiguration.selectedModel;
    final selectedOnlineModel = modelsAsync.value
        ?.where((model) => model.id == selectedModelId)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(title: Text('Smart Buy', style: theme.textTheme.h4)),
      body: ListView(
        padding: EdgeInsets.all(context.paddingMedium),
        children: [
          Text('What are you buying?', style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall / 2),
          ShadInput(
            initialValue: config.inputs['purchaseGoal'] ?? '',
            maxLines: 4,
            placeholder: const Text(
              'e.g. Quiet vacuum for pet hair under \$200',
            ),
            onChanged: (value) => _updateInput('purchaseGoal', value),
          ),
          SizedBox(height: context.spaceMedium),
          Text('Budget (optional)', style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall / 2),
          ShadInput(
            initialValue: config.inputs['budget'] ?? '',
            placeholder: Text('Max ${config.inputs['currencyCode'] ?? 'USD'}'),
            onChanged: (value) => _updateInput('budget', value),
          ),
          SizedBox(height: context.spaceMedium),
          Text('Anything else that matters?', style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall / 2),
          ShadInput(
            initialValue: config.inputs['notes'] ?? '',
            maxLines: 3,
            placeholder: const Text('Pets, quiet operation, brands you like…'),
            onChanged: (value) => _updateInput('notes', value),
          ),
          SizedBox(height: context.spaceMedium),
          AppCountrySelect(
            fieldKey: 'countryCode',
            label: 'Where are you shopping?',
            onSelected: (code) {
              final current = ref.read(runConfigTempProvider);
              final inputs = Map<String, String>.from(current.inputs)
                ..['currencyCode'] = currencyCodeForCountry(code);
              ref
                  .read(runConfigTempProvider.notifier)
                  .update(current.copyWith(inputs: inputs));
            },
          ),
          if (shopper != null &&
              shopper.modelConfiguration.isModelEditable) ...[
            SizedBox(height: context.spaceMedium),
            Text('Model', style: theme.textTheme.small),
            SizedBox(height: context.spaceSmall / 2),
            AppModelSelect.forAgent(
              agentKey: shopper.key,
              defaultModelId: shopper.modelConfiguration.selectedModel,
              requiresWebSearch: shopper.harness.webSearchEnabled,
              enabled: true,
              onRetry: () => ref.read(openAiModelsProvider.notifier).refresh(),
            ),
          ],
          if (shopper != null &&
              selectedOnlineModel?.supportsTemperature == true) ...[
            SizedBox(height: context.spaceMedium),
            Text(
              'Temperature ${shopperOverride?.temperature ?? shopper.modelConfiguration.temperature}',
              style: theme.textTheme.small,
            ),
            Slider(
              min: shopper.modelConfiguration.minimumTemperature,
              max: shopper.modelConfiguration.maximumTemperature,
              value: AppValidators.clampTemperature(
                shopperOverride?.temperature ??
                    shopper.modelConfiguration.temperature,
                shopper.modelConfiguration.minimumTemperature,
                shopper.modelConfiguration.maximumTemperature,
              ),
              onChanged: (value) {
                final current = ref.read(runConfigTempProvider);
                final overrides = Map<String, AgentOverrideDraft>.from(
                  current.agentOverrides,
                );
                overrides[shopper.key] =
                    (overrides[shopper.key] ??
                            AgentOverrideDraft(model: selectedModelId))
                        .copyWith(temperature: value);
                ref
                    .read(runConfigTempProvider.notifier)
                    .update(current.copyWith(agentOverrides: overrides));
              },
            ),
          ],
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
            label: 'Find options',
            onPressed: blocked
                ? null
                : () {
                    if (_prepareStart(details) case final config?) {
                      ref.read(activeRunProvider.notifier).start(config);
                      Navigator.of(context).pop();
                    }
                  },
          ),
        ],
      ),
    );
  }

  void _updateInput(String key, String value) {
    final current = ref.read(runConfigTempProvider);
    final inputs = Map<String, String>.from(current.inputs)..[key] = value;
    if (key == 'countryCode') {
      inputs['currencyCode'] = currencyCodeForCountry(value.trim());
    }
    ref
        .read(runConfigTempProvider.notifier)
        .update(current.copyWith(inputs: inputs));
  }

  RunConfigState? _prepareStart(PresetDetails? details) {
    if (details == null) return null;
    setState(() => _error = null);
    final config = ref.read(runConfigTempProvider);
    final inputs = Map<String, String>.from(config.inputs);
    final goal = inputs['purchaseGoal']?.trim() ?? '';
    if (AppValidators.requiredNonEmpty(goal) != null) {
      setState(() => _error = 'Tell us what you want to buy');
      return null;
    }
    final country = inputs['countryCode']?.trim() ?? '';
    if (AppValidators.requiredNonEmpty(country) != null) {
      setState(() => _error = 'Choose where you are shopping');
      return null;
    }
    inputs['currencyCode'] = currencyCodeForCountry(country);
    final budget = inputs['budget']?.trim() ?? '';
    if (budget.isNotEmpty) {
      final budgetError = AppValidators.nonNegativeDecimal(budget);
      if (budgetError != null) {
        setState(() => _error = budgetError);
        return null;
      }
    } else {
      inputs.remove('budget');
    }
    final notes = inputs['notes']?.trim() ?? '';
    if (notes.isEmpty) {
      inputs.remove('notes');
    } else {
      inputs['notes'] = notes;
    }
    final shopper = details.configurableWorkflowAgent();
    final agentOverrides = Map<String, AgentOverrideDraft>.from(
      config.agentOverrides,
    );
    if (shopper != null) {
      agentOverrides.putIfAbsent(
        shopper.key,
        () => AgentOverrideDraft(
          model: shopper.modelConfiguration.selectedModel,
          temperature: shopper.modelConfiguration.isTemperatureEditable
              ? shopper.modelConfiguration.temperature
              : null,
        ),
      );
    }
    return config.copyWith(
      topic: goal,
      inputs: inputs,
      agentOverrides: agentOverrides,
    );
  }
}
