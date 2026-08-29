import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:arzlyai_mobile/core/network/configs/http_methods.dart';

part 'api_request.freezed.dart';

@Freezed(genericArgumentFactories: true)
sealed class ApiRequest<T> with _$ApiRequest<T> {
  const factory ApiRequest({
    required String path,
    required HttpMethod method,
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
  }) = _ApiRequest<T>;
}
