import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_report_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

NavigationRequest _request(String url, {required bool isMainFrame}) {
  return NavigationRequest(url: url, isMainFrame: isMainFrame);
}

void main() {
  test('ReportWebView_WhenSubframeNavigationRequested_AllowsNavigation', () {
    expect(
      reportNavigationDecision(
        _request('https://cdn.example.com/product.jpg', isMainFrame: false),
      ),
      NavigationDecision.navigate,
    );
  });

  test('ReportWebView_WhenMainFrameImageRequested_AllowsNavigation', () {
    expect(looksLikeImageUrl('https://cdn.example.com/product.jpg'), isTrue);
    expect(
      reportNavigationDecision(
        _request('https://cdn.example.com/product.jpg', isMainFrame: true),
      ),
      NavigationDecision.navigate,
    );
    expect(
      shouldOpenReportLinkExternally('https://cdn.example.com/product.jpg'),
      isFalse,
    );
  });

  test('ReportWebView_WhenHttpsStoreLinkTapped_OpensExternalBrowser', () {
    expect(
      shouldOpenReportLinkExternally('https://example.com/product'),
      isTrue,
    );
    expect(
      reportNavigationDecision(
        _request('https://example.com/product', isMainFrame: true),
      ),
      NavigationDecision.prevent,
    );
  });

  test('ReportWebView_WhenCdnPathWithoutExtension_AllowsNavigation', () {
    expect(
      looksLikeImageUrl('https://cdn.shopify.com/s/files/1/0001/0002/products/laptop'),
      isTrue,
    );
    expect(
      reportNavigationDecision(
        _request(
          'https://cdn.shopify.com/s/files/1/0001/0002/products/laptop',
          isMainFrame: true,
        ),
      ),
      NavigationDecision.navigate,
    );
  });

  test('ReportWebView_WhenReportBaseUrlRequested_AllowsNavigation', () {
    expect(
      reportNavigationDecision(
        _request('https://report.arzly.local/', isMainFrame: true),
      ),
      NavigationDecision.navigate,
    );
  });

  test('ReportWebView_WhenNonHttpsNavigationRequested_BlocksNavigation', () {
    expect(
      shouldOpenReportLinkExternally('http://example.com/product'),
      isFalse,
    );
    expect(
      reportNavigationDecision(
        _request('http://example.com/product', isMainFrame: true),
      ),
      NavigationDecision.prevent,
    );
    expect(shouldOpenReportLinkExternally('javascript:alert(1)'), isFalse);
  });
}
