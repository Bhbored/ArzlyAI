import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';

part 'api_response.freezed.dart';

@Freezed(genericArgumentFactories: true)
sealed class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.success({
    required T data,
    int? statusCode,
    Map<String, dynamic>? meta,
  }) = ApiSuccess<T>;

  const factory ApiResponse.failure({
    required ApiException error,
    int? statusCode,
  }) = ApiFailure<T>;

  const ApiResponse._();

  R when<R>({
    required R Function(T data, int? statusCode, Map<String, dynamic>? meta)
    success,
    required R Function(ApiException error, int? statusCode) failure,
  }) {
    return map(
      success: (s) => success(s.data, s.statusCode, s.meta),
      failure: (f) => failure(f.error, f.statusCode),
    );
  }

  bool get isSuccess => this is ApiSuccess<T>;
  bool get isFailure => this is ApiFailure<T>;
}
