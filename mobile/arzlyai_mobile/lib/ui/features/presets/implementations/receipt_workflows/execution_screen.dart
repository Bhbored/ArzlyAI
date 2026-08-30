import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/receipt_workflows/receipt_workflow_metadata.dart';
import 'package:arzlyai_mobile/ui/features/presets/preset_run_router.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_status.dart';

class ReceiptExecutionScreen extends ConsumerStatefulWidget {
  const ReceiptExecutionScreen({super.key});

  @override
  ConsumerState<ReceiptExecutionScreen> createState() =>
      _ReceiptExecutionScreenState();
}

class _ReceiptExecutionScreenState
    extends ConsumerState<ReceiptExecutionScreen> {
  String? _consumed;

  @override
  Widget build(BuildContext context) {
    final run = ref.watch(activeRunProvider);
    final theme = ShadTheme.of(context);
    final metadata = run.value == null
        ? null
        : receiptMetadataForKey(run.value!.presetKey);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          metadata == null ? 'Analyzing receipts' : metadata.shortTitle,
          style: theme.textTheme.h4,
        ),
      ),
      body: run.when(
        data: (value) {
          if (value == null) {
            return const AppStatus.error(message: 'No receipt run found.');
          }
          final token = '${value.runId}:${value.status.wireValue}';
          if (_consumed != token && _isTerminal(value.status)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted || _consumed == token) return;
              _consumed = token;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => resultScreenForPreset(value.presetKey),
                ),
              );
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
                    child:
                        node.isRunning ||
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
          correlationId: error is ApiException ? error.correlationId : null,
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
      WorkflowNodeStatus.waitingForApproval => 'Needs attention',
      _ => 'Waiting',
    };
  }
}
