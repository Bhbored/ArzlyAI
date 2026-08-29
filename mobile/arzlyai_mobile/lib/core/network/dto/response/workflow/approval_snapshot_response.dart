import 'package:freezed_annotation/freezed_annotation.dart';

part 'approval_snapshot_response.freezed.dart';
part 'approval_snapshot_response.g.dart';

@freezed
sealed class ApprovalSnapshotResponse with _$ApprovalSnapshotResponse {
  const factory ApprovalSnapshotResponse({
    required String originalContent,
    required String currentContent,
    required bool wasEdited,
  }) = _ApprovalSnapshotResponse;

  factory ApprovalSnapshotResponse.fromJson(Map<String, dynamic> json) =>
      _$ApprovalSnapshotResponseFromJson(json);
}
