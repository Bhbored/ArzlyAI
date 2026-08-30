import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/domain/mappers/report/arzly_report_mapper.dart';

void main() {
  test('ReportMapper_WhenVersionTwo_ParsesImageAndActionFields', () {
    const mapper = ArzlyReportMapper();
    final report = mapper.fromMap({
      'schema': 'arzly.report',
      'version': 2,
      'kind': 'purchaseDecision',
      'title': 'Laptop decision',
      'summary': 'Summary',
      'generatedAtUtc': '2026-08-29T00:00:00Z',
      'blocks': [
        {
          'type': 'recommendation',
          'title': 'Best match',
          'data': {
            'text': '',
            'items': [
              {
                'label': 'Winner',
                'value': 'Model X',
                'detail': 'Best overall',
                'url': 'https://example.com/product',
                'imageUrl': 'https://example.com/product.jpg',
                'actionLabel': 'Check availability',
              },
            ],
            'metrics': [],
          },
        },
      ],
      'sources': [],
    });
    expect(report?.version, 2);
    final item = report!.blocks.single.data.items.single;
    expect(item.imageUrl, 'https://example.com/product.jpg');
    expect(item.actionLabel, 'Check availability');
  });
}
