import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_service.dart';
import 'package:arzlyai_mobile/core/network/dto/request/models/list_provider_models_request.dart';
import 'package:arzlyai_mobile/core/network/services/models/provider_model_service.dart';
import 'package:arzlyai_mobile/data/repositories/credentials/credential_repository.dart';
import 'package:arzlyai_mobile/domain/entities/provider/provider_model.dart';
import 'package:arzlyai_mobile/domain/mappers/provider/provider_model_mapper.dart';
import 'package:arzlyai_mobile/infrastructor/db/database.dart';

part 'provider_model_repository.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
ProviderModelRepository providerModelRepository(Ref ref) {
  return ProviderModelRepository(
    ref.read(appDatabaseProvider),
    ref.read(providerModelServiceProvider),
    ref.read(credentialRepositoryProvider),
    ref.read(credentialEnvelopeServiceProvider),
    const ProviderModelMapper(),
  );
}

class ProviderModelRepository {
  ProviderModelRepository(
    this._db,
    this._service,
    this._credentials,
    this._envelopes,
    this._mapper,
  );

  final AppDatabase _db;
  final ProviderModelService _service;
  final CredentialRepository _credentials;
  final CredentialEnvelopeService _envelopes;
  final ProviderModelMapper _mapper;

  Future<List<String>> providersWithSavedKeys(List<String> providerKeys) async {
    final keys = providerKeys
        .map(providerCredentialEnvelopeKey)
        .toList(growable: false);
    final values = await _credentials.readForEnvelopeKeys(keys);
    return providerKeys
        .where(
          (provider) =>
              values[providerCredentialEnvelopeKey(provider)]?.trim().isNotEmpty ??
              false,
        )
        .toList(growable: false);
  }

  Future<List<ProviderModel>> cachedModelsForProvider(String provider) async {
    final row = await (_db.select(_db.providerModelCache)
          ..where((table) => table.provider.equals(provider.toLowerCase())))
        .getSingleOrNull();
    if (row == null) return const [];
    final list = jsonDecode(row.modelsJson) as List<dynamic>;
    return list
        .map((item) => _mapper.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList(growable: false);
  }

  Future<List<ProviderModel>> listModelsForProvider(
    String provider, {
    bool forceRefresh = false,
  }) async {
    final normalized = provider.toLowerCase();
    if (!forceRefresh) {
      final cached = await cachedModelsForProvider(normalized);
      if (cached.isNotEmpty) return cached;
    }

    final envelopeKey = providerCredentialEnvelopeKey(normalized);
    final values = await _credentials.readForEnvelopeKeys([envelopeKey]);
    final missing = _credentials.missingEnvelopeKeys([envelopeKey], values);
    if (missing.isNotEmpty) {
      throw StateError('Missing credentials: ${missing.join(', ')}');
    }

    final envelope = await _envelopes.encrypt({envelopeKey: values[envelopeKey]!});
    final dtos = await _service.listModels(
      normalized,
      ListProviderModelsRequest(credentials: envelope),
    );
    final models = dtos.map(_mapper.fromDto).toList(growable: false);
    await _db.into(_db.providerModelCache).insertOnConflictUpdate(
          ProviderModelCacheCompanion.insert(
            provider: normalized,
            modelsJson: jsonEncode(models.map(_mapper.toJson).toList()),
            fetchedAtUtc: DateTime.now().toUtc(),
          ),
        );
    return models;
  }

  Future<List<ProviderModel>> listModelsForProviders(
    List<String> providers, {
    bool forceRefresh = false,
  }) async {
    final keyed = await providersWithSavedKeys(providers);
    final models = <ProviderModel>[];
    for (final provider in keyed) {
      models.addAll(
        await listModelsForProvider(provider, forceRefresh: forceRefresh),
      );
    }
    models.sort(
      (left, right) => left.displayName.compareTo(right.displayName),
    );
    return models;
  }

  ProviderModel? findModel(
    List<ProviderModel> models,
    String modelId, [
    String? provider,
  ]) {
    for (final model in models) {
      if (model.id != modelId) continue;
      if (provider != null &&
          provider.isNotEmpty &&
          model.provider != provider) {
        continue;
      }
      return model;
    }
    return null;
  }

  String resolveProviderForModel(
    List<ProviderModel> models,
    String modelId, {
    String? configuredProvider,
    required String fallbackProvider,
  }) {
    if (configuredProvider != null && configuredProvider.isNotEmpty) {
      final explicit = findModel(models, modelId, configuredProvider);
      if (explicit != null) return explicit.provider;
    }
    return findModel(models, modelId)?.provider ?? fallbackProvider;
  }

  bool? modelSupportsTemperature(
    List<ProviderModel> models,
    String modelId,
  ) =>
      findModel(models, modelId)?.supportsTemperature;
}
