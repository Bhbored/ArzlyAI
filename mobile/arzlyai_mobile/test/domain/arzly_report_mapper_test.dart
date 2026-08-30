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

  test('mapper accepts purchaseDecision without schema envelope', () {
    final report = mapper.fromJsonString(
      '{"kind":"purchaseDecision","title":"Top Laptop Picks","summary":"Options","blocks":[{"type":"recommendation","title":"Winner","data":{"text":"Best","items":[]}}],"sources":[]}',
    );

    expect(report, isNotNull);
    expect(report!.schema, 'arzly.report');
    expect(report.version, 4);
    expect(report.title, 'Top Laptop Picks');
    expect(report.blocks.single.type, 'recommendation');
  });

  test('mapper accepts blocks without type field', () {
    final report = mapper.fromJsonString(
      r'{"kind":"purchaseDecision","title":"Top Laptop Picks","blocks":[{"data":{"text":"Intro","items":[{"label":"Lenovo IdeaPad","value":"$799","detail":"Good GPU","actions":[]}]}}],"sources":[]}',
    );

    expect(report, isNotNull);
    expect(report!.blocks.single.type, 'unknown');
    expect(report.blocks.single.data.items.single.label, 'Lenovo IdeaPad');
  });

  test('mapper accepts v4 blocks without kind or schema', () {
    final report = mapper.fromJsonString(
      r'{"version":4,"title":"Laptops in Lebanon","summary":"Options under $800","generatedAtUtc":"2026-08-30T17:40:13Z","blocks":[{"data":{"text":"Pick one","items":[{"label":"Acer Aspire 5","value":"$799","detail":"Dedicated GPU","actions":[]}]}}],"sources":[{"id":"s1","title":"LebTech","url":"https://example.com","publisher":"LebTech","retrievedAtUtc":"2026-08-30T17:40:13Z"}]}',
    );

    expect(report, isNotNull);
    expect(report!.schema, 'arzly.report');
    expect(report.version, 4);
    expect(report.kind, 'purchaseDecision');
    expect(report.blocks.single.data.items.single.label, 'Acer Aspire 5');
  });

  test('mapper accepts v4 sources without blocks', () {
    final report = mapper.fromJsonString(
      r'{"version":4,"title":"Laptops in Lebanon","summary":"Options under $800","generatedAtUtc":"2026-08-30T17:40:13Z","sources":[{"id":"s1","title":"Acer Aspire 5 A515-46-R74Z","url":"https://lebtechlb.com/acer","publisher":"LebTech","retrievedAtUtc":"2026-08-30T17:40:13Z"},{"id":"s2","title":"Lenovo IdeaPad 3 14ITL6","url":"https://lebtechlb.com/lenovo","publisher":"LebTech","retrievedAtUtc":"2026-08-30T17:40:13Z"}]}',
    );

    expect(report, isNotNull);
    expect(report!.blocks.single.type, 'recommendation');
    expect(report.blocks.single.data.items, hasLength(2));
    expect(report.blocks.single.data.items.first.label, 'Acer Aspire 5 A515-46-R74Z');
  });

  test('mapper accepts string version four', () {
    final report = mapper.fromJsonString(
      r'{"version":"4","title":"Laptops","summary":"Pick one","blocks":[{"data":{"text":"Intro","items":[]}}],"sources":[]}',
    );

    expect(report, isNotNull);
    expect(report!.version, 4);
  });
}
