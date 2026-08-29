import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_screen.dart';
import 'package:arzlyai_mobile/ui/features/workflow_runs/configure_run_screen.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_integration_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_status.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_workflow_graph.dart';

class PresetDetailsScreen extends ConsumerWidget {
  const PresetDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(presetDetailsProvider);
    final theme = ShadTheme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          details.maybeWhen(
            data: (preset) => preset?.name ?? 'Preset',
            orElse: () => 'Preset',
          ),
          style: theme.textTheme.h4.copyWith(color: theme.colorScheme.foreground),
        ),
      ),
      body: details.when(
        data: (preset) {
          if (preset == null) {
            return Center(
              child: Text(
                'Select a preset',
                style: theme.textTheme.p.copyWith(color: theme.colorScheme.foreground),
              ),
            );
          }
          final configurableAgent = preset.configurableWorkflowAgent();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(context.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        preset.description,
                        style: theme.textTheme.p.copyWith(
                          color: theme.colorScheme.foreground,
                        ),
                      ),
                      SizedBox(height: context.spaceMedium),
                      Text(
                        'Workflow',
                        style: theme.textTheme.h4.copyWith(
                          color: theme.colorScheme.foreground,
                        ),
                      ),
                      SizedBox(height: context.spaceSmall),
                      AppWorkflowGraph(
                        nodes: preset.workflow.nodes,
                        connections: preset.workflow.connections,
                      ),
                      if (preset.integrations.isNotEmpty) ...[
                        SizedBox(height: context.spaceMedium),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Required integrations',
                                style: theme.textTheme.h4.copyWith(
                                  color: theme.colorScheme.foreground,
                                ),
                              ),
                            ),
                            ShadButton.ghost(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SettingsScreen(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    LucideIcons.settings,
                                    size: 14,
                                    color: theme.colorScheme.primary,
                                  ),
                                  SizedBox(width: context.spaceSmall / 2),
                                  Text(
                                    'Settings',
                                    style: theme.textTheme.small.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.spaceSmall),
                        ...preset.integrations.map(
                          (integration) => Padding(
                            padding: EdgeInsets.only(bottom: context.spaceSmall),
                            child: AppIntegrationCard(integration: integration),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(context.paddingMedium),
                child: AppButton.primary(
                  label: 'Configure run',
                  onPressed: configurableAgent == null
                      ? null
                      : () {
                          ref.read(runConfigTempProvider.notifier).update(
                            RunConfigState(
                              topic: '',
                              model: configurableAgent.modelConfiguration.selectedModel,
                              temperature: configurableAgent.modelConfiguration.temperature,
                            ),
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ConfigureRunScreen(),
                            ),
                          );
                        },
                ),
              ),
            ],
          );
        },
        loading: () => const AppStatus.loading(),
        error: (error, _) => AppStatus.error(message: '$error'),
      ),
    );
  }
}
