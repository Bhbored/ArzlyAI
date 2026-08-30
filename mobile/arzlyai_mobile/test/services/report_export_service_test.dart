import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/data/services/reports/report_export_service.dart';
import 'package:arzlyai_mobile/domain/entities/report/arzly_report.dart';

void main() {
  const service = ReportExportService();

  test('ReportExport_WhenTextContainsMarkup_EscapesHtml', () {
    const report = ArzlyReport(
      schema: 'arzly.report',
      version: 1,
      kind: 'purchaseDecision',
      title: 'Best <laptop> & "choice"',
      summary: '<script>alert(1)</script>',
      generatedAtUtc: '2026-08-29T00:00:00Z',
      blocks: [
        ArzlyReportBlock(
          type: 'recommendation',
          title: 'Winner',
          data: ArzlyReportBlockData(
            text: 'Use <strong>care</strong> & verify',
          ),
        ),
      ],
      sources: [],
    );

    final html = service.buildHtml(report);
    expect(html, contains('&lt;laptop&gt;'));
    expect(html, contains('&amp;'));
    expect(html, contains('&lt;script&gt;'));
    expect(html, contains('&lt;strong&gt;'));
    expect(html, isNot(contains('<script>')));
  });
}
