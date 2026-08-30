import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_node_run_response.dart';
import 'package:arzlyai_mobile/core/network/dto/response/workflow/workflow_run_response.dart';
import 'package:arzlyai_mobile/domain/mappers/workflow/workflow_run_mapper.dart';

void main() {
  test('RunMapper_WhenEffectiveModelReturned_PreservesServerValue', () {
    const mapper = WorkflowRunMapper();
    final run = mapper.fromDto(
      WorkflowRunResponse(
        runId: 'run-1',
        presetKey: 'smart-purchase-decision',
        status: 'Running',
        nodes: [
          WorkflowNodeRunResponse(
            nodeId: 'node-1',
            nodeKey: 'market-researcher',
            displayName: 'Market Researcher',
            type: 'Agent',
            status: 'Completed',
            isRunning: false,
            effectiveProvider: 'openai',
            effectiveModel: 'gpt-4o-mini',
            effectiveTemperature: 0.15,
          ),
        ],
      ),
    );
    expect(run.nodes.single.effectiveProvider, 'openai');
    expect(run.nodes.single.effectiveModel, 'gpt-4o-mini');
    expect(run.nodes.single.effectiveTemperature, 0.15);
  });
}
