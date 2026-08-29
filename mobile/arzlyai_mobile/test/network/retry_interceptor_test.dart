import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/network/interceptors/retry_interceptor.dart';

class _Adapter implements HttpClientAdapter {
  var gets = 0;
  var posts = 0;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.method.toUpperCase() == 'GET') {
      gets++;
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionTimeout,
      );
    }
    posts++;
    throw DioException(
      requestOptions: options,
      type: DioExceptionType.connectionTimeout,
    );
  }
}

void main() {
  test('retry interceptor retries GET only', () async {
    final getAdapter = _Adapter();
    final getDio = Dio()..httpClientAdapter = getAdapter;
    getDio.interceptors.add(
      RetryInterceptor(
        dio: getDio,
        maxRetries: 2,
        retryBaseDelay: Duration.zero,
      ),
    );
    try {
      await getDio.get<void>('/presets');
    } on DioException {
      // expected
    }
    expect(getAdapter.gets, 3);

    final postAdapter = _Adapter();
    final postDio = Dio()..httpClientAdapter = postAdapter;
    postDio.interceptors.add(
      RetryInterceptor(
        dio: postDio,
        maxRetries: 2,
        retryBaseDelay: Duration.zero,
      ),
    );
    try {
      await postDio.post<void>('/workflows/runs');
    } on DioException {
      // expected
    }
    expect(postAdapter.posts, 1);
  });
}
