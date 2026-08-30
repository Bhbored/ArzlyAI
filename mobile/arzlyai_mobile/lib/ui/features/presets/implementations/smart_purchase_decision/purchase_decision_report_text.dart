import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';

class PurchaseDecisionReportText {
  const PurchaseDecisionReportText._();

  static bool looksLikeJsonDump(String text) {
    final trimmed = text.trim();
    if (trimmed.startsWith('{') || trimmed.startsWith('[')) return true;
    if (trimmed.contains('"passes"') && trimmed.contains('"score"')) return true;
    return trimmed.contains('{') && trimmed.contains('"explanation"');
  }

  static ({String prose, String? json}) splitProseAndJson(String text) {
    final trimmed = text.trim();
    final start = trimmed.indexOf('{');
    if (start <= 0) return (prose: trimmed, json: null);
    return (
      prose: trimmed.substring(0, start).trim(),
      json: trimmed.substring(start),
    );
  }

  static String? extractJson(String text) {
    final trimmed = text.trim();
    final fenced = RegExp(
      r'```(?:json)?\s*([\s\S]*?)```',
      multiLine: true,
    ).firstMatch(trimmed);
    if (fenced != null) {
      final body = fenced.group(1)?.trim();
      if (body != null && body.isNotEmpty) return body;
    }
    if (trimmed.startsWith('{') || trimmed.startsWith('[')) return trimmed;
    final start = trimmed.indexOf('{');
    final end = trimmed.lastIndexOf('}');
    if (start >= 0 && end > start) return trimmed.substring(start, end + 1);
    return null;
  }

  static Widget? structuredBody(BuildContext context, String text) {
    final jsonText = extractJson(text);
    if (jsonText == null) return null;
    try {
      final decoded = jsonDecode(jsonText);
      return _StructuredJsonBody(data: decoded);
    } catch (_) {
      return null;
    }
  }
}

class _StructuredJsonBody extends StatelessWidget {
  const _StructuredJsonBody({required this.data});

  final Object? data;

  @override
  Widget build(BuildContext context) {
    if (data is Map<String, dynamic>) {
      final map = data as Map<String, dynamic>;
      if (map.containsKey('candidates')) {
        return _CandidatesSection(map: map);
      }
      if (_isCriterionMap(map)) {
        return _CriterionMapSection(entries: map);
      }
    }
    if (data is List<dynamic>) {
      final items = data as List<dynamic>;
      return _CriterionListSection(items: items);
    }
    return const SizedBox.shrink();
  }

  bool _isCriterionMap(Map<String, dynamic> map) {
    if (map.isEmpty) return false;
    for (final value in map.values) {
      if (value is! Map) return false;
      if (!value.containsKey('score')) return false;
    }
    return true;
  }
}

class _CandidatesSection extends StatelessWidget {
  const _CandidatesSection({required this.map});

  final Map<String, dynamic> map;

  @override
  Widget build(BuildContext context) {
    final candidates = map['candidates'];
    if (candidates is! List<dynamic>) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final candidate in candidates)
          if (candidate is Map<String, dynamic>)
            Padding(
              padding: EdgeInsets.only(bottom: context.spaceSmall),
              child: _CandidateCard(candidate: candidate),
            ),
      ],
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({required this.candidate});

  final Map<String, dynamic> candidate;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final name = candidate['name'] as String? ?? 'Candidate';
    final scores = candidate['criterionScores'];
    return AppCard.standard(
      title: name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (candidate['price'] != null)
            Text('Price: ${candidate['price']}', style: theme.textTheme.small),
          if (scores is List<dynamic>) ...[
            SizedBox(height: context.spaceSmall),
            ...scores.whereType<Map<String, dynamic>>().map(
              (score) => _CriterionScoreRow(
                label: score['key'] as String? ?? '',
                score: score,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CriterionMapSection extends StatelessWidget {
  const _CriterionMapSection({required this.entries});

  final Map<String, dynamic> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in entries.entries)
          if (entry.value is Map<String, dynamic>)
            Padding(
              padding: EdgeInsets.only(bottom: context.spaceSmall),
              child: _CriterionScoreRow(
                label: entry.key,
                score: entry.value as Map<String, dynamic>,
              ),
            ),
      ],
    );
  }
}

class _CriterionListSection extends StatelessWidget {
  const _CriterionListSection({required this.items});

  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in items)
          if (item is Map<String, dynamic>)
            Padding(
              padding: EdgeInsets.only(bottom: context.spaceSmall),
              child: _CriterionScoreRow(
                label: item['key'] as String? ?? '',
                score: item,
              ),
            ),
      ],
    );
  }
}

class _CriterionScoreRow extends StatelessWidget {
  const _CriterionScoreRow({required this.label, required this.score});

  final String label;
  final Map<String, dynamic> score;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final value = (score['score'] as num?)?.toDouble() ?? 0;
    final passes = score['passes'] as bool? ?? false;
    final mandatory = score['mandatory'] as bool? ?? false;
    final explanation = score['explanation'] as String? ?? '';
    final statusColor = passes ? theme.colorScheme.primary : theme.colorScheme.destructive;
    final title = label.isEmpty ? 'Criterion' : label;
    return AppCard.standard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${value.toStringAsFixed(0)} / 100 · ${passes ? 'Pass' : 'Fail'}${mandatory ? ' · mandatory' : ''}',
            style: theme.textTheme.small.copyWith(color: statusColor),
          ),
          SizedBox(height: context.spaceSmall / 2),
          LinearProgressIndicator(
            value: (value / 100).clamp(0, 1),
            color: statusColor,
            backgroundColor: theme.colorScheme.border,
          ),
          if (explanation.isNotEmpty) ...[
            SizedBox(height: context.spaceSmall),
            Text(
              explanation,
              style: theme.textTheme.p.copyWith(
                color: theme.colorScheme.foreground,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
