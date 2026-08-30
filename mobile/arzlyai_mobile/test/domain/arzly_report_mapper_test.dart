import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/domain/mappers/report/arzly_report_mapper.dart';

void main() {
  const mapper = ArzlyReportMapper();

  test('ReportRenderer_WhenUnknownBlock_RendersSafeFallback', () {
    final report = mapper.fromMap({
      'schema': 'arzly.report',
      'version': 1,
      'kind': 'purchaseDecision',
      'title': 'Laptop decision',
      'summary': 'Summary',
      'generatedAtUtc': '2026-08-29T00:00:00Z',
      'blocks': [
        {
          'type': 'futureBlock',
          'title': 'Future section',
          'data': {},
        },
      ],
      'sources': [],
    });

    expect(report, isNotNull);
    expect(report!.blocks.single.type, 'futureBlock');
    expect(report.blocks.single.data.text, isEmpty);
    expect(report.blocks.single.data.items, isEmpty);
    expect(report.blocks.single.data.metrics, isEmpty);
  });

  test('mapper prefers resultDocument over finalResponse fallback', () {
    final fromDocument = mapper.fromMap({
      'schema': 'arzly.report',
      'version': 1,
      'kind': 'purchaseDecision',
      'title': 'From document',
      'summary': 'A',
      'generatedAtUtc': '2026-08-29T00:00:00Z',
      'blocks': [],
      'sources': [],
    });
    expect(fromDocument?.title, 'From document');

    final fromString = mapper.fromJsonString(
      '{"schema":"arzly.report","version":1,"kind":"purchaseDecision","title":"From string","summary":"B","generatedAtUtc":"2026-08-29T00:00:00Z","blocks":[],"sources":[]}',
    );
    expect(fromString?.title, 'From string');
  });

  test('mapper ignores non-json finalResponse fallback', () {
    expect(mapper.fromJsonString('urn:li:share:123'), isNull);
  });

  test('mapper extracts arzly.report from prose wrapped json', () {
    final report = mapper.fromJsonString(
      'Intro text {"schema":"arzly.report","version":1,"kind":"purchaseDecision","title":"Laptop","summary":"Pick A","generatedAtUtc":"2026-08-29T00:00:00Z","blocks":[],"sources":[]}',
    );
    expect(report?.title, 'Laptop');
  });
}
