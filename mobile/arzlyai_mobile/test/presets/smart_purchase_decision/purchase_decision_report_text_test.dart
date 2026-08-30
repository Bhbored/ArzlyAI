import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/purchase_decision_report_text.dart';

void main() {
  test('PurchaseDecisionReportText detects embedded criterion json', () {
    const text =
        'Below are the original per-candidate criterion assessments (preserved verbatim).\n'
        '{"price":{"score":0,"passes":false,"mandatory":true,"explanation":"No price","sourceIds":[]}}';
    expect(PurchaseDecisionReportText.looksLikeJsonDump(text), isTrue);
    final parts = PurchaseDecisionReportText.splitProseAndJson(text);
    expect(parts.prose, contains('Below are the original'));
    expect(parts.json, startsWith('{'));
    expect(PurchaseDecisionReportText.extractJson(text), isNotNull);
  });
}
