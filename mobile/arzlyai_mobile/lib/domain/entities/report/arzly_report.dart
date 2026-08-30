import 'package:freezed_annotation/freezed_annotation.dart';

part 'arzly_report.freezed.dart';

@freezed
sealed class ArzlyReport with _$ArzlyReport {
  const factory ArzlyReport({
    required String schema,
    required int version,
    required String kind,
    required String title,
    required String summary,
    required String generatedAtUtc,
    required List<ArzlyReportBlock> blocks,
    required List<ArzlyReportSource> sources,
  }) = _ArzlyReport;
}

@freezed
sealed class ArzlyReportBlock with _$ArzlyReportBlock {
  const factory ArzlyReportBlock({
    required String type,
    required String title,
    required ArzlyReportBlockData data,
  }) = _ArzlyReportBlock;
}

@freezed
sealed class ArzlyReportBlockData with _$ArzlyReportBlockData {
  const factory ArzlyReportBlockData({
    @Default('') String text,
    @Default(<ArzlyReportItem>[]) List<ArzlyReportItem> items,
    @Default(<ArzlyReportMetric>[]) List<ArzlyReportMetric> metrics,
  }) = _ArzlyReportBlockData;
}

@freezed
sealed class ArzlyReportItemAction with _$ArzlyReportItemAction {
  const factory ArzlyReportItemAction({
    required String storeName,
    required String label,
    String? availability,
    required String url,
  }) = _ArzlyReportItemAction;
}

@freezed
sealed class ArzlyReportItem with _$ArzlyReportItem {
  const factory ArzlyReportItem({
    required String label,
    required String value,
    required String detail,
    String? url,
    String? imageUrl,
    String? actionLabel,
    @Default(<ArzlyReportItemAction>[]) List<ArzlyReportItemAction> actions,
  }) = _ArzlyReportItem;
}

@freezed
sealed class ArzlyReportMetric with _$ArzlyReportMetric {
  const factory ArzlyReportMetric({
    required String label,
    required double value,
    required double maximum,
  }) = _ArzlyReportMetric;
}

@freezed
sealed class ArzlyReportSource with _$ArzlyReportSource {
  const factory ArzlyReportSource({
    required String id,
    required String title,
    required String url,
    required String publisher,
    required String retrievedAtUtc,
  }) = _ArzlyReportSource;
}
