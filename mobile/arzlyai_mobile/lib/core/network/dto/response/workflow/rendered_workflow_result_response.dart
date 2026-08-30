import 'package:freezed_annotation/freezed_annotation.dart';

part 'rendered_workflow_result_response.freezed.dart';
part 'rendered_workflow_result_response.g.dart';

@freezed
sealed class RenderedWorkflowResultResponse with _$RenderedWorkflowResultResponse {
  const factory RenderedWorkflowResultResponse({
    required String mediaType,
    required String content,
  }) = _RenderedWorkflowResultResponse;

  factory RenderedWorkflowResultResponse.fromJson(Map<String, dynamic> json) =>
      _$RenderedWorkflowResultResponseFromJson(json);
}
