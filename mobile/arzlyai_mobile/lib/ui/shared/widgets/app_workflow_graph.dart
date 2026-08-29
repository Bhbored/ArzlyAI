import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';

class AppWorkflowGraph extends StatelessWidget {
  const AppWorkflowGraph({
    required this.nodes,
    required this.connections,
    this.nodeStatuses = const {},
    this.onNodeTap,
    super.key,
  });

  final List<WorkflowNode> nodes;
  final List<WorkflowConnection> connections;
  final Map<String, WorkflowNodeStatus> nodeStatuses;
  final void Function(WorkflowNode node, WorkflowNodeStatus? status)? onNodeTap;

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = ShadTheme.of(context);
    final nodeHeight = context.workflowNodeHeight;
    final verticalGap = context.workflowVerticalGap;
    final portRadius = context.workflowPortRadius;
    final ordered = [...nodes]
      ..sort((a, b) => a.position.compareTo(b.position));
    final horizontalPadding = context.paddingMedium;
    final nodeWidth = context.screenWidth - horizontalPadding * 4;
    final canvasWidth = nodeWidth + horizontalPadding * 2;
    final canvasHeight =
        horizontalPadding * 2 +
        ordered.length * nodeHeight +
        (ordered.length - 1) * verticalGap;

    final nodeRects = <String, Rect>{};
    for (var i = 0; i < ordered.length; i++) {
      final x = horizontalPadding;
      final y = horizontalPadding + i * (nodeHeight + verticalGap);
      nodeRects[ordered[i].id] = Rect.fromLTWH(x, y, nodeWidth, nodeHeight);
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(context.borderRadiusMedium),
        border: Border.all(color: theme.colorScheme.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.borderRadiusMedium),
        child: CustomPaint(
          foregroundPainter: _WorkflowGridPainter(
            color: theme.colorScheme.border.withValues(alpha: 0.35),
            spacing: context.workflowGridSpacing,
          ),
          child: SizedBox(
            width: canvasWidth,
            height: canvasHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: Size(canvasWidth, canvasHeight),
                  painter: _WorkflowEdgePainter(
                    connections: connections,
                    nodeRects: nodeRects,
                    color: theme.colorScheme.primary,
                    portRadius: portRadius,
                    vertical: true,
                    strokeWidth: context.borderWidthThick,
                  ),
                ),
                ...ordered.map((node) {
                  final rect = nodeRects[node.id]!;
                  return Positioned(
                    left: rect.left,
                    top: rect.top,
                    width: rect.width,
                    height: rect.height,
                    child: _WorkflowNodeTile(
                      node: node,
                      status: nodeStatuses[node.id],
                      onTap: onNodeTap == null
                          ? null
                          : () => onNodeTap!(node, nodeStatuses[node.id]),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkflowNodeTile extends StatelessWidget {
  const _WorkflowNodeTile({required this.node, this.status, this.onTap});

  final WorkflowNode node;
  final WorkflowNodeStatus? status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final accent = _nodeAccent(theme, node.type, status);
    final icon = _nodeIcon(node.type);
    final isActive =
        status == WorkflowNodeStatus.running ||
        status == WorkflowNodeStatus.waitingForApproval;
    final isCompleted = status == WorkflowNodeStatus.completed;

    final tile = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        borderRadius: BorderRadius.circular(context.borderRadiusMedium),
        border: Border.all(
          color: accent,
          width: isActive
              ? context.borderWidthThick
              : isCompleted
              ? context.borderWidthMedium
              : context.borderWidthMedium,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(
              alpha: isActive
                  ? 0.7
                  : isCompleted
                  ? 0.45
                  : 0.15,
            ),
            blurRadius: isActive
                ? context.glowBlurLarge
                : isCompleted
                ? context.glowBlurMedium
                : context.glowBlurSmall,
            spreadRadius: isActive
                ? context.glowSpreadMedium
                : isCompleted
                ? context.glowSpreadSmall
                : 0,
            offset: context.shadowOffsetSmall,
          ),
        ],
      ),
      child: Padding(
        padding: context.tilePadding,
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: accent.withValues(alpha: isActive ? 0.28 : 0.14),
                borderRadius: BorderRadius.circular(context.borderRadiusMedium),
              ),
              child: SizedBox(
                width: context.workflowNodeIconBox,
                height: context.workflowNodeIconBox,
                child: Icon(icon, size: context.iconMedium, color: accent),
              ),
            ),
            SizedBox(width: context.spaceSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    node.displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.small.copyWith(
                      color: theme.colorScheme.cardForeground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _statusLabel(node.type, status),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.muted.copyWith(
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            if (status == WorkflowNodeStatus.running)
              SizedBox(
                width: context.loadingIndicatorSmall,
                height: context.loadingIndicatorSmall,
                child: CircularProgressIndicator(
                  strokeWidth: context.loadingStrokeWidth,
                ),
              ),
            if (isCompleted)
              Icon(LucideIcons.check, size: context.iconMedium, color: accent),
            if (status == WorkflowNodeStatus.failed)
              Icon(
                LucideIcons.x,
                size: context.loadingIndicatorSmall,
                color: theme.colorScheme.destructive,
              ),
          ],
        ),
      ),
    );

    Widget interactive = tile;
    if (onTap != null) {
      interactive = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: tile,
      );
    }

    if (!isActive) return interactive;

    return interactive
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .boxShadow(
          begin: BoxShadow(
            color: accent.withValues(alpha: 0.55),
            blurRadius: context.glowBlurMedium,
            spreadRadius: context.glowSpreadSmall,
          ),
          end: BoxShadow(
            color: accent.withValues(alpha: 0.95),
            blurRadius: context.glowBlurLarge,
            spreadRadius: context.glowSpreadLarge,
          ),
          duration: 650.ms,
        );
  }

  static String _statusLabel(String type, WorkflowNodeStatus? status) {
    if (status == null) return humanizePresetToken(type);
    return switch (status) {
      WorkflowNodeStatus.running => 'Running',
      WorkflowNodeStatus.waitingForApproval => 'Waiting for approval',
      WorkflowNodeStatus.completed => 'Completed',
      WorkflowNodeStatus.failed => 'Failed',
      WorkflowNodeStatus.skipped => 'Skipped',
      WorkflowNodeStatus.idle => humanizePresetToken(type),
      WorkflowNodeStatus.unknown => humanizePresetToken(type),
    };
  }

  static Color _nodeAccent(
    ShadThemeData theme,
    String type,
    WorkflowNodeStatus? status,
  ) {
    if (status == WorkflowNodeStatus.failed) {
      return theme.colorScheme.destructive;
    }
    if (status == WorkflowNodeStatus.completed) {
      return theme.colorScheme.primary;
    }
    if (status == WorkflowNodeStatus.waitingForApproval) {
      return theme.colorScheme.accent;
    }
    switch (type) {
      case 'HumanApproval':
        return theme.colorScheme.accent;
      case 'Integration':
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.primary;
    }
  }

  static IconData _nodeIcon(String type) {
    switch (type) {
      case 'HumanApproval':
        return LucideIcons.userCheck;
      case 'Integration':
        return LucideIcons.plug;
      default:
        return LucideIcons.workflow;
    }
  }
}

class _WorkflowGridPainter extends CustomPainter {
  _WorkflowGridPainter({required this.color, required this.spacing});

