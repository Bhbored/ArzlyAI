import 'dart:io';

import 'package:flutter/foundation.dart';

final class DevSslHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    if (kDebugMode) {
      client.badCertificateCallback = (cert, host, port) => true;
    }
    return client;
  }

  static void enableIfDebug() {
    if (kDebugMode) {
      HttpOverrides.global = DevSslHttpOverrides();
    }
  }
}
