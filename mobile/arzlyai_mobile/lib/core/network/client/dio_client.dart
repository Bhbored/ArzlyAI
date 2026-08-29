import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/network/configs/api_config.dart';
import 'package:arzlyai_mobile/core/network/interceptors/app_version_interceptor.dart';
import 'package:arzlyai_mobile/core/network/interceptors/correlation_interceptor.dart';
import 'package:arzlyai_mobile/core/network/interceptors/retry_interceptor.dart';
import 'package:arzlyai_mobile/data/providers/network/backend_url_provider.dart';

part 'dio_client.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
DioClient dioClient(
  Ref ref,
  Map<String, String>? headers, {
  required String endpoint,
}) {
  final header = <String, dynamic>{...?headers};
  final baseUrl =
      ref.watch(backendUrlProvider).value ?? ApiConfig.defaultBaseUrl;
  return DioClient(headers: header, endpoint: endpoint, baseUrl: baseUrl);
}

class DioClient {
  late final Dio dio;
  final Map<String, dynamic> headers;
  bool enableLogging;
  String endpoint;
  String baseUrl;

  DioClient({
    required this.headers,
    this.enableLogging = true,
    required this.endpoint,
    required this.baseUrl,
  }) {
    final root = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    dio = Dio(
      BaseOptions(
        baseUrl: '$root$endpoint',
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        contentType: 'application/json',
        responseType: ResponseType.json,
        headers: headers,
      ),
    );
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        if (kDebugMode) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
        }
        return client;
      },
    );
    dio.interceptors.add(CorrelationInterceptor());
    dio.interceptors.add(AppVersionInterceptor());
    dio.interceptors.add(RetryInterceptor(dio: dio, maxRetries: 2));
    if (enableLogging && kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          responseHeader: true,
          requestBody: true,
          responseBody: true,
        ),
      );
    }
  }
}
