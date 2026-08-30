import 'package:freezed_annotation/freezed_annotation.dart';

part 'approval_configuration.freezed.dart';

@freezed
sealed class ApprovalNodeConfiguration with _$ApprovalNodeConfiguration {
  const factory ApprovalNodeConfiguration({
    @Default('Accept') String acceptLabel,
    @Default('Edit') String editLabel,
    @Default('Reject') String rejectLabel,
  }) = _ApprovalNodeConfiguration;
}
