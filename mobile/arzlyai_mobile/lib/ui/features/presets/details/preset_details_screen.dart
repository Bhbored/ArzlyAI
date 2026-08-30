import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception_extensions.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/data/providers/preset/preset_details_provider.dart';
import 'package:arzlyai_mobile/data/providers/selection/selected_run_id_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/review_draft_temp.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/workflow_transport_provider.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/ui/features/settings/settings_screen.dart';
import 'package:arzlyai_mobile/ui/features/presets/preset_run_router.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_integration_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_dialog.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_toast.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_live_workflow_graph.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_workflow_node_screen.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_status.dart';

class PresetDetailsScreen extends ConsumerStatefulWidget {
  const PresetDetailsScreen({super.key});

  @override
  ConsumerState<PresetDetailsScreen> createState() =>
      _PresetDetailsScreenState();
}

class _PresetDetailsScreenState extends ConsumerState<PresetDetailsScreen> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(activeRunProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          if (previous?.hasError == true) return;
          if (isReceiveTimeoutError(error)) return;
          if (!mounted) return;
          AppToast.errorFor(context, error);
        },
      );
      next.whenData((run) {
        if (run?.status == WorkflowRunStatus.waitingForApproval &&
            previous?.value?.approval?.originalContent !=
                run?.approval?.originalContent) {
          ref.read(reviewDraftTempProvider.notifier).clear();
        }
      });
    }, fireImmediately: true);
  }

  bool _isTerminal(WorkflowRunStatus status) {
    return status == WorkflowRunStatus.completed ||
        status == WorkflowRunStatus.failed ||
        status == WorkflowRunStatus.cancelled ||
        status == WorkflowRunStatus.expired;
  }

  WorkflowNode? _entryNode(PresetDetails preset) {
    final entry = preset.primaryWorkflowAgent();
    if (entry == null) return null;
    return preset.workflow.nodes
        .where((node) => node.key == entry.key)
        .firstOrNull;
  }

  Agent? _configureDefaultsAgent(PresetDetails preset) =>
      preset.configurableWorkflowAgent() ?? preset.primaryWorkflowAgent();

  Future<void> _resetWorkflow() async {
    ref.read(runConfigTempProvider.notifier).clear();
    ref.read(reviewDraftTempProvider.notifier).clear();
    await ref.read(activeRunProvider.notifier).reset();
  }

  void _openConfigure(PresetDetails preset) {
    final runScreen = configureRunScreenForPreset(preset.key);
    final defaults = _configureDefaultsAgent(preset);
    if (runScreen == null || defaults == null) return;
    ref
        .read(runConfigTempProvider.notifier)
        .update(
          RunConfigState(
            topic: '',
            model: defaults.modelConfiguration.selectedModel,
            temperature: defaults.modelConfiguration.temperature,
          ),
        );
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => runScreen));
  }

  void _openReview(String presetKey) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => reviewScreenForPreset(presetKey)));
  }

  void _openNodeDetails(WorkflowNode node) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AppWorkflowNodeScreen(node: node)),
    );
  }

  void _openResult(String presetKey) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => resultScreenForPreset(presetKey)));
  }

  bool _isEntryAgent(PresetDetails preset, WorkflowNode node) {
    final entry = preset.primaryWorkflowAgent();
    final entryNode = _entryNode(preset);
    return entry != null &&
        (node.id == entryNode?.id || node.key == entry.key);
  }

  bool _isNodeTapEnabled(
    PresetDetails preset,
    WorkflowNode node,
    WorkflowNodeStatus? status,
  ) {
    if (node.type == 'Agent' && status == WorkflowNodeStatus.completed) {
      final run = ref.read(activeRunProvider).value;
      if (_isEntryAgent(preset, node) &&
          (run == null || _isTerminal(run.status))) {
        return true;
      }
      return false;
    }
    return true;
  }

  void _onWorkflowNodeTap(
    PresetDetails preset,
    WorkflowNode node,
    WorkflowNodeStatus? status,
  ) {
    if (ref.read(activeRunProvider).isLoading) return;
    if (ref.read(workflowTransportProvider).isProcessing) return;
    final run = ref.read(activeRunProvider).value;
    final transport = ref.read(workflowTransportProvider);
    final entry = preset.primaryWorkflowAgent();
    final entryNode = _entryNode(preset);

    if (entry != null &&
        (node.id == entryNode?.id || node.key == entry.key)) {
      if (run == null || _isTerminal(run.status)) {
        _openConfigure(preset);
      }
      return;
    }

    if (node.type == 'Agent') {
      if (status == WorkflowNodeStatus.failed) {
        _openNodeDetails(node);
      }
      return;
    }

    if (node.type == 'HumanApproval') {
      if (status == WorkflowNodeStatus.waitingForApproval) {
        if (transport.blocksApproval) return;
        _openReview(preset.key);
      } else if (status == WorkflowNodeStatus.completed &&
          run != null &&
          _isTerminal(run.status) &&
          (node.resultContract != null || run.report != null)) {
        _openResult(preset.key);
      } else if (status == WorkflowNodeStatus.completed) {
        _openReview(preset.key);
      }
      return;
    }

    if (node.type == 'Integration' &&
        status == WorkflowNodeStatus.completed &&
        run != null &&
        _isTerminal(run.status)) {
      _openResult(preset.key);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(presetDetailsProvider);
    final activeRunId = ref.watch(selectedRunIdProvider);
    final transport = ref.watch(workflowTransportProvider);
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          details.maybeWhen(
            data: (preset) => preset?.name ?? 'Preset',
            orElse: () => 'Preset',
          ),
          style: theme.textTheme.h4.copyWith(
            color: theme.colorScheme.foreground,
          ),
        ),
        actions: activeRunId == null
            ? null
            : [
                ShadButton.ghost(
                  onPressed: () async {
                    final ok = await AppDialog.confirm(
                      context,
                      title: 'Start over',
                      message:
                          'Clear the current run and configure a new workflow?',
                    );
                    if (!ok) return;
                    await _resetWorkflow();
                  },
                  child: Text(
                    'Start over',
                    style: theme.textTheme.small.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
      ),
      body: details.when(
        data: (preset) {
          if (preset == null) {
            return Center(
              child: Text(
                'Select a preset',
                style: theme.textTheme.p.copyWith(
                  color: theme.colorScheme.foreground,
                ),
              ),
            );
          }

          return SingleChildScrollView(
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
                SizedBox(height: context.spaceSmall / 2),
                Text(
                  'Tap a step to configure or view details.',
                  style: theme.textTheme.muted.copyWith(
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
                SizedBox(height: context.spaceSmall),
                if (transport.isProcessing) ...[
                  Text(
                    'Still processing',
                    style: theme.textTheme.p.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: context.spaceSmall / 2),
                ],
                AppLiveWorkflowGraph(
                  nodes: preset.workflow.nodes,
                  connections: preset.workflow.connections,
                  startingNodeId: _entryNode(preset)?.id,
                  isNodeTapEnabled: (node, status) =>
                      _isNodeTapEnabled(preset, node, status),
                  onNodeTap: (node, status) =>
                      _onWorkflowNodeTap(preset, node, status),
                ),
                if (activeRunId != null) ...[
                  SizedBox(height: context.spaceSmall),
                  AppButton.ghost(
                    label: 'Start over',
                    onPressed: () async {
                      final ok = await AppDialog.confirm(
                        context,
                        title: 'Start over',
                        message:
                            'Clear the current run and configure a new workflow?',
                      );
                      if (!ok) return;
                      await _resetWorkflow();
                    },
                  ),
                ],
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
                              size: context.iconSmall,
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
          );
        },
        loading: () => const AppStatus.loading(),
        error: (error, _) => AppStatus.error(message: '$error'),
      ),
    );
  }
}
