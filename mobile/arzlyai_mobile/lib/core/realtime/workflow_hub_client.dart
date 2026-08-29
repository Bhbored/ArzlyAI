import 'dart:async';

import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:arzlyai_mobile/core/network/configs/api_config.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_node_changed_event.dart';
import 'package:arzlyai_mobile/data/providers/network/backend_url_provider.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';

part 'workflow_hub_client.g.dart';

Duration? retry(int _, Object _) => null;

@Riverpod(keepAlive: true, retry: retry)
WorkflowHubClient workflowHubClient(Ref ref) {
  final client = WorkflowHubClient(
    () async => ref.read(backendUrlProvider).value ?? ApiConfig.defaultBaseUrl,
  );
  ref.onDispose(client.dispose);
  return client;
}

class WorkflowHubClient {
  WorkflowHubClient(this._baseUrl);

  final Future<String> Function() _baseUrl;
  final _logger = Logger();
  final _mapper = const WorkflowRunMapper();
  final _controller = StreamController<WorkflowNodeChanged>.broadcast();
  HubConnection? _hub;
  String? _subscribedRunId;

  Stream<WorkflowNodeChanged> get events => _controller.stream;

  Future<void> subscribeToRun(String runId) async {
    await _ensureConnected();
    _subscribedRunId = runId;
    await _hub!.invoke('SubscribeToRun', args: [runId]);
  }

  Future<void> reconnect() async {
    await _hub?.stop();
    _hub = null;
    await _ensureConnected();
    final runId = _subscribedRunId;
    if (runId != null) {
      await _hub!.invoke('SubscribeToRun', args: [runId]);
    }
  }

  Future<void> dispose() async {
    await _hub?.stop();
    await _controller.close();
  }

  Future<void> _ensureConnected() async {
    if (_hub?.state == HubConnectionState.Connected) return;
    final hubUrl = ApiConfig.resolveWorkflowHub(await _baseUrl()).toString();
    final hub = HubConnectionBuilder().withUrl(hubUrl).build();
    hub.on('NodeChanged', _onNodeChanged);
    hub.onclose(({error}) {
      _logger.w('SignalR closed');
    });
    await hub.start();
    _hub = hub;
  }

  void _onNodeChanged(List<Object?>? args) {
    if (args == null || args.isEmpty) return;
    final raw = args.first;
    if (raw is! Map) return;
    final event = WorkflowNodeChangedEvent.fromJson(
      Map<String, dynamic>.from(raw),
    );
    if (!_controller.isClosed) {
      _controller.add(_mapper.eventFromDto(event));
    }
  }
}
