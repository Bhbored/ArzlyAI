import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionInterceptor extends Interceptor {
  PackageInfo? _packageInfo;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _packageInfo ??= await PackageInfo.fromPlatform();
    options.headers['X-Client-Version'] = _packageInfo!.version;
    handler.next(options);
  }
}
