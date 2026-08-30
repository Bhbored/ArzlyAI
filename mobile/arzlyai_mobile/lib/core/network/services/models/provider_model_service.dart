import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/constants/ai_providers.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/constants/api_errors.dart';
import 'package:arzlyai_mobile/core/network/client/dio_client.dart';
import 'package:arzlyai_mobile/core/network/configs/http_methods.dart';
import 'package:arzlyai_mobile/core/network/dto/request/models/list_provider_models_request.dart';
import 'package:arzlyai_mobile/core/network/dto/response/models/provider_model_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/models/provider_response.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/network/request/api_request.dart';

part 'provider_model_service.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
ProviderModelService providerModelService(Ref ref) {
  final dio = ref.watch(dioClientProvider(null, endpoint: '')).dio;
  final apiExecutor = ref.watch(apiExecutorProvider(dio));
  return ProviderModelService(apiExecutor);
}

class ProviderModelService {
  ProviderModelService(this._apiExecutor);

  final ApiExecutor _apiExecutor;
  final _logger = Logger();

  Future<List<ProviderResponse>> listProviders() async {
    final response = await _apiExecutor.execute(
      const ApiRequest(path: 'providers', method: HttpMethod.get),
    );
    return response.when(
      success: (data, statusCode, meta) {
        try {
          final list = _decodeList(data);
          final providers = list
              .map(
                (item) => ProviderResponse.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList();
          _logger.i('Providers retrieved (${providers.length})');
          return providers;
        } catch (e, stack) {
          _logger.e('Failed to parse providers ($statusCode): $e');
          throw ApiException(
            userMessage: ApiErrors.badResponse,
            error: 'Invalid provider list payload: $e',
            statusCode: statusCode,
            originalError: stack,
          );
        }
      },
      failure: (error, statusCode) {
        _logger.e('Failed to retrieve providers');
        throw error;
      },
    );
  }

  Future<List<ProviderModelResponse>> listModels(
    String provider,
    ListProviderModelsRequest request,
  ) async {
    final normalized = provider.toLowerCase();
    if (!supportedAiProviders.contains(normalized)) {
      throw ArgumentError('Unsupported provider: $provider');
    }
    final response = await _apiExecutor.execute(
      ApiRequest(
        path: 'providers/$normalized/models',
        method: HttpMethod.post,
        data: request.toJson(),
      ),
    );
    return response.when(
      success: (data, statusCode, meta) {
        try {
          final list = _decodeList(data);
          final models = list
              .map(
                (item) => ProviderModelResponse.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList();
          _logger.i('$normalized models retrieved (${models.length})');
          return models;
        } catch (e, stack) {
          _logger.e('Failed to parse $normalized models ($statusCode): $e');
          throw ApiException(
            userMessage: ApiErrors.badResponse,
            error: 'Invalid model list payload: $e',
            statusCode: statusCode,
            originalError: stack,
          );
        }
      },
      failure: (error, statusCode) {
        _logger.e('Failed to retrieve $normalized models');
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
