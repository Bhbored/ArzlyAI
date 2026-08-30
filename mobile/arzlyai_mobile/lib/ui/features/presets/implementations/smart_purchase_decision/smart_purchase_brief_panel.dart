import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';

class SmartPurchaseBriefPanel extends StatelessWidget {
  const SmartPurchaseBriefPanel({required this.content, super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    try {
      final json = jsonDecode(content) as Map<String, dynamic>;
      final summary = json['summary'] as String? ?? '';
      final category = json['category'] as String? ?? '';
      final criteria = (json['criteria'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (category.isNotEmpty)
            Text(category, style: theme.textTheme.h4),
          if (summary.isNotEmpty) ...[
            SizedBox(height: context.spaceSmall),
            Text(summary, style: theme.textTheme.p),
          ],
          if (criteria.isNotEmpty) ...[
            SizedBox(height: context.spaceMedium),
            Text('Criteria', style: theme.textTheme.small),
            SizedBox(height: context.spaceSmall / 2),
            ...criteria.map((item) {
              final label = item['label'] as String? ?? '';
              final weight = item['weight'] as num? ?? 0;
              final mandatory = item['mandatory'] as bool? ?? false;
              return Padding(
                padding: EdgeInsets.only(bottom: context.spaceSmall),
                child: AppCard.standard(
                  title: label,
                  child: Text(
                    'Weight ${weight.toString()}${mandatory ? ' · mandatory' : ''}',
                    style: theme.textTheme.p,
                  ),
                ),
              );
            }),
          ],
        ],
      );
    } catch (_) {
      return AppCard.standard(
        child: SelectableText(content, style: theme.textTheme.p),
      );
    }
  }
}
