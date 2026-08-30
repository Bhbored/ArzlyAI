import 'dart:convert';

import 'package:arzlyai_mobile/domain/entities/report/arzly_report.dart';

class ArzlyReportMapper {
  const ArzlyReportMapper();

  ArzlyReport? fromMap(Map<String, dynamic>? value) {
    if (value == null || value['schema'] != 'arzly.report') return null;
    return ArzlyReport(
      schema: value['schema'] as String,
      version: value['version'] as int? ?? 1,
      kind: value['kind'] as String? ?? '',
      title: value['title'] as String? ?? '',
      summary: value['summary'] as String? ?? '',
      generatedAtUtc: value['generatedAtUtc'] as String? ?? '',
      blocks: (value['blocks'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(_block)
          .toList(growable: false),
      sources: (value['sources'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(_source)
          .toList(growable: false),
    );
  }

  ArzlyReport? fromJsonString(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    for (final candidate in _jsonCandidates(value.trim())) {
      try {
        final decoded = jsonDecode(candidate);
        if (decoded is Map<String, dynamic>) {
          final report = fromMap(decoded);
          if (report != null) return report;
        }
      } catch (_) {}
    }
    return null;
  }

  Iterable<String> _jsonCandidates(String value) sync* {
    yield value;
    final fenced = RegExp(
      r'```(?:json)?\s*([\s\S]*?)```',
      multiLine: true,
    );
    for (final match in fenced.allMatches(value)) {
      final body = match.group(1)?.trim();
      if (body != null && body.isNotEmpty) yield body;
    }
    final start = value.indexOf('{');
    final end = value.lastIndexOf('}');
    if (start >= 0 && end > start) {
      yield value.substring(start, end + 1);
    }
  }

  Map<String, dynamic> toMap(ArzlyReport report) {
    return {
      'schema': report.schema,
      'version': report.version,
      'kind': report.kind,
      'title': report.title,
      'summary': report.summary,
      'generatedAtUtc': report.generatedAtUtc,
      'blocks': report.blocks.map(_blockToMap).toList(),
      'sources': report.sources.map(_sourceToMap).toList(),
    };
  }

  String toJsonString(ArzlyReport report) => jsonEncode(toMap(report));

  ArzlyReportBlock _block(Map<String, dynamic> json) {
    return ArzlyReportBlock(
      type: json['type'] as String? ?? 'unknown',
      title: json['title'] as String? ?? '',
      data: _blockData(_readMap(json['data'])),
    );
  }

  Map<String, dynamic> _readMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map(
        (key, item) => MapEntry(key.toString(), item),
      );
    }
    return const {};
  }

  ArzlyReportBlockData _blockData(Map<String, dynamic> json) {
    return ArzlyReportBlockData(
      text: json['text'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(_item)
          .toList(growable: false),
      metrics: (json['metrics'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(_metric)
          .toList(growable: false),
    );
  }

  ArzlyReportItem _item(Map<String, dynamic> json) {
    return ArzlyReportItem(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
      detail: json['detail'] as String? ?? '',
      url: json['url'] as String?,
      imageUrl: json['imageUrl'] as String?,
      actionLabel: json['actionLabel'] as String?,
      actions: (json['actions'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>()
          .take(3)
          .map(_itemAction)
          .toList(growable: false),
    );
  }

  ArzlyReportItemAction _itemAction(Map<String, dynamic> json) {
    return ArzlyReportItemAction(
      storeName: json['storeName'] as String? ?? '',
      label: json['label'] as String? ?? '',
      availability: json['availability'] as String?,
      url: json['url'] as String? ?? '',
    );
  }

  ArzlyReportMetric _metric(Map<String, dynamic> json) {
    return ArzlyReportMetric(
      label: json['label'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0,
      maximum: (json['maximum'] as num?)?.toDouble() ?? 100,
    );
  }

  ArzlyReportSource _source(Map<String, dynamic> json) {
    return ArzlyReportSource(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
      publisher: json['publisher'] as String? ?? '',
      retrievedAtUtc: json['retrievedAtUtc'] as String? ?? '',
    );
  }

  Map<String, dynamic> _blockToMap(ArzlyReportBlock block) => {
    'type': block.type,
    'title': block.title,
    'data': {
      'text': block.data.text,
      'items': block.data.items.map(_itemToMap).toList(),
      'metrics': block.data.metrics.map(_metricToMap).toList(),
    },
  };

  Map<String, dynamic> _itemToMap(ArzlyReportItem item) => {
    'label': item.label,
    'value': item.value,
    'detail': item.detail,
    'url': item.url,
    'imageUrl': item.imageUrl,
    'actionLabel': item.actionLabel,
    'actions': item.actions.map(_itemActionToMap).toList(),
  };

  Map<String, dynamic> _itemActionToMap(ArzlyReportItemAction action) => {
    'storeName': action.storeName,
    'label': action.label,
    'availability': action.availability,
    'url': action.url,
  };

  Map<String, dynamic> _metricToMap(ArzlyReportMetric metric) => {
    'label': metric.label,
    'value': metric.value,
    'maximum': metric.maximum,
  };

  Map<String, dynamic> _sourceToMap(ArzlyReportSource source) => {
    'id': source.id,
    'title': source.title,
    'url': source.url,
    'publisher': source.publisher,
    'retrievedAtUtc': source.retrievedAtUtc,
  };
}
