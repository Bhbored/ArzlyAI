import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run_support.dart';
import 'package:arzlyai_mobile/domain/mappers/report/arzly_report_mapper.dart';

class SmartPurchaseReviewContent {
  const SmartPurchaseReviewContent._();

  static bool isFinalReview({
    required PresetDetails? preset,
    required WorkflowRun? run,
    required WorkflowNode? waitingNode,
    required String content,
  }) {
    if (run == null) return false;
    if (waitingNode?.resultContract != null) return true;
    if (waitingNode?.key == 'review-pick') return true;
    if (waitingNode?.approvalConfiguration?.acceptLabel == 'Looks good') {
      return true;
    }
    if (looksLikePurchaseDecisionReport(content)) return true;
    final index = run.waitingApprovalIndex();
    if (index == null) return false;
    if (run.nodes[index].nodeKey == 'review-pick') return true;
    if (preset == null) return !run.hasRemainingWorkAfterApproval(index);
    return !run.hasRemainingWorkAfterApproval(index);
  }

  static bool looksLikePurchaseDecisionReport(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return false;
    if (trimmed.contains('purchaseDecision')) return true;
    if (trimmed.contains('"schema":"arzly.report"') ||
        trimmed.contains('"schema": "arzly.report"')) {
      return true;
    }
    if (trimmed.contains('"blocks"')) return true;
    if (trimmed.contains('"sources"') && _containsVersionFour(trimmed)) {
      return true;
    }
    return false;
  }

  static bool looksLikeStructuredJson(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return false;
    if (trimmed.startsWith('{') || trimmed.startsWith('[')) return true;
    return trimmed.contains('```json') || trimmed.contains('{"');
  }

  static bool _containsVersionFour(String content) {
    return RegExp(r'"version"\s*:\s*"?4"?').hasMatch(content);
  }

  static bool shouldShowReportView({
    required WorkflowRun? run,
    required bool finalReview,
    required String content,
  }) {
    if (run == null) return false;
    if (finalReview) return true;
    return looksLikePurchaseDecisionReport(content) ||
        const ArzlyReportMapper().fromJsonString(content) != null;
  }
}
