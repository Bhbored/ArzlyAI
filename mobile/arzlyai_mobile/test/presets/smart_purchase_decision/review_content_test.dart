import 'package:flutter_test/flutter_test.dart';
import 'package:arzlyai_mobile/core/enums/workflow_node_status.dart';
import 'package:arzlyai_mobile/core/enums/workflow_run_status.dart';
import 'package:arzlyai_mobile/domain/entities/preset/approval_configuration.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/ui/features/presets/implementations/smart_purchase_decision/smart_purchase_review_content.dart';

WorkflowRun _finalReviewRun({required String content}) {
  return WorkflowRun(
    runId: 'run-1',
    presetKey: 'smart-purchase-decision',
    status: WorkflowRunStatus.waitingForApproval,
    nodes: const [
      WorkflowNodeRun(
        nodeId: 'n1',
        nodeKey: 'understand-request',
        displayName: 'Understand request',
        type: 'Agent',
        status: WorkflowNodeStatus.completed,
        isRunning: false,
      ),
      WorkflowNodeRun(
        nodeId: 'n4',
        nodeKey: 'review-pick',
        displayName: 'Your pick',
        type: 'HumanApproval',
        status: WorkflowNodeStatus.waitingForApproval,
        isRunning: false,
      ),
    ],
    approval: ApprovalSnapshot(
      originalContent: content,
      currentContent: content,
      wasEdited: false,
    ),
  );
}

WorkflowNode _reviewNode() {
  return const WorkflowNode(
    id: 'n4',
    key: 'review-pick',
    displayName: 'Your pick',
    type: 'HumanApproval',
    position: 4,
    requiresHumanApproval: true,
    approvalConfiguration: ApprovalNodeConfiguration(
      acceptLabel: 'Looks good',
      editLabel: 'Try a different search',
      rejectLabel: 'Discard',
    ),
    resultContract: ResultContract(key: 'arzly.report', version: 4),
  );
}

void main() {
  test('ReviewContent_WhenAcceptLabelLooksGood_TreatsAsFinalReview', () {
    const content =
        '{"kind":"purchaseDecision","title":"Laptops","blocks":[],"sources":[]}';
    final run = _finalReviewRun(content: content);

    expect(
      SmartPurchaseReviewContent.isFinalReview(
        preset: null,
        run: run,
        waitingNode: _reviewNode(),
        content: content,
      ),
      isTrue,
    );
    expect(
      SmartPurchaseReviewContent.shouldShowReportView(
        run: run,
        finalReview: true,
        content: content,
      ),
      isTrue,
    );
  });

  test('ReviewContent_WhenPurchaseDecisionJson_ShowsReportEvenIfGateFails', () {
    const content =
        '{"kind":"purchaseDecision","title":"Laptops","blocks":[{"data":{"text":"Pick","items":[]}}],"sources":[]}';
    final run = _finalReviewRun(content: content);

    expect(
      SmartPurchaseReviewContent.shouldShowReportView(
        run: run,
        finalReview: false,
        content: content,
      ),
      isTrue,
    );
  });

  test('ReviewContent_WhenVersionFourSourcesOnly_ShowsReport', () {
    const content =
        r'{"version":4,"title":"Laptops","summary":"Options under $800","sources":[{"id":"s1","title":"Acer Aspire 5","url":"https://example.com","publisher":"LebTech","retrievedAtUtc":"2026-08-30T17:40:13Z"}]}';
    final run = _finalReviewRun(content: content);

    expect(SmartPurchaseReviewContent.looksLikePurchaseDecisionReport(content), isTrue);
    expect(
      SmartPurchaseReviewContent.shouldShowReportView(
        run: run,
        finalReview: true,
        content: content,
      ),
      isTrue,
    );
  });
}
