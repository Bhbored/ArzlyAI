import 'package:arzlyai_mobile/core/network/dto/response/workflow/rendered_workflow_result_response.dart';
import 'package:arzlyai_mobile/domain/entities/workflow/workflow_run.dart';

class RenderedWorkflowResultMapper {
  const RenderedWorkflowResultMapper();

  RenderedWorkflowResult? fromDto(RenderedWorkflowResultResponse? dto) {
    if (dto == null) return null;
    return RenderedWorkflowResult(
      mediaType: dto.mediaType,
      content: dto.content,
    );
  }
}
