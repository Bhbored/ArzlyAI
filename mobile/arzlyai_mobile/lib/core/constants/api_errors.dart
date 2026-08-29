import 'package:easy_localization/easy_localization.dart';

class ApiErrors {
  const ApiErrors._();

  static String get noInternet => 'api_errors.no_internet'.tr();
  static String get requestTimeout => 'api_errors.request_timeout'.tr();
  static String get sendTimeout => 'api_errors.send_timeout'.tr();
  static String get receiveTimeout => 'api_errors.receive_timeout'.tr();
  static String get badResponse => 'api_errors.bad_response'.tr();
  static String get cancelled => 'api_errors.cancelled'.tr();
  static String get unknown => 'api_errors.unknown'.tr();
  static String get certificateFailed => 'api_errors.certificate_failed'.tr();
  static String get connectionFailed => 'api_errors.connection_failed'.tr();
  static String get unauthorized => 'api_errors.unauthorized'.tr();
  static String get notFound => 'api_errors.not_found'.tr();
  static String get serverError => 'api_errors.server_error'.tr();
}
