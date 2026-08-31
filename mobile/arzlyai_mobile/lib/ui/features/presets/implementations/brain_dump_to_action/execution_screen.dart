import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/data/providers/temp/review_draft_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/ui/features/presets/preset_run_router.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_status.dart';

class BrainDumpExecutionScreen extends ConsumerStatefulWidget {
  const BrainDumpExecutionScreen({super.key});

  @override
  ConsumerState<BrainDumpExecutionScreen> createState() =>
      _BrainDumpExecutionScreenState();
}

class _BrainDumpExecutionScreenState
    extends ConsumerState<BrainDumpExecutionScreen> {
  String? _consumed;

  @override
  Widget build(BuildContext context) {
    final run = ref.watch(activeRunProvider);
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Building your plan', style: theme.textTheme.h4),
      ),
      body: run.when(
        data: (value) {
          if (value == null) {
            return const AppStatus.error(message: 'No brain dump run found.');
          }
          final token = '${value.runId}:${value.status.wireValue}';
          if (_consumed != token) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted || _consumed == token) return;
              if (value.status == WorkflowRunStatus.waitingForApproval) {
                _consumed = token;
                ref.read(reviewDraftTempProvider.notifier).clear();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => reviewScreenForPreset(value.presetKey),
                  ),
                );
              } else if (_isTerminal(value.status)) {
                _consumed = token;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => resultScreenForPreset(value.presetKey),
                  ),
                );
              }
            });
          }
          return ListView(
            padding: EdgeInsets.all(context.paddingMedium),
            children: [
              for (final node in value.nodes)
                Padding(
                  padding: EdgeInsets.only(bottom: context.spaceSmall),
                  child: AppCard.standard(
                    title: node.displayName,
                    child: node.isRunning ||
                            node.status == WorkflowNodeStatus.running
                        ? const AppLoadingIndicator(small: true)
                        : Text(
                            _statusLabel(node.status),
                            style: theme.textTheme.muted,
                          ),
                  ),
                ),
            ],
          );
        },
        loading: () => const AppStatus.loading(),
        error: (error, _) => AppStatus.error(
          message: error is ApiException ? error.userMessage : '$error',
        ),
      ),
    );
  }

  bool _isTerminal(WorkflowRunStatus status) {
    return status == WorkflowRunStatus.completed ||
        status == WorkflowRunStatus.failed ||
        status == WorkflowRunStatus.cancelled ||
        status == WorkflowRunStatus.expired;
  }

  String _statusLabel(WorkflowNodeStatus status) {
    return switch (status) {
      WorkflowNodeStatus.completed => 'Done',
      WorkflowNodeStatus.failed => 'Failed',
      WorkflowNodeStatus.running => 'Working…',
      WorkflowNodeStatus.waitingForApproval => 'Needs review',
      WorkflowNodeStatus.skipped => 'Skipped',
      _ => 'Waiting',
    };
  }
}
