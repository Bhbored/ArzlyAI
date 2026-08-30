import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/domain/entities/report/arzly_report.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/purchase_decision_report_text.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:url_launcher/url_launcher.dart';

class SmartPurchaseReportPanel extends StatelessWidget {
  const SmartPurchaseReportPanel({required this.report, super.key});

  final ArzlyReport report;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final summaryParts = PurchaseDecisionReportText.splitProseAndJson(
      report.summary,
    );
    final summaryStructured = PurchaseDecisionReportText.structuredBody(
      context,
      report.summary,
    );
    final showSummaryProse =
        summaryParts.prose.isNotEmpty &&
        !PurchaseDecisionReportText.looksLikeJsonDump(summaryParts.prose);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showSummaryProse)
          Text(
            summaryParts.prose,
            style: theme.textTheme.p.copyWith(
              color: theme.colorScheme.foreground,
            ),
          ),
        if (summaryStructured != null) ...[
          if (showSummaryProse) SizedBox(height: context.spaceMedium),
          summaryStructured,
        ],
        if (report.generatedAtUtc.isNotEmpty) ...[
          SizedBox(height: context.spaceSmall / 2),
          Text(
            report.generatedAtUtc,
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
        ],
        if (report.blocks.isNotEmpty) ...[
          SizedBox(height: context.spaceMedium),
          ...report.blocks.map(
            (block) => Padding(
              padding: EdgeInsets.only(bottom: context.spaceSmall),
              child: _ReportBlockCard(block: block),
            ),
          ),
        ],
        if (report.sources.isNotEmpty) ...[
          SizedBox(height: context.spaceSmall),
          AppCard.standard(
            title: 'Sources',
            child: Column(
              children: report.sources
                  .map((source) => _SourceRow(source: source))
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }
}

class _ReportBlockCard extends StatelessWidget {
  const _ReportBlockCard({required this.block});

  final ArzlyReportBlock block;

  @override
  Widget build(BuildContext context) {
    return AppCard.standard(
      title: block.title,
      child: _BlockBody(block: block),
    );
  }
}

class _BlockBody extends StatelessWidget {
  const _BlockBody({required this.block});

  final ArzlyReportBlock block;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final data = block.data;
    final structured = PurchaseDecisionReportText.structuredBody(
      context,
      data.text,
    );
    final textParts = PurchaseDecisionReportText.splitProseAndJson(data.text);
    final showText = textParts.prose.isNotEmpty && structured == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showText)
          Text(textParts.prose, style: theme.textTheme.p),
        if (structured != null) ...[
          if (showText) SizedBox(height: context.spaceSmall),
          structured,
        ],
        ...data.metrics.map(
          (metric) => Padding(
            padding: EdgeInsets.only(top: context.spaceSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${metric.label}: ${metric.value.toStringAsFixed(1)}',
                  style: theme.textTheme.small,
                ),
                SizedBox(height: context.spaceSmall / 2),
                LinearProgressIndicator(
                  value: metric.maximum <= 0
                      ? 0
                      : (metric.value / metric.maximum).clamp(0, 1),
                  color: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.border,
                ),
              ],
            ),
          ),
        ),
        ...data.items.map(
          (item) => _ItemRow(item: item, blockType: block.type),
        ),
        if (data.text.isEmpty &&
            data.items.isEmpty &&
            data.metrics.isEmpty &&
            structured == null)
          Text(
            'No details available.',
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item, required this.blockType});

  final ArzlyReportItem item;
  final String blockType;

  bool _isHttps(String? value) {
    final uri = Uri.tryParse(value ?? '');
    return uri != null && uri.scheme == 'https';
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final uri = Uri.tryParse(item.url ?? '');
    final safe = uri != null && uri.scheme == 'https';
    final label = item.value.isEmpty
        ? item.label
        : '${item.label}: ${item.value}';
    final imageUri = _isHttps(item.imageUrl) ? Uri.parse(item.imageUrl!) : null;
    final actions = item.actions
        .where((action) => _isHttps(action.url))
        .take(3)
        .toList(growable: false);
    return Padding(
      padding: EdgeInsets.only(top: context.spaceSmall),
      child: InkWell(
        onTap: safe
            ? () => launchUrl(uri, mode: LaunchMode.externalApplication)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUri != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(context.borderRadiusMedium),
                child: Image.network(
                  imageUri.toString(),
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
              SizedBox(height: context.spaceSmall),
            ],
            Text(
              label,
              style: theme.textTheme.p.copyWith(
                color: safe
                    ? theme.colorScheme.primary
                    : theme.colorScheme.foreground,
              ),
            ),
            if (item.detail.isNotEmpty)
              Text(
                item.detail,
                style: theme.textTheme.muted.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            if (actions.isNotEmpty) ...[
              SizedBox(height: context.spaceSmall / 2),
              Wrap(
                spacing: context.spaceSmall / 2,
                runSpacing: context.spaceSmall / 2,
                children: actions
                    .map(
                      (action) => _StoreActionChip(action: action),
                    )
                    .toList(),
              ),
            ] else if (item.actionLabel != null &&
                item.actionLabel!.isNotEmpty &&
                safe) ...[
              SizedBox(height: context.spaceSmall / 2),
              Text(
                item.actionLabel!,
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StoreActionChip extends StatelessWidget {
  const _StoreActionChip({required this.action});

  final ArzlyReportItemAction action;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final uri = Uri.parse(action.url);
    final label = action.availability == null || action.availability!.isEmpty
        ? '${action.storeName} · ${action.label}'
        : '${action.storeName} · ${action.label} · ${action.availability}';
    return InkWell(
      onTap: () => launchUrl(uri, mode: LaunchMode.externalApplication),
      child: Text(
        label,
        style: theme.textTheme.small.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.source});

  final ArzlyReportSource source;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final uri = Uri.tryParse(source.url);
    final safe = uri != null && uri.scheme == 'https';
    return Padding(
      padding: EdgeInsets.only(bottom: context.spaceSmall / 2),
      child: InkWell(
        onTap: safe
            ? () => launchUrl(uri, mode: LaunchMode.externalApplication)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              source.title,
              style: theme.textTheme.small.copyWith(
                color: safe
                    ? theme.colorScheme.primary
                    : theme.colorScheme.foreground,
              ),
            ),
            if (source.publisher.isNotEmpty)
              Text(
                '${source.publisher} · ${source.retrievedAtUtc}',
                style: theme.textTheme.muted.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
