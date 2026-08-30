import 'package:dio/dio.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';

extension ApiExceptionExtensions on ApiException {
  bool get isReceiveTimeout {
    final original = originalError;
    if (original is DioException) {
      return original.type == DioExceptionType.receiveTimeout ||
          original.type == DioExceptionType.transformTimeout;
    }
    return false;
  }
}

bool isReceiveTimeoutError(Object error) {
  if (error is ApiException) return error.isReceiveTimeout;
  if (error is DioException) {
    return error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.transformTimeout;
  }
  return false;
}
