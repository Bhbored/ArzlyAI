import 'package:flutter/foundation.dart';

abstract final class ApiConfig {
  static const String defaultOrigin = String.fromEnvironment(
    'ARZLYAI_API_ORIGIN',
    defaultValue: 'https://10.0.2.2:7029',
  );

  static const String defaultBaseUrl = '$defaultOrigin/api/v1/';
  static const String signalRHubPath = '/api/v1/hubs/workflows';
  static const String correlationHeader = 'X-Correlation-ID';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 15);

  static Uri api(String path) {
    final origin = parseOrigin(defaultOrigin);
    final normalizedPath = path.replaceFirst(RegExp(r'^/+'), '');
    return origin.replace(path: '/api/v1/$normalizedPath');
  }

  static Uri health(String probe) {
    final origin = parseOrigin(defaultOrigin);
    final normalizedProbe = probe.replaceFirst(RegExp(r'^/+'), '');
    return origin.replace(path: '/health/$normalizedProbe');
  }

  static Uri get workflowHub =>
      parseOrigin(defaultOrigin).replace(path: signalRHubPath);

  static String originFromBaseUrl(String baseUrl) {
    final uri = Uri.parse(baseUrl.trim());
    return '${uri.scheme}://${uri.authority}';
  }

  static String resolveBaseUrl(String? value) {
    if (value == null || value.trim().isEmpty) return defaultBaseUrl;
    final trimmed = value.trim();
    if (trimmed.contains('/api/')) {
      final normalized = trimmed.endsWith('/') ? trimmed : '$trimmed/';
      return _remapLoopbackUri(Uri.parse(normalized)).toString();
    }
    final origin = resolveDeviceOrigin(trimmed);
    return parseOrigin(origin).replace(path: '/api/v1/').toString();
  }

  static String resolveDeviceOrigin(String value) {
    final uri = _remapLoopbackUri(parseOrigin(value.trim()));
    return '${uri.scheme}://${uri.authority}';
  }

  static Uri _remapLoopbackUri(Uri uri) {
    final host = _deviceLoopbackHost(uri.host);
    if (host == uri.host) return uri;
    return uri.replace(host: host);
  }

  static String _deviceLoopbackHost(String host) {
    if (kIsWeb) return host;
    final lower = host.toLowerCase();
    if (lower == 'localhost' || lower == '127.0.0.1') return '10.0.2.2';
    return host;
  }

  static Uri resolveWorkflowHub(String baseUrlOrOrigin) {
    final trimmed = baseUrlOrOrigin.trim();
    if (trimmed.isEmpty) return workflowHub;
    final originUri = trimmed.contains('/api/')
        ? _remapLoopbackUri(
            Uri.parse(trimmed.endsWith('/') ? trimmed : '$trimmed/'),
          )
        : _remapLoopbackUri(parseOrigin(trimmed));
    return originUri.replace(path: signalRHubPath);
  }

  static Uri parseOrigin(String value) {
    final uri = Uri.tryParse(value.trim());
    final hasOnlyOriginPath = uri?.path.isEmpty == true || uri?.path == '/';

    if (uri == null ||
        !uri.hasScheme ||
        !uri.hasAuthority ||
        !hasOnlyOriginPath ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw FormatException(
        'The API origin must look like https://10.0.2.2:7029.',
        value,
      );
    }

    if (uri.scheme != 'https' && uri.scheme != 'http') {
      throw FormatException(
        'Only HTTP and HTTPS origins are supported.',
        value,
      );
    }

    return uri;
  }
}
