import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/data/providers/temp/review_draft_temp.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/ui/features/workflow_runs/review_screen.dart';
import 'package:arzlyai_mobile/ui/features/workflow_runs/result_screen.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_status.dart';

class ExecutionScreen extends ConsumerStatefulWidget {
  const ExecutionScreen({super.key});

  @override
  ConsumerState<ExecutionScreen> createState() => _ExecutionScreenState();
}

class _ExecutionScreenState extends ConsumerState<ExecutionScreen> {
  String? _consumed;

  @override
  Widget build(BuildContext context) {
    final run = ref.watch(activeRunProvider);
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Execution', style: theme.textTheme.h4)),
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
                ref.read(reviewDraftTempProvider.notifier).update(
                  value.approval?.currentContent ?? '',
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ReviewScreen()),
                );
              } else if (value.status == WorkflowRunStatus.completed ||
                  value.status == WorkflowRunStatus.failed ||
                  value.status == WorkflowRunStatus.cancelled ||
                  value.status == WorkflowRunStatus.expired) {
                _consumed = token;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ResultScreen()),
                );
              }
            });
          }
          return ListView(
            padding: EdgeInsets.all(context.paddingMedium),
            children: [
              ...value.nodes.map((node) {
                final running =
                    node.isRunning || node.status == WorkflowNodeStatus.running;
                return Padding(
                  padding: EdgeInsets.only(bottom: context.spaceSmall),
                  child: AppCard.standard(
                    title: node.displayName,
                    child: Row(
                      children: [
                        if (running)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          Text(node.status.wireValue, style: theme.textTheme.muted),
                      ],
                    ),
                  ),
                );
              }),
              AppButton.ghost(
                label: 'Recover',
                onPressed: () => ref.read(activeRunProvider.notifier).recover(),
              ),
            ],
          );
        },
        loading: () => const AppStatus.loading(),
        error: (error, _) {
          final message = error is ApiException ? error.userMessage : '$error';
          final correlation = error is ApiException ? error.correlationId : null;
          return AppStatus.error(message: message, correlationId: correlation);
        },
      ),
    );
  }
}
