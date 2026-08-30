import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_report_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  test('ReportWebView_WhenHttpsLinkTapped_OpensExternalBrowser', () {
    expect(shouldOpenReportLinkExternally('https://example.com/product'), isTrue);
    expect(reportNavigationDecision('https://example.com/product'),
        NavigationDecision.prevent);
  });

  test('ReportWebView_WhenNonHttpsNavigationRequested_BlocksNavigation', () {
    expect(shouldOpenReportLinkExternally('http://example.com/product'), isFalse);
    expect(reportNavigationDecision('http://example.com/product'),
        NavigationDecision.prevent);
    expect(shouldOpenReportLinkExternally('javascript:alert(1)'), isFalse);
  });
}
