import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/core/crypto/credential_envelope_service.dart';
import 'package:arzlyai_mobile/core/exceptions/api_exception.dart';
import 'package:arzlyai_mobile/core/network/dto/security/credential_envelope.dart';
import 'package:arzlyai_mobile/core/network/services/connectors/connector_service.dart';
import 'package:arzlyai_mobile/data/providers/google/google_auth_provider.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_native_auth_repository.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_sheet_headers.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_sheet_tab.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/google_spreadsheet.dart';
import 'package:arzlyai_mobile/domain/mappers/connectors/google_resource_mapper.dart';

final googleResourceRepositoryProvider = Provider<GoogleResourceRepository>((
  ref,
) {
  return GoogleResourceRepository(
    ref.watch(connectorServiceProvider),
    ref.watch(googleNativeAuthRepositoryProvider),
    ref.watch(credentialEnvelopeServiceProvider),
    const GoogleResourceMapper(),
  );
});

class GoogleResourceRepository {
  const GoogleResourceRepository(
    this._service,
    this._googleAuth,
    this._envelopeService,
    this._mapper,
  );

  final ConnectorService _service;
  final GoogleNativeAuthRepository _googleAuth;
  final CredentialEnvelopeService _envelopeService;
  final GoogleResourceMapper _mapper;

  Future<List<GoogleSpreadsheet>> listSpreadsheets() async {
    return _withAccessEnvelope((envelope) async {
      final response = await _service.queryGoogleSpreadsheets(envelope);
      return response.map(_mapper.spreadsheet).toList(growable: false);
    });
  }

  Future<List<GoogleSheetTab>> listTabs(String spreadsheetId) async {
    return _withAccessEnvelope((envelope) async {
      final response = await _service.queryGoogleTabs(spreadsheetId, envelope);
      return response.map(_mapper.tab).toList(growable: false);
    });
  }

  Future<GoogleSheetHeaders> listHeaders(
    String spreadsheetId,
    String tabTitle,
  ) async {
    return _withAccessEnvelope((envelope) async {
      final response = await _service.queryGoogleHeaders(
        spreadsheetId,
        tabTitle,
        envelope,
      );
      return _mapper.headers(response);
    });
  }

  Future<T> _withAccessEnvelope<T>(
    Future<T> Function(CredentialEnvelope envelope) run,
  ) async {
    try {
      final values = await _googleAuth.envelopeValuesForConnector(
        ConnectorKeys.googleSheets,
      );
      final envelope = await _envelopeService.encrypt(values);
      return await run(envelope);
    } on ApiException {
      rethrow;
    }
  }
}
