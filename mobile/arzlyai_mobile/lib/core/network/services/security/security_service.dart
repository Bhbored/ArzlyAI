import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/network/client/dio_client.dart';
import 'package:arzlyai_mobile/core/network/configs/http_methods.dart';
import 'package:arzlyai_mobile/core/network/dto/security/encryption_key_descriptor.dart';
import 'package:arzlyai_mobile/core/network/executor/api_executor.dart';
import 'package:arzlyai_mobile/core/network/request/api_request.dart';

part 'security_service.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
SecurityService securityService(Ref ref) {
  final dioClient = ref.read(dioClientProvider(null, endpoint: ''));
  final apiExecutor = ref.read(apiExecutorProvider(dioClient.dio));
  return SecurityService(apiExecutor);
}

class SecurityService {
  SecurityService(this._apiExecutor);

  final ApiExecutor _apiExecutor;
  final _logger = Logger();

  Future<EncryptionKeyDescriptor> getEncryptionKey() async {
    final response = await _apiExecutor.execute(
      ApiRequest(path: 'security/encryption-key', method: HttpMethod.get),
    );
    return response.when(
      success: (data, statusCode, meta) {
        _logger.i('Encryption key descriptor retrieved');
        return EncryptionKeyDescriptor.fromJson(data as Map<String, dynamic>);
      },
      failure: (error, statusCode) {
        _logger.e('Failed to retrieve encryption key');
        throw error;
      },
    );
  }
}
