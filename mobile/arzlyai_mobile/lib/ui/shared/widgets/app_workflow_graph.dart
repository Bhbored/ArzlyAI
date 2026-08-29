import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';

class AppWorkflowGraph extends StatelessWidget {
  const AppWorkflowGraph({
    required this.nodes,
    required this.connections,
    super.key,
  });

  final List<WorkflowNode> nodes;
  final List<WorkflowConnection> connections;

  static const double _nodeHeight = 76;
  static const double _verticalGap = 40;
  static const double _portRadius = 5;

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = ShadTheme.of(context);
    final ordered = [...nodes]..sort((a, b) => a.position.compareTo(b.position));
    final horizontalPadding = context.paddingMedium;
    final nodeWidth = context.screenWidth - horizontalPadding * 4;
    final canvasWidth = nodeWidth + horizontalPadding * 2;
    final canvasHeight =
        horizontalPadding * 2 +
        ordered.length * _nodeHeight +
        (ordered.length - 1) * _verticalGap;

    final nodeRects = <String, Rect>{};
    for (var i = 0; i < ordered.length; i++) {
      final x = horizontalPadding;
      final y = horizontalPadding + i * (_nodeHeight + _verticalGap);
      nodeRects[ordered[i].id] = Rect.fromLTWH(x, y, nodeWidth, _nodeHeight);
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
                    portRadius: _portRadius,
                    vertical: true,
                  ),
                ),
                ...ordered.map((node) {
                  final rect = nodeRects[node.id]!;
                  return Positioned(
                    left: rect.left,
                    top: rect.top,
                    width: rect.width,
                    height: rect.height,
                    child: _WorkflowNodeTile(node: node),
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
  const _WorkflowNodeTile({required this.node});

  final WorkflowNode node;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final accent = _nodeAccent(theme, node.type);
    final icon = _nodeIcon(node.type);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        borderRadius: BorderRadius.circular(context.borderRadiusMedium),
        border: Border.all(color: accent, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(context.borderRadiusMedium),
              ),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(icon, size: 20, color: accent),
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
                    humanizePresetToken(node.type),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.muted.copyWith(
                      color: theme.colorScheme.mutedForeground,
                      fontSize: 12,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _nodeAccent(ShadThemeData theme, String type) {
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
  _WorkflowGridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const spacing = 24;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WorkflowGridPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _WorkflowEdgePainter extends CustomPainter {
  _WorkflowEdgePainter({
    required this.connections,
    required this.nodeRects,
    required this.color,
    required this.portRadius,
    required this.vertical,
  });

  final List<WorkflowConnection> connections;
  final Map<String, Rect> nodeRects;
  final Color color;
  final double portRadius;
  final bool vertical;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
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
        oldDelegate.vertical != vertical;
  }
}
