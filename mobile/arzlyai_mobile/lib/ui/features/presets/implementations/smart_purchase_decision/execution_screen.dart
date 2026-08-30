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

class SmartPurchaseExecutionScreen extends ConsumerStatefulWidget {
  const SmartPurchaseExecutionScreen({super.key});

  @override
  ConsumerState<SmartPurchaseExecutionScreen> createState() =>
      _SmartPurchaseExecutionScreenState();
}

class _SmartPurchaseExecutionScreenState
    extends ConsumerState<SmartPurchaseExecutionScreen> {
  String? _consumed;

  @override
  Widget build(BuildContext context) {
    final run = ref.watch(activeRunProvider);
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Finding options', style: theme.textTheme.h4)),
      body: run.when(
        data: (value) {
          if (value == null) {
            return Center(child: Text('No run', style: theme.textTheme.p));
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
              } else if (value.status == WorkflowRunStatus.completed ||
                  value.status == WorkflowRunStatus.failed ||
                  value.status == WorkflowRunStatus.cancelled ||
                  value.status == WorkflowRunStatus.expired) {
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
              ...value.nodes.map(
                (node) => Padding(
                  padding: EdgeInsets.only(bottom: context.spaceSmall),
                  child: AppCard.standard(
                    title: node.displayName,
                    child: Row(
                      children: [
                        if (node.isRunning ||
                            node.status == WorkflowNodeStatus.running)
                          const AppLoadingIndicator(small: true)
                        else
                          Text(
                            _friendlyStatus(node.displayName, node.status),
                            style: theme.textTheme.muted,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const AppStatus.loading(),
        error: (error, _) {
          final message = error is ApiException ? error.userMessage : '$error';
          final correlation = error is ApiException
              ? error.correlationId
              : null;
          return AppStatus.error(message: message, correlationId: correlation);
        },
      ),
    );
  }

  String _friendlyStatus(String displayName, WorkflowNodeStatus status) {
    if (status == WorkflowNodeStatus.completed) return 'Done';
    if (status == WorkflowNodeStatus.failed) return 'Failed';
    if (status == WorkflowNodeStatus.waitingForApproval) return 'Needs you';
    if (status == WorkflowNodeStatus.running) return 'Working…';
    return displayName;
  }
}
