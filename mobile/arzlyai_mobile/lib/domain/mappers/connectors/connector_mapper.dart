import 'package:arzlyai_mobile/core/network/dto/response/connectors/connector_session_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/connectors/connector_status_response.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/connector_session.dart';
import 'package:arzlyai_mobile/domain/entities/connectors/connector_status.dart';

class ConnectorMapper {
  const ConnectorMapper();

  ConnectorSession sessionFromDto(ConnectorSessionResponse dto) {
    return ConnectorSession(
      connectUrl: dto.connectUrl,
      sessionToken: dto.sessionToken,
      expiresAtUtc: dto.expiresAtUtc,
    );
  }

  ConnectorStatus statusFromDto(ConnectorStatusResponse dto) {
    return ConnectorStatus(
      connectorKey: dto.connectorKey,
      isConnected: dto.isConnected,
      connectedAtUtc: dto.connectedAtUtc,
    );
  }
}
