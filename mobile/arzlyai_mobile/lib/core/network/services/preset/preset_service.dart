import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/constants/api_errors.dart';
import 'package:arzlyai_mobile/core/network/client/dio_client.dart';
import 'package:arzlyai_mobile/core/network/configs/http_methods.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_details_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/preset/preset_summary_response.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/network/request/api_request.dart';

part 'preset_service.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
PresetService presetService(Ref ref) {
  final dio = ref.watch(dioClientProvider(null, endpoint: '')).dio;
  final apiExecutor = ref.watch(apiExecutorProvider(dio));
  return PresetService(apiExecutor, dio);
}

class PresetService {
  PresetService(this._apiExecutor, this._dio);

  final ApiExecutor _apiExecutor;
  final Dio _dio;
  final _logger = Logger();

  Future<List<PresetSummaryResponse>> listPresets() async {
    final baseUrl = _dio.options.baseUrl;
    _logger.i('GET $baseUrl presets');
    final response = await _apiExecutor.execute(
      ApiRequest(path: 'presets', method: HttpMethod.get),
    );
    return response.when(
      success: (data, statusCode, meta) {
        try {
          final list = _decodeList(data);
          final presets = list
              .map(
                (item) => PresetSummaryResponse.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList();
          _logger.i('Presets retrieved (${presets.length})');
          return presets;
        } catch (e, stack) {
          _logger.e('Failed to parse presets ($statusCode): $e');
          throw ApiException(
            userMessage: ApiErrors.badResponse,
            error: 'Invalid preset list payload: $e',
            statusCode: statusCode,
            originalError: stack,
          );
        }
      },
      failure: (error, statusCode) {
        final underlying = error.originalError;
        _logger.e(
          'Failed to retrieve presets (${statusCode ?? 'no status'}): ${error.error}'
          '${underlying is DioException ? ' [${underlying.type}, ${underlying.error}]' : ''}',
        );
        throw error;
      },
    );
  }

  Future<PresetDetailsResponse> getPreset(String key) async {
    final response = await _apiExecutor.execute(
      ApiRequest(path: 'presets/$key', method: HttpMethod.get),
    );
    return response.when(
      success: (data, statusCode, meta) {
        _logger.i('Preset retrieved');
        return PresetDetailsResponse.fromJson(
          Map<String, dynamic>.from(data as Map),
        );
      },
      failure: (error, statusCode) {
        _logger.e('Failed to retrieve preset');
        throw error;
      },
    );
  }

  List<dynamic> _decodeList(dynamic data) {
    if (data is List) return data;
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is List) return decoded;
    }
    throw FormatException('Expected JSON array, got ${data.runtimeType}');
  }
}
