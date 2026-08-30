import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_service.dart';
import 'package:arzlyai_mobile/core/network/dto/request/models/list_openai_models_request.dart';
import 'package:arzlyai_mobile/core/network/services/models/openai_model_service.dart';
import 'package:arzlyai_mobile/data/repositories/credential_repository.dart';
import 'package:arzlyai_mobile/domain/entities/provider/openai_model.dart';
import 'package:arzlyai_mobile/domain/mappers/provider/openai_model_mapper.dart';

part 'openai_model_repository.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
OpenAiModelRepository openAiModelRepository(Ref ref) {
  return OpenAiModelRepository(
    ref.read(openAiModelServiceProvider),
    ref.read(credentialRepositoryProvider),
    ref.read(credentialEnvelopeServiceProvider),
    const OpenAiModelMapper(),
  );
}

class OpenAiModelRepository {
  OpenAiModelRepository(
    this._service,
    this._credentials,
    this._envelopes,
    this._mapper,
  );

  final OpenAiModelService _service;
  final CredentialRepository _credentials;
  final CredentialEnvelopeService _envelopes;
  final OpenAiModelMapper _mapper;

  List<OpenAiModel>? _cache;

  List<OpenAiModel>? get cachedModels => _cache;

  bool? modelSupportsTemperature(String modelId) {
    if (_cache == null) return null;
    for (final model in _cache!) {
      if (model.id == modelId) return model.supportsTemperature;
    }
    return null;
  }

  Future<List<OpenAiModel>> listModels({bool forceRefresh = false}) async {
    if (!forceRefresh && _cache != null) {
      return _cache!;
    }

    final envelopeKey = providerCredentialEnvelopeKey('openai');
    final values = await _credentials.readForEnvelopeKeys([envelopeKey]);
    final missing = _credentials.missingEnvelopeKeys([envelopeKey], values);
    if (missing.isNotEmpty) {
      throw StateError('Missing credentials: ${missing.join(', ')}');
    }

    final envelope = await _envelopes.encrypt({
      envelopeKey: values[envelopeKey]!,
    });
    final dtos = await _service.listModels(
      ListOpenAiModelsRequest(credentials: envelope),
    );
    final models = dtos.map(_mapper.fromDto).toList(growable: false);
    _cache = models;
    return models;
  }
}
