import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_transport_state.dart';
import 'package:arzlyai_mobile/data/providers/workflow/active_run_provider.dart';
import 'package:arzlyai_mobile/data/providers/workflow/workflow_transport_provider.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_workflow_graph.dart';

class AppLiveWorkflowGraph extends ConsumerWidget {
  const AppLiveWorkflowGraph({
    required this.nodes,
    required this.connections,
    this.startingNodeId,
    this.onNodeTap,
    this.isNodeTapEnabled,
    super.key,
  });

  final List<WorkflowNode> nodes;
  final List<WorkflowConnection> connections;
  final String? startingNodeId;
  final void Function(WorkflowNode node, WorkflowNodeStatus? status)? onNodeTap;
  final bool Function(WorkflowNode node, WorkflowNodeStatus? status)?
      isNodeTapEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runAsync = ref.watch(activeRunProvider);
    final transport = ref.watch(workflowTransportProvider);
    final run = runAsync.value;
    final isStarting = runAsync.isLoading ||
        transport.transport == WorkflowTransportState.inFlight ||
        transport.isProcessing;
    final nodeStatuses = <String, WorkflowNodeStatus>{};
    if (run != null) {
      for (final nodeRun in run.nodes) {
        nodeStatuses[nodeRun.nodeId] = nodeRun.status;
      }
    }
    if (isStarting && startingNodeId != null) {
      nodeStatuses[startingNodeId!] = WorkflowNodeStatus.running;
    }
    return AppWorkflowGraph(
      nodes: nodes,
      connections: connections,
      nodeStatuses: nodeStatuses,
      onNodeTap: onNodeTap,
      isNodeTapEnabled: isNodeTapEnabled,
    );
  }
}
