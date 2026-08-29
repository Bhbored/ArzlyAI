import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_workflow_graph.dart';

class AppLiveWorkflowGraph extends ConsumerWidget {
  const AppLiveWorkflowGraph({
    required this.nodes,
    required this.connections,
    this.onNodeTap,
    super.key,
  });

  final List<WorkflowNode> nodes;
  final List<WorkflowConnection> connections;
  final void Function(WorkflowNode node, WorkflowNodeStatus? status)? onNodeTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final run = ref.watch(activeRunProvider).value;
    final nodeStatuses = <String, WorkflowNodeStatus>{};
    if (run != null) {
      for (final nodeRun in run.nodes) {
        nodeStatuses[nodeRun.nodeId] = nodeRun.status;
      }
    }
    return AppWorkflowGraph(
      nodes: nodes,
      connections: connections,
      nodeStatuses: nodeStatuses,
      onNodeTap: onNodeTap,
    );
  }
}