  final Color color;
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WorkflowGridPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.spacing != spacing;
  }
}

class _WorkflowEdgePainter extends CustomPainter {
  _WorkflowEdgePainter({
    required this.connections,
    required this.nodeRects,
    required this.color,
    required this.portRadius,
    required this.vertical,
    required this.strokeWidth,
  });

  final List<WorkflowConnection> connections;
  final Map<String, Rect> nodeRects;
  final Color color;
  final double portRadius;
  final bool vertical;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final portPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final edge in connections) {
      final source = nodeRects[edge.sourceNodeId];
      final target = nodeRects[edge.targetNodeId];
      if (source == null || target == null) continue;

      final Offset start;
      final Offset end;
      if (vertical) {
        start = Offset(source.center.dx, source.bottom);
        end = Offset(target.center.dx, target.top);
      } else {
        start = Offset(source.right, source.center.dy);
        end = Offset(target.left, target.center.dy);
      }

      final path = Path()..moveTo(start.dx, start.dy);
      if (vertical) {
        final delta = (end.dy - start.dy) * 0.45;
        path.cubicTo(
          start.dx,
          start.dy + delta,
          end.dx,
          end.dy - delta,
          end.dx,
          end.dy,
        );
      } else {
        final delta = (end.dx - start.dx) * 0.45;
        path.cubicTo(
          start.dx + delta,
          start.dy,
          end.dx - delta,
          end.dy,
          end.dx,
          end.dy,
        );
      }

      canvas.drawPath(path, linePaint);
      canvas.drawCircle(start, portRadius, portPaint);
      canvas.drawCircle(end, portRadius, portPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WorkflowEdgePainter oldDelegate) {
    return oldDelegate.connections != connections ||
        oldDelegate.nodeRects != nodeRects ||
        oldDelegate.color != color ||
        oldDelegate.vertical != vertical ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
