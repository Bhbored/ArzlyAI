import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:arzlyai_mobile/core/network/configs/api_config.dart';

class CorrelationInterceptor extends Interceptor {
  CorrelationInterceptor({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiConfig.correlationHeader] = _uuid.v4();
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final incoming = response.headers.value(ApiConfig.correlationHeader);
    if (incoming != null && incoming.isNotEmpty) {
      response.requestOptions.headers[ApiConfig.correlationHeader] = incoming;
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final incoming = err.response?.headers.value(ApiConfig.correlationHeader);
    if (incoming != null && incoming.isNotEmpty) {
      err.requestOptions.headers[ApiConfig.correlationHeader] = incoming;
    }
    handler.next(err);
  }
}
