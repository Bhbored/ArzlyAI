// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_snapshot_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApprovalSnapshotResponse _$ApprovalSnapshotResponseFromJson(
  Map<String, dynamic> json,
) => _ApprovalSnapshotResponse(
  originalContent: json['originalContent'] as String,
  currentContent: json['currentContent'] as String,
  wasEdited: json['wasEdited'] as bool,
);

Map<String, dynamic> _$ApprovalSnapshotResponseToJson(
  _ApprovalSnapshotResponse instance,
) => <String, dynamic>{
  'originalContent': instance.originalContent,
  'currentContent': instance.currentContent,
  'wasEdited': instance.wasEdited,
};
