import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/constants/api_errors.dart';
import 'package:arzlyai_mobile/core/network/client/dio_client.dart';
import 'package:arzlyai_mobile/core/network/configs/http_methods.dart';
import 'package:arzlyai_mobile/core/network/dto/request/models/list_openai_models_request.dart';
import 'package:arzlyai_mobile/core/network/dto/response/models/openai_model_response.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/network/request/api_request.dart';

part 'openai_model_service.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
OpenAiModelService openAiModelService(Ref ref) {
  final dio = ref.watch(dioClientProvider(null, endpoint: '')).dio;
  final apiExecutor = ref.watch(apiExecutorProvider(dio));
  return OpenAiModelService(apiExecutor);
}

class OpenAiModelService {
  OpenAiModelService(this._apiExecutor);

  final ApiExecutor _apiExecutor;
  final _logger = Logger();

  Future<List<OpenAiModelResponse>> listModels(
    ListOpenAiModelsRequest request,
  ) async {
    final response = await _apiExecutor.execute(
      ApiRequest(
        path: 'providers/openai/models',
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
                (item) => OpenAiModelResponse.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList();
          _logger.i('OpenAI models retrieved (${models.length})');
          return models;
        } catch (e, stack) {
          _logger.e('Failed to parse OpenAI models ($statusCode): $e');
          throw ApiException(
            userMessage: ApiErrors.badResponse,
            error: 'Invalid OpenAI model list payload: $e',
            statusCode: statusCode,
            originalError: stack,
          );
        }
      },
      failure: (error, statusCode) {
        _logger.e('Failed to retrieve OpenAI models');
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
