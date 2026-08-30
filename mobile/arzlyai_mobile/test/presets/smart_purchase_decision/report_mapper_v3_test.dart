import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/domain/mappers/report/arzly_report_mapper.dart';

void main() {
  test('ReportMapper_WhenVersionThree_ParsesImagesAndStoreActions', () {
    const mapper = ArzlyReportMapper();
    final report = mapper.fromMap({
      'schema': 'arzly.report',
      'version': 3,
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
                'actions': [
                  {
                    'storeName': 'TechStore',
                    'label': 'View offer',
                    'availability': 'In stock',
                    'url': 'https://example.com/offer',
                  },
                  {
                    'storeName': 'MegaMart',
                    'label': 'Compare',
                    'url': 'https://example.com/compare',
                  },
                ],
              },
            ],
            'metrics': [],
          },
        },
      ],
      'sources': [],
    });
    expect(report?.version, 3);
    final item = report!.blocks.single.data.items.single;
    expect(item.imageUrl, 'https://example.com/product.jpg');
    expect(item.actions, hasLength(2));
    expect(item.actions.first.storeName, 'TechStore');
    expect(item.actions.first.label, 'View offer');
    expect(item.actions.first.availability, 'In stock');
    expect(item.actions.first.url, 'https://example.com/offer');
    expect(item.actions.last.availability, isNull);
  });
}
