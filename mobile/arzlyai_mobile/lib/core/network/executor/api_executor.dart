import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/constants/api_errors.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/network/configs/api_config.dart';
import 'package:arzlyai_mobile/core/network/configs/http_methods.dart';
import 'package:arzlyai_mobile/core/network/request/api_request.dart';
import 'package:arzlyai_mobile/core/network/response/api_response.dart';

part 'api_executor.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
ApiExecutor apiExecutor(Ref ref, Dio dio) {
  return ApiExecutor(dio);
}

class ApiExecutor {
  final Dio _dio;

  const ApiExecutor(this._dio);

  Future<ApiResponse<T>> execute<T>(ApiRequest<T> request) async {
    try {
      final options = (request.options ?? Options()).copyWith(
        method: request.method.value,
        headers: {...?request.headers},
      );

      final response = await _dio.request(
        request.path,
        data: request.data,
        queryParameters: request.queryParams,
        cancelToken: request.cancelToken,
        options: options,
      );

      return ApiResponse.success(
        data: response.data,
        statusCode: response.statusCode,
        meta: response.data is Map ? response.data['meta'] : null,
      );
    } on DioException catch (e) {
      return ApiResponse.failure(
        error: _mapDioException(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e, stack) {
      return ApiResponse.failure(
        error: ApiException(
          userMessage: ApiErrors.unknown,
          error: 'Unexpected error: $e',
          originalError: stack,
        ),
      );
    }
  }

  ApiException _mapDioException(DioException e) {
    final status = e.response?.statusCode;
    final body = e.response?.data;
    final correlationId = _correlationId(e, body);
    final retryAfter = _retryAfter(e.response);
    final serverMessage = _serverMessage(body);

    if (status == 429) {
      return ApiException(
        error: serverMessage ?? 'Too many requests.',
        userMessage: serverMessage ?? ApiErrors.serverError,
        statusCode: status,
        correlationId: correlationId,
        retryAfter: retryAfter,
        originalError: e,
      );
    }
    if (status == 401) {
      return ApiException(
        error: serverMessage ?? 'Unauthorized.',
        userMessage: serverMessage ?? ApiErrors.unauthorized,
        statusCode: status,
        correlationId: correlationId,
        originalError: e,
      );
    }
    if (status == 404) {
      return ApiException(
        error: serverMessage ?? 'Resource not found.',
        userMessage: serverMessage ?? ApiErrors.notFound,
        statusCode: status,
        correlationId: correlationId,
        originalError: e,
      );
    }
    if (status != null && status >= 500) {
      return ApiException(
        error: serverMessage ?? 'Server error occurred.',
        userMessage: serverMessage ?? ApiErrors.serverError,
        statusCode: status,
        correlationId: correlationId,
        originalError: e,
      );
    }

    return switch (e.type) {
      DioExceptionType.connectionTimeout => ApiException(
        error: 'Connection timed out. Please check your internet.',
        userMessage: ApiErrors.requestTimeout,
        statusCode: status,
        correlationId: correlationId,
        originalError: e,
      ),
      DioExceptionType.receiveTimeout => ApiException(
        error: 'Server took too long to respond.',
        userMessage: ApiErrors.receiveTimeout,
        statusCode: status,
        correlationId: correlationId,
        originalError: e,
      ),
      DioExceptionType.sendTimeout => ApiException(
        error: 'Request timed out while sending data.',
        userMessage: ApiErrors.sendTimeout,
        statusCode: status,
        correlationId: correlationId,
        originalError: e,
      ),
      DioExceptionType.cancel => ApiException(
        error: 'Request was cancelled.',
        userMessage: ApiErrors.cancelled,
        statusCode: status,
        correlationId: correlationId,
        originalError: e,
      ),
      DioExceptionType.badCertificate => ApiException(
        error: 'Secure connection failed.',
        userMessage: ApiErrors.certificateFailed,
        statusCode: status,
        correlationId: correlationId,
        originalError: e,
      ),
      DioExceptionType.connectionError => ApiException(
        error: 'No internet connection.',
        userMessage: ApiErrors.noInternet,
        statusCode: status,
        correlationId: correlationId,
        originalError: e,
      ),
      DioExceptionType.badResponse => ApiException(
        error: serverMessage ?? 'Invalid response from server.',
        userMessage: serverMessage ?? ApiErrors.badResponse,
        statusCode: status,
        correlationId: correlationId,
        originalError: e,
      ),
      DioExceptionType.transformTimeout => ApiException(
        error: 'Response transformation timed out.',
        userMessage: ApiErrors.receiveTimeout,
        statusCode: status,
        correlationId: correlationId,
        originalError: e,
      ),
      DioExceptionType.unknown => ApiException(
        error: serverMessage ?? e.message ?? 'An unexpected error occurred.',
        userMessage:
            _connectionUserMessage(e) ??
            serverMessage ??
            ApiErrors.unknown,
        statusCode: status,
        correlationId: correlationId,
        originalError: e,
      ),
    };
  }

  String? _serverMessage(dynamic body) {
    if (body is Map) {
      final message = body['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return null;
  }

  String? _correlationId(DioException e, dynamic body) {
    if (body is Map) {
      final id = body['correlationId'];
      if (id is String && id.isNotEmpty) return id;
    }
    final header = e.response?.headers.value(ApiConfig.correlationHeader);
    if (header is String && header.isNotEmpty) return header;
    return null;
  }

  String? _connectionUserMessage(DioException e) {
    final error = e.error;
    if (error is SocketException ||
        error is HandshakeException ||
        error is HttpException ||
        error is TlsException) {
      return ApiErrors.connectionFailed;
    }
    return null;
  }

  Duration? _retryAfter(Response? response) {
    if (response == null) return null;
    final header = response.headers.value('retry-after');
    if (header == null) return null;
    final seconds = int.tryParse(header);
    if (seconds != null) return Duration(seconds: seconds);
    return null;
  }
}
