import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

const reportWebViewBaseUrl = 'https://report.arzly.local/';

const reportWebViewUserAgent =
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36';

class AppReportWebView extends StatefulWidget {
  const AppReportWebView({required this.html, super.key});

  final String html;

  @override
  State<AppReportWebView> createState() => _AppReportWebViewState();
}

class _AppReportWebViewState extends State<AppReportWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
    _prepareAndLoad();
  }

  WebViewController _createController() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    return WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            await handleReportNavigation(request);
            return reportNavigationDecision(request);
          },
        ),
      );
  }

  Future<void> _prepareAndLoad() async {
    await configureReportWebViewPlatform(_controller);
    await _controller.loadHtmlString(widget.html, baseUrl: reportWebViewBaseUrl);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
      gestureRecognizers: reportWebViewGestureRecognizers,
    );
  }
}

@visibleForTesting
Future<void> configureReportWebViewPlatform(WebViewController controller) async {
  if (controller.platform is AndroidWebViewController) {
    final android = controller.platform as AndroidWebViewController;
    await android.setMixedContentMode(MixedContentMode.alwaysAllow);
    await android.setUserAgent(reportWebViewUserAgent);
  } else if (controller.platform is WebKitWebViewController) {
    await (controller.platform as WebKitWebViewController)
        .setUserAgent(reportWebViewUserAgent);
  }
}

const Set<Factory<OneSequenceGestureRecognizer>> reportWebViewGestureRecognizers =
    {
  Factory<VerticalDragGestureRecognizer>(
    VerticalDragGestureRecognizer.new,
  ),
};

@visibleForTesting
bool looksLikeImageUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  final path = uri.path.toLowerCase();
  if (path.endsWith('.jpg') ||
      path.endsWith('.jpeg') ||
      path.endsWith('.png') ||
      path.endsWith('.webp') ||
      path.endsWith('.gif') ||
      path.endsWith('.avif') ||
      path.endsWith('.svg')) {
    return true;
  }
  if (path.contains('/images/') ||
      path.contains('/image/') ||
      path.contains('/img/') ||
      path.contains('/media/') ||
      path.contains('/cdn/') ||
      path.contains('/static/') ||
      path.contains('/catalog/product') ||
      path.contains('/files/')) {
    return true;
  }
  final query = uri.query.toLowerCase();
  if (query.contains('format=') ||
      query.contains('image=') ||
      query.contains('img=') ||
      query.contains('thumbnail')) {
    return true;
  }
  return false;
}

@visibleForTesting
bool isReportWebViewDocumentUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  if (uri.scheme == 'about') return true;
  return uri.scheme == 'https' &&
      uri.host == Uri.parse(reportWebViewBaseUrl).host;
}

@visibleForTesting
NavigationDecision reportNavigationDecision(NavigationRequest request) {
  if (!request.isMainFrame) {
    return NavigationDecision.navigate;
  }
  if (isReportWebViewDocumentUrl(request.url)) {
    return NavigationDecision.navigate;
  }
  if (looksLikeImageUrl(request.url)) {
    return NavigationDecision.navigate;
  }
  if (shouldOpenReportLinkExternally(request.url)) {
    return NavigationDecision.prevent;
  }
  return NavigationDecision.prevent;
}

@visibleForTesting
bool shouldOpenReportLinkExternally(String url) {
  final uri = Uri.tryParse(url);
  if (uri?.scheme != 'https') return false;
  if (looksLikeImageUrl(url)) return false;
  return true;
}

@visibleForTesting
Future<NavigationDecision> handleReportNavigation(NavigationRequest request) async {
  if (!request.isMainFrame) {
    return NavigationDecision.navigate;
  }
  if (shouldOpenReportLinkExternally(request.url)) {
    final uri = Uri.parse(request.url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
  return reportNavigationDecision(request);
}
