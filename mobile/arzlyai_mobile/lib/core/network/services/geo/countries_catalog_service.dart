import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/constants/api_errors.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/network/configs/api_config.dart';
import 'package:arzlyai_mobile/core/network/configs/http_methods.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/network/request/api_request.dart';

part 'countries_catalog_service.g.dart';

Duration? retry(int _, Object _) => null;

const _countriesNowBaseUrl = 'https://countriesnow.space/api/v0.1/';

@Riverpod(keepAlive: true, retry: retry)
CountriesCatalogService countriesCatalogService(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: _countriesNowBaseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      responseType: ResponseType.json,
    ),
  );
  return CountriesCatalogService(ref.watch(apiExecutorProvider(dio)));
}

class CountriesCatalogService {
  CountriesCatalogService(this._apiExecutor);

  final ApiExecutor _apiExecutor;
  final _logger = Logger();

  Future<List<Map<String, dynamic>>> fetchAll() async {
    final response = await _apiExecutor.execute(
      const ApiRequest(
        path: 'countries/flag/images',
        method: HttpMethod.get,
      ),
    );
    return response.when(
      success: (data, statusCode, meta) {
        try {
          final payload = _decodeMap(data);
          if (payload['error'] == true) {
            final message = payload['msg'] as String? ?? 'Country catalog unavailable';
            throw ApiException(
              userMessage: ApiErrors.badResponse,
              error: message,
              statusCode: statusCode,
              originalError: message,
            );
          }
          final list = payload['data'];
          if (list is! List) {
            throw FormatException('Expected country data array, got ${list.runtimeType}');
          }
          _logger.i('Countries retrieved (${list.length})');
          return list
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList(growable: false);
        } catch (e, stack) {
          _logger.e('Failed to parse countries ($statusCode): $e');
          if (e is ApiException) rethrow;
          throw ApiException(
            userMessage: ApiErrors.badResponse,
            error: 'Invalid country list payload: $e',
            statusCode: statusCode,
            originalError: stack,
          );
        }
      },
      failure: (error, statusCode) {
        _logger.e('Failed to retrieve countries');
        throw error;
      },
    );
  }

  Map<String, dynamic> _decodeMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    }
    throw FormatException('Expected JSON object, got ${data.runtimeType}');
  }
}
