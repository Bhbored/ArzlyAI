import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';

class AppWorkflowNodeScreen extends ConsumerWidget {
  const AppWorkflowNodeScreen({required this.node, super.key});

  final WorkflowNode node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runAsync = ref.watch(activeRunProvider);
    final theme = ShadTheme.of(context);
    final nodeRun = runAsync.value?.nodes
        .where((n) => n.nodeId == node.id)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(title: Text(node.displayName, style: theme.textTheme.h4)),
      body: AppLoadingOverlay(
        visible: runAsync.isLoading,
        child: ListView(
          padding: EdgeInsets.all(context.paddingMedium),
          children: [
            if (nodeRun != null)
              AppCard.standard(
                title: nodeRun.status.wireValue,
                child: Text(
                  nodeRun.output ?? nodeRun.error ?? 'No output yet.',
                  style: theme.textTheme.p,
                ),
              )
            else
              AppCard.standard(
                child: Text(
                  'No run data for this step.',
                  style: theme.textTheme.p,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
