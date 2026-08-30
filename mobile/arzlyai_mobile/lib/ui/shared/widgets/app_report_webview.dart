import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            await handleReportNavigation(request.url);
            return reportNavigationDecision(request.url);
          },
        ),
      )
      ..loadHtmlString(widget.html);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
      gestureRecognizers: reportWebViewGestureRecognizers,
    );
  }
}

const Set<Factory<OneSequenceGestureRecognizer>> reportWebViewGestureRecognizers =
    {
  Factory<VerticalDragGestureRecognizer>(
    VerticalDragGestureRecognizer.new,
  ),
};

@visibleForTesting
NavigationDecision reportNavigationDecision(String url) {
  return NavigationDecision.prevent;
}

@visibleForTesting
bool shouldOpenReportLinkExternally(String url) {
  final uri = Uri.tryParse(url);
  return uri?.scheme == 'https';
}

@visibleForTesting
Future<NavigationDecision> handleReportNavigation(String url) async {
  if (shouldOpenReportLinkExternally(url)) {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
  return reportNavigationDecision(url);
}
