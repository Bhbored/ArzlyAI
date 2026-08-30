import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/api_errors.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';

class AppToast {
  static String messageFor(Object error) {
    if (error is ApiException) return _apiExceptionMessage(error);
    if (error is HandshakeException || error is TlsException) {
      return ApiErrors.certificateFailed;
    }
    if (error is SocketException) return ApiErrors.connectionFailed;
    if (error is DioException) return _dioExceptionMessage(error);
    if (error is StateError) return error.message;
    if (error is ArgumentError) {
      return error.message?.toString() ?? '$error';
    }
    return ApiErrors.unknown;
  }

  static String _apiExceptionMessage(ApiException error) {
    final message = error.userMessage.trim();
    if (message.isNotEmpty) return message;
    return _apiExceptionFallback(error);
  }

  static String _apiExceptionFallback(ApiException error) {
    final status = error.statusCode;
    if (status == 401) return ApiErrors.unauthorized;
    if (status == 404) return ApiErrors.notFound;
    if (status != null && status >= 500) return ApiErrors.serverError;

    final original = error.originalError;
    if (original is DioException) return _dioExceptionMessage(original);
    return ApiErrors.unknown;
  }

  static String _dioExceptionMessage(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout => ApiErrors.requestTimeout,
      DioExceptionType.receiveTimeout => ApiErrors.receiveTimeout,
      DioExceptionType.sendTimeout => ApiErrors.sendTimeout,
      DioExceptionType.cancel => ApiErrors.cancelled,
      DioExceptionType.badCertificate => ApiErrors.certificateFailed,
      DioExceptionType.connectionError => ApiErrors.noInternet,
      DioExceptionType.badResponse => ApiErrors.badResponse,
      DioExceptionType.transformTimeout => ApiErrors.receiveTimeout,
      DioExceptionType.unknown => ApiErrors.unknown,
    };
  }

  static void showError(
    BuildContext context, {
    String? title,
    required String message,
  }) {
    if (!context.mounted) return;
    ShadToaster.of(context).show(
      ShadToast.destructive(
        title: Text(title ?? ApiErrors.unknown),
        description: Text(message),
      ),
    );
  }

  static void errorFor(
    BuildContext context,
    Object error, {
    String? title,
  }) {
    if (!context.mounted) return;
    showError(
      context,
      title: title,
      message: messageFor(error),
    );
  }
}
