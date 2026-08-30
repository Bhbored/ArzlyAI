import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:arzlyai_mobile/domain/entities/report/arzly_report.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';

class ReportExportService {
  const ReportExportService();

  Future<void> shareRenderedHtml(
    RenderedWorkflowResult rendered, {
    String? subject,
  }) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/decision-report.html');
    await file.writeAsString(rendered.content, flush: true);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: subject ?? 'Decision report',
      ),
    );
  }

  Future<void> shareHtml(ArzlyReport report) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/decision-report.html');
    await file.writeAsString(buildHtml(report), flush: true);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: report.title,
      ),
    );
  }

  @visibleForTesting
  String buildHtml(ArzlyReport report) => _html(report);

  Future<void> sharePdf(ArzlyReport report) async {
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        build: (_) => [
          pw.Header(level: 0, text: report.title),
          pw.Paragraph(text: report.summary),
          ...report.blocks.map(
            (block) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(level: 1, text: block.title),
                if (block.data.text.isNotEmpty)
                  pw.Paragraph(text: block.data.text),
                ...block.data.items.map(
                  (item) => pw.Paragraph(
                    text: _escape(
                      '${item.label}${item.value.isEmpty ? '' : ': ${item.value}'}\n${item.detail}',
                    ),
                  ),
                ),
                ...block.data.metrics.map(
                  (metric) => pw.Paragraph(
                    text: _escape(
                      '${metric.label}: ${metric.value.toStringAsFixed(1)} / ${metric.maximum.toStringAsFixed(0)}',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/decision-report.pdf');
    await file.writeAsBytes(await document.save(), flush: true);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: report.title,
      ),
    );
  }

  String _html(ArzlyReport report) {
    final blocks = report.blocks.map(_blockHtml).join();
    final sources = report.sources
        .map(
          (source) =>
              '<li>${_link(source.title, source.url)} · ${_escape(source.publisher)} · ${_escape(source.retrievedAtUtc)}</li>',
        )
        .join();
    return '<!doctype html><html><head><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1">'
        '<title>${_escape(report.title)}</title>'
        '<style>body{font:16px system-ui;max-width:900px;margin:auto;padding:32px;color:#18201b}'
        'section{border:1px solid #d8dfda;border-radius:12px;padding:16px;margin:16px 0}'
        'ul{padding-left:20px}</style></head><body>'
        '<h1>${_escape(report.title)}</h1>'
        '<p>${_escape(report.summary)}</p>$blocks'
        '${sources.isEmpty ? '' : '<h2>Sources</h2><ul>$sources</ul>'}'
        '</body></html>';
  }

  String _blockHtml(ArzlyReportBlock block) {
    final items = block.data.items
        .map(
          (item) =>
              '<li>${_link('${item.label}${item.value.isEmpty ? '' : ': ${item.value}'}', item.url ?? '')}'
              '${item.detail.isEmpty ? '' : '<br>${_escape(item.detail)}'}</li>',
        )
        .join();
    final metrics = block.data.metrics
        .map(
          (metric) =>
              '<li>${_escape('${metric.label}: ${metric.value.toStringAsFixed(1)} / ${metric.maximum.toStringAsFixed(0)}')}</li>',
        )
        .join();
    return '<section><h2>${_escape(block.title)}</h2>'
        '${block.data.text.isEmpty ? '' : '<p>${_escape(block.data.text)}</p>'}'
        '${items.isEmpty ? '' : '<ul>$items</ul>'}'
        '${metrics.isEmpty ? '' : '<ul>$metrics</ul>'}'
        '</section>';
  }

  String _link(String label, String url) {
    final uri = Uri.tryParse(url);
    if (uri != null && uri.scheme == 'https') {
      return '<a href="${_escape(url)}">${_escape(label)}</a>';
    }
    return _escape(label);
  }

  String _escape(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
}
