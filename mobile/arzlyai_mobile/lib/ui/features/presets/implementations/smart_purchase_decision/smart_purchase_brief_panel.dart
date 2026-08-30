import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/domain/mappers/report/arzly_report_mapper.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/smart_purchase_report_panel.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/smart_purchase_review_content.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';

class SmartPurchaseBriefPanel extends StatelessWidget {
  const SmartPurchaseBriefPanel({required this.content, super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    const mapper = ArzlyReportMapper();
    final report = mapper.fromJsonString(content);
    if (report != null) {
      final theme = ShadTheme.of(context);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (report.title.isNotEmpty)
            Text(report.title, style: theme.textTheme.h4),
          if (report.title.isNotEmpty) SizedBox(height: context.spaceMedium),
          SmartPurchaseReportPanel(report: report),
        ],
      );
    }

    final theme = ShadTheme.of(context);
    if (SmartPurchaseReviewContent.looksLikePurchaseDecisionReport(content)) {
      return AppCard.standard(
        child: Text(
          'Could not render this recommendation. Try a different search.',
          style: theme.textTheme.p,
        ),
      );
    }

    try {
      final json = jsonDecode(content) as Map<String, dynamic>;
      if (json['kind'] == 'purchaseDecision') {
        return AppCard.standard(
          child: Text(
            'Could not render this recommendation. Try a different search.',
            style: theme.textTheme.p,
          ),
        );
      }
      final summary = json['summary'] as String? ?? '';
      final checklist = (json['checklist'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .where((item) => item.trim().isNotEmpty)
          .toList(growable: false);
      final countryCode = json['countryCode'] as String? ?? '';
      final currencyCode = json['currencyCode'] as String? ?? '';
      final budget = json['budget'] as String?;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Does this look right?', style: theme.textTheme.h4),
          if (summary.isNotEmpty) ...[
            SizedBox(height: context.spaceSmall),
            Text(summary, style: theme.textTheme.p),
          ],
          if (checklist.isNotEmpty) ...[
            SizedBox(height: context.spaceMedium),
            ...checklist.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: context.spaceSmall / 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      LucideIcons.check,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: context.spaceSmall),
                    Expanded(child: Text(item, style: theme.textTheme.p)),
                  ],
                ),
              ),
            ),
          ],
          if (countryCode.isNotEmpty || currencyCode.isNotEmpty) ...[
            SizedBox(height: context.spaceMedium),
            AppCard.standard(
              child: Text(
                [
                  if (countryCode.isNotEmpty) 'Shopping in $countryCode',
                  if (currencyCode.isNotEmpty) 'Prices in $currencyCode',
                  if (budget != null && budget.trim().isNotEmpty)
                    'Budget up to $budget $currencyCode',
                ].join(' · '),
                style: theme.textTheme.muted,
              ),
            ),
          ],
        ],
      );
    } catch (_) {
      if (SmartPurchaseReviewContent.looksLikePurchaseDecisionReport(content) ||
          SmartPurchaseReviewContent.looksLikeStructuredJson(content)) {
        return AppCard.standard(
          child: Text(
            'Could not render this recommendation. Try a different search.',
            style: theme.textTheme.p,
          ),
        );
      }
      return AppCard.standard(
        child: Text(content, style: theme.textTheme.p),
      );
    }
  }
}
